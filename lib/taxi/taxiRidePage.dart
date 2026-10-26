// =============================================================================
// WHAT : TAXI (Uber / Rapido style) ride screen. After booking it follows the
//        ride on a map and changes its bottom card with the ride's status:
//        finding a driver (with Cancel) -> driver on the way (driver, vehicle,
//        OTP, call) -> ride in progress -> ride completed (fare, rating).
// NOTES: Asks the server for the ride every 3 seconds and offers it to nearby
//        drivers again every 30 seconds while nobody has accepted. Status
//        numbers match RideRequest::STATUS_* on the server (TAXI_STATUS_*).
// =============================================================================
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import '../views/bottomNavigation.dart/bottomNavigation.dart';
import 'taxiApi.dart';

// >>> START: TaxiRidePage - follows one taxi ride from "finding a driver" to the rating
class TaxiRidePage extends StatefulWidget {
  const TaxiRidePage({Key? key, required this.serviceKey, required this.rideId})
      : super(key: key);
  final String serviceKey;
  final String rideId;

  @override
  State<TaxiRidePage> createState() => _TaxiRidePageState();
}

class _TaxiRidePageState extends State<TaxiRidePage>
    with SingleTickerProviderStateMixin {
  late final TaxiService _service = taxiServiceByKey(widget.serviceKey);
  late final AnimationController _radar =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();
  Timer? _poll;
  GoogleMapController? _map;
  Map<String, dynamic>? _ride;
  int _ticks = 0;
  bool _busy = false;
  double _rating = 5;
  final TextEditingController _review = TextEditingController();

  int get _status => int.tryParse('${_ride?['status']}') ?? 0;
  bool get _searching => _status == 1 || _status == 2 || _ride == null;
  bool get _assigned => _status == 4 || _status == 5 || _status == 6;
  bool get _started => _status == 8;
  bool get _completed => _status == 9 || _status == 10;
  bool get _cancelled => _status == 3 || _status == 7;

  @override
  void initState() {
    super.initState();
    _refresh();
    _poll = Timer.periodic(const Duration(seconds: 3), (_) => _refresh());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _radar.dispose();
    _review.dispose();
    super.dispose();
  }

  // >>> START: _refresh - reads the ride from the server and reacts to its status
  Future<void> _refresh() async {
    final ride = await TaxiApi.rideDetail(_service, widget.rideId);
    if (!mounted || ride == null) return;
    _ticks++;
    final before = _status;
    setState(() => _ride = ride);
    // Offer the ride to nearby drivers again about every 30 seconds.
    if (_searching && _ticks % 10 == 0) TaxiApi.assign(_service, widget.rideId);
    if (_cancelled) {
      _poll?.cancel();
      TaxiApi.clearActive();
    }
    if (_completed) _poll?.cancel();
    // Show the trip when the ride first loads and whenever its stage changes.
    if (_ticks == 1 || before != _status) _fitTrip();
  }
  // <<< END: _refresh - reads the ride from the server and reacts to its status

  // >>> START: _fitTrip - keeps the pickup, drop and driver in view
  /// Called when the ride first loads and whenever its status changes.
  void _fitTrip() {
    final r = _ride;
    if (_map == null || r == null) return;
    final points = <LatLng>[];
    void add(String a, String b) {
      final lat = double.tryParse('${r[a]}'), lng = double.tryParse('${r[b]}');
      if (lat != null && lng != null && !(lat == 0 && lng == 0)) points.add(LatLng(lat, lng));
    }

    add('pickup_latitude', 'pickup_longitude');
    add('drop_latitude', 'drop_longitude');
    if (_assigned) add('latitude', 'longitude');
    if (points.isEmpty) return;
    if (points.length == 1) {
      _map!.animateCamera(CameraUpdate.newLatLngZoom(points.first, 15));
      return;
    }
    var south = points.first.latitude, north = south;
    var west = points.first.longitude, east = west;
    for (final p in points) {
      if (p.latitude < south) south = p.latitude;
      if (p.latitude > north) north = p.latitude;
      if (p.longitude < west) west = p.longitude;
      if (p.longitude > east) east = p.longitude;
    }
    _map!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(south, west), northeast: LatLng(north, east)), 80));
  }
  // <<< END: _fitTrip - keeps the pickup, drop and driver in view

  Set<Marker> _markers() {
    final r = _ride;
    if (r == null) return {};
    LatLng? at(String a, String b) {
      final lat = double.tryParse('${r[a]}'), lng = double.tryParse('${r[b]}');
      return (lat == null || lng == null) ? null : LatLng(lat, lng);
    }

    final pickup = at('pickup_latitude', 'pickup_longitude');
    final drop = at('drop_latitude', 'drop_longitude');
    final driver = at('latitude', 'longitude');
    return {
      if (pickup != null)
        Marker(
            markerId: const MarkerId('pickup'),
            position: pickup,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
      if (drop != null)
        Marker(
            markerId: const MarkerId('drop'),
            position: drop,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
      if (_assigned && driver != null)
        Marker(
            markerId: const MarkerId('driver'),
            position: driver,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
    };
  }

  // >>> START: _cancel - asks to cancel the ride and goes Home when it is cancelled
  Future<void> _cancel() async {
    final sure = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text('Cancel this ride?'),
              content: const Text('Your driver will be told that you cancelled.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('No')),
                TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Yes, cancel')),
              ],
            ));
    if (sure != true) return;
    setState(() => _busy = true);
    final error = await TaxiApi.cancel(_service, widget.rideId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      _goHome('Ride cancelled');
    }
  }
  // <<< END: _cancel - asks to cancel the ride and goes Home when it is cancelled

  // >>> START: _submitRating - saves the rating and goes Home
  Future<void> _submitRating() async {
    setState(() => _busy = true);
    final error = await TaxiApi.rate(_service, widget.rideId, _rating, _review.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    await TaxiApi.clearActive();
    _goHome('Thanks for your rating');
  }
  // <<< END: _submitRating - saves the rating and goes Home

  // >>> START: _goHome - opens Home with a short message and no screen behind it
  void _goHome(String message) {
    TaxiApi.clearActive();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BottomNavigation(tabIndexId: 0)),
        (route) => false);
  }
  // <<< END: _goHome - opens Home with a short message and no screen behind it

  String get _fare {
    // total_fare is what the rider pays; final_price is the driver's share.
    final tot = double.tryParse('${_ride?['total_fare']}') ?? 0;
    return '$currencySymbol${tot.toStringAsFixed(0)}';
  }

  // >>> START: _tripLines - pickup and drop of the ride
  Widget _tripLines() {
    final r = _ride;
    Widget line(Color c, String t) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [
            Icon(Icons.circle, size: 11, color: c),
            const SizedBox(width: 10),
            Expanded(
                child: Text(t,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: tDarkNavyblue, fontSize: 14, fontWeight: FontWeight.w600))),
          ]),
        );
    return Column(children: [
      line(Colors.green, '${r?['pickup_address'] ?? ''}'),
      line(Colors.red, '${r?['drop_address'] ?? ''}'),
    ]);
  }
  // <<< END: _tripLines - pickup and drop of the ride

  // >>> START: _searchingCard - "finding your ride" with the radar and Cancel
  Widget _searchingCard() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 110,
        child: AnimatedBuilder(
          animation: _radar,
          builder: (_, __) => Stack(alignment: Alignment.center, children: [
            for (final shift in [0.0, 0.33, 0.66])
              Builder(builder: (_) {
                final t = (_radar.value + shift) % 1;
                return Container(
                  width: 30 + 80 * t,
                  height: 30 + 80 * t,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tPrimaryColor.withOpacity(0.35 * (1 - t))),
                );
              }),
            Icon(Icons.local_taxi, color: tPrimaryColor, size: 30),
          ]),
        ),
      ),
      Text('Finding your ${_service.label.toLowerCase()}...',
          style: TextStyle(
              color: tDarkNavyblue, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      const Text('We are asking nearby drivers to accept your ride.',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 10),
      _tripLines(),
      const SizedBox(height: 6),
      Row(children: [
        Text('Fare $_fare',
            style: TextStyle(
                color: tDarkNavyblue, fontSize: 16, fontWeight: FontWeight.w800)),
        const Spacer(),
        const Text('Pay by cash', style: TextStyle(color: Colors.black45)),
      ]),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: _busy ? null : _cancel,
          child: const Text('Cancel ride',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700)),
        ),
      ),
    ]);
  }
  // <<< END: _searchingCard - "finding your ride" with the radar and Cancel

  // >>> START: _driverCard - driver, vehicle, OTP and call
  Widget _driverCard() {
    final r = _ride!;
    final name = '${r['name'] ?? 'Your driver'}'.trim();
    final vehicle = '${r['vehical'] ?? _service.label}';
    final number = '${r['vehical_number'] ?? ''}';
    final phone = '${r['contact_no'] ?? ''}';
    final image = '${r['profile_image'] ?? ''}';
    final headline = _status == 6
        ? 'Your driver has arrived'
        : _status == 5
            ? 'Your driver is on the way'
            : 'Driver accepted your ride';
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(headline,
          style: TextStyle(color: tDarkNavyblue, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      Row(children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: tPrimaryColor.withOpacity(0.15),
          backgroundImage: image.startsWith('http') ? NetworkImage(image) : null,
          child: image.startsWith('http')
              ? null
              : (name.isEmpty
                  ? Icon(Icons.person, color: tPrimaryColor, size: 30)
                  : Text(name[0].toUpperCase(),
                      style: TextStyle(color: tPrimaryColor, fontSize: 22, fontWeight: FontWeight.w800))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name.isEmpty ? 'Your driver' : name,
                style: TextStyle(color: tDarkNavyblue, fontSize: 17, fontWeight: FontWeight.w800)),
            Text([vehicle, number].where((e) => e.isNotEmpty).join('  ·  '),
                style: const TextStyle(color: Colors.black54)),
          ]),
        ),
        if (phone.isNotEmpty)
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.12),
            child: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: phone)),
            ),
          ),
      ]),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
            color: tPrimaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tPrimaryColor.withOpacity(0.4))),
        child: Row(children: [
          const Expanded(
              child: Text('Share this OTP with your driver to start the ride',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600))),
          Text('${r['otp'] ?? ''}',
              style: TextStyle(
                  color: tPrimaryColor, fontSize: 28, letterSpacing: 4, fontWeight: FontWeight.w900)),
        ]),
      ),
      const SizedBox(height: 10),
      _tripLines(),
      Row(children: [
        Text('Fare $_fare',
            style: TextStyle(color: tDarkNavyblue, fontSize: 16, fontWeight: FontWeight.w800)),
        const Spacer(),
        TextButton(
          onPressed: _busy ? null : _cancel,
          child: const Text('Cancel ride', style: TextStyle(color: Colors.redAccent)),
        ),
      ]),
    ]);
  }
  // <<< END: _driverCard - driver, vehicle, OTP and call

  // >>> START: _startedCard - ride in progress
  Widget _startedCard() {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Enjoy your ride',
          style: TextStyle(color: tDarkNavyblue, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      const Text('You are on your way to the drop location.',
          style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 10),
      _tripLines(),
      const SizedBox(height: 6),
      Text('Fare $_fare  ·  Pay by cash',
          style: TextStyle(color: tDarkNavyblue, fontSize: 16, fontWeight: FontWeight.w800)),
    ]);
  }
  // <<< END: _startedCard - ride in progress

  // >>> START: _completedCard - fare and rating
  Widget _completedCard() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.check_circle, color: Colors.green, size: 44),
      const SizedBox(height: 6),
      Text('You have arrived',
          style: TextStyle(color: tDarkNavyblue, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text('Please pay $_fare to your driver',
          style: TextStyle(color: tPrimaryColor, fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      _tripLines(),
      const SizedBox(height: 8),
      const Text('Rate your driver', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      RatingBar.builder(
        initialRating: _rating,
        minRating: 1,
        allowHalfRating: false,
        itemCount: 5,
        itemSize: 38,
        itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: Colors.orange),
        onRatingUpdate: (v) => _rating = v,
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _review,
        maxLines: 2,
        decoration: InputDecoration(
            hintText: 'Write a review (optional)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: tPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: _busy ? null : _submitRating,
          child: const Text('Submit',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      ),
      TextButton(
        onPressed: () => _goHome('Ride completed'),
        child: const Text('Skip', style: TextStyle(color: Colors.black54)),
      ),
    ]);
  }
  // <<< END: _completedCard - fare and rating

  // >>> START: _cancelledCard - the ride was cancelled
  Widget _cancelledCard() {
    // Status 7 with no driver means the server gave up waiting for one.
    final noDriver = '${_ride?['driver_id'] ?? ''}'.isEmpty ||
        '${_ride?['driver_id']}' == 'null' ||
        '${_ride?['driver_id']}' == '0';
    final title = _status == 7
        ? (noDriver
            ? 'No driver is available right now'
            : 'The driver cancelled the ride')
        : 'Ride cancelled';
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 44),
      const SizedBox(height: 6),
      Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(color: tDarkNavyblue, fontSize: 20, fontWeight: FontWeight.w800)),
      if (_status == 7 && noDriver)
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text('Please try again in a moment.',
              style: TextStyle(color: Colors.black54)),
        ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: tPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () => _goHome('Book another ride any time'),
          child: const Text('Back to Home',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        ),
      ),
    ]);
  }
  // <<< END: _cancelledCard - the ride was cancelled

  @override
  Widget build(BuildContext context) {
    final Widget card = _cancelled
        ? _cancelledCard()
        : _completed
            ? _completedCard()
            : _started
                ? _startedCard()
                : _assigned
                    ? _driverCard()
                    : _searchingCard();
    return WillPopScope(
      // Back leaves the screen; the ride goes on and reopens from Taxi on Home.
      onWillPop: () async => true,
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(17.448294, 78.391487), zoom: 14),
            onMapCreated: (c) {
              _map = c;
              // The ride may have loaded before the map was ready.
              _fitTrip();
            },
            markers: _markers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: tDarkNavyblue),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [tBoxShadow],
              ),
              child: SingleChildScrollView(child: card),
            ),
          ),
        ]),
      ),
    );
  }
}
// <<< END: TaxiRidePage - follows one taxi ride from "finding a driver" to the rating
