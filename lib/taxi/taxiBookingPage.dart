// =============================================================================
// WHAT : TAXI (Uber / Rapido style) booking screen of one taxi service (Bike,
//        Auto or Car): a full-screen map with a bottom card. The rider sees
//        the pickup (from GPS), taps "Where to?" to choose the drop on the
//        map, then picks a vehicle of that service with fare, seats and trip
//        time, and books it.
// NOTES: Opens from a service card of TaxiServicesPage, which also reopens a
//        ride still in progress (see TaxiApi.active). Booking sends the rider
//        to TaxiRidePage.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/constants.dart';
import 'taxiApi.dart';
import 'taxiPlacePicker.dart';
import 'taxiRidePage.dart';

// >>> START: TaxiBookingPage - map with "Where to?", the vehicle list and the Book button
class TaxiBookingPage extends StatefulWidget {
  const TaxiBookingPage({Key? key, required this.service}) : super(key: key);

  final TaxiService service;

  @override
  State<TaxiBookingPage> createState() => _TaxiBookingPageState();
}

class _TaxiBookingPageState extends State<TaxiBookingPage> {
  // Hyderabad, until the phone's position is known.
  static const LatLng _fallback = LatLng(17.448294, 78.391487);

  GoogleMapController? _map;
  TaxiPlace? _pickup;
  TaxiPlace? _drop;
  List<TaxiVehicle> _vehicles = [];
  int _selected = 0;
  bool _loadingVehicles = false;
  bool _booking = false;
  String? _message;
  // Cash is the payment used for now.
  static const int _paymentCash = 1;

  @override
  void initState() {
    super.initState();
    _start();
  }

  // >>> START: _start - finds the pickup from GPS
  Future<void> _start() async {
    final me = await currentPlace();
    if (!mounted) return;
    if (me == null) {
      setState(() => _message =
          'Turn on location to set your pickup, or choose it on the map.');
      return;
    }
    setState(() => _pickup = me);
    _map?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(me.lat, me.lng), 15.5));
  }
  // <<< END: _start - finds the pickup from GPS

  // >>> START: _choose - opens the map picker for the pickup or the drop
  Future<void> _choose({required bool pickup}) async {
    final current = pickup ? _pickup : _drop;
    final base = current != null
        ? LatLng(current.lat, current.lng)
        : (_pickup != null ? LatLng(_pickup!.lat, _pickup!.lng) : _fallback);
    final place = await Navigator.push<TaxiPlace>(
        context,
        MaterialPageRoute(
            builder: (_) => TaxiPlacePicker(
                title: pickup ? 'Set pickup location' : 'Where to?',
                start: base,
                pickup: pickup)));
    if (place == null || !mounted) return;
    setState(() {
      if (pickup) {
        _pickup = place;
      } else {
        _drop = place;
      }
      _message = null;
    });
    _fitMap();
    if (_pickup != null && _drop != null) _loadVehicles();
  }
  // <<< END: _choose - opens the map picker for the pickup or the drop

  // >>> START: _fitMap - shows pickup and drop together on the map
  void _fitMap() {
    final p = _pickup, d = _drop;
    if (_map == null || p == null) return;
    if (d == null) {
      _map!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(p.lat, p.lng), 15.5));
      return;
    }
    final south = p.lat < d.lat ? p.lat : d.lat;
    final north = p.lat < d.lat ? d.lat : p.lat;
    final west = p.lng < d.lng ? p.lng : d.lng;
    final east = p.lng < d.lng ? d.lng : p.lng;
    _map!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(south, west), northeast: LatLng(north, east)),
        90));
  }
  // <<< END: _fitMap - shows pickup and drop together on the map

  // >>> START: _loadVehicles - asks this taxi service for vehicles and fares
  Future<void> _loadVehicles() async {
    final p = _pickup, d = _drop;
    if (p == null || d == null) return;
    setState(() {
      _loadingVehicles = true;
      _vehicles = [];
      _selected = 0;
      _message = null;
    });
    final list = await TaxiApi.vehicles(p, d, widget.service);
    if (!mounted) return;
    setState(() {
      _vehicles = list;
      _loadingVehicles = false;
      if (list.isEmpty) {
        _message = (p.pincode.isEmpty || d.pincode.isEmpty)
            ? 'We could not find the pincode of this place. Try another spot.'
            : 'No ${widget.service.label} rides are available for this route yet.';
      }
    });
  }
  // <<< END: _loadVehicles - asks this taxi service for vehicles and fares

  // >>> START: _book - requests the chosen vehicle and opens the ride screen
  Future<void> _book() async {
    if (_booking || _vehicles.isEmpty) return;
    final v = _vehicles[_selected];
    setState(() => _booking = true);
    final res = await TaxiApi.requestRide(v, _pickup!, _drop!, _paymentCash);
    if (!mounted) return;
    if (res['ride'] != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => TaxiRidePage(
                  serviceKey: v.service.key,
                  rideId: (res['ride'] as Map)['id'].toString())));
      return;
    }
    setState(() => _booking = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res['error'].toString())));
  }
  // <<< END: _book - requests the chosen vehicle and opens the ride screen

  Set<Marker> get _markers => {
        if (_pickup != null)
          Marker(
              markerId: const MarkerId('pickup'),
              position: LatLng(_pickup!.lat, _pickup!.lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen)),
        if (_drop != null)
          Marker(
              markerId: const MarkerId('drop'),
              position: LatLng(_drop!.lat, _drop!.lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed)),
      };

  // >>> START: _placeRow - one line of the trip card (pickup or drop)
  Widget _placeRow(
      {required Color dot,
      required String label,
      required TaxiPlace? place,
      required VoidCallback onTap,
      required String empty}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(Icons.circle, size: 12, color: dot),
          const SizedBox(width: 12),
          Expanded(
            child: Text(place?.address ?? empty,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: place == null ? Colors.grey : tDarkNavyblue,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ),
          Icon(Icons.edit_outlined, size: 18, color: tPrimaryColor),
        ]),
      ),
    );
  }
  // <<< END: _placeRow - one line of the trip card (pickup or drop)

  // >>> START: _vehicleTile - one Bike / Auto / Taxi option
  Widget _vehicleTile(int i) {
    final v = _vehicles[i];
    final on = i == _selected;
    final details = [
      if (v.timeText.isNotEmpty) v.timeText,
      '${v.seats} ${v.seats == 1 ? 'seat' : 'seats'}',
      if (v.distanceText.isNotEmpty) v.distanceText,
    ].join('  ·  ');
    return GestureDetector(
      onTap: () => setState(() => _selected = i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: on ? tPrimaryColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: on ? tPrimaryColor : Colors.black12, width: on ? 2 : 1),
        ),
        child: Row(children: [
          SizedBox(
            width: 64,
            height: 48,
            child: Image.network(v.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.local_taxi, size: 36, color: tDarkNavyblue)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.title,
                  style: TextStyle(
                      color: tDarkNavyblue,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(details,
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ]),
          ),
          Text('$currencySymbol${v.fare.toStringAsFixed(0)}',
              style: TextStyle(
                  color: tDarkNavyblue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }
  // <<< END: _vehicleTile - one Bike / Auto / Taxi option

  @override
  Widget build(BuildContext context) {
    final hasTrip = _pickup != null && _drop != null;
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: _fallback, zoom: 14),
          onMapCreated: (c) {
            _map = c;
            _fitMap();
          },
          markers: _markers,
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
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.68),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [tBoxShadow],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 12),
                Text(
                    hasTrip
                        ? 'Choose your ${widget.service.label}'
                        : 'Where to?',
                    style: TextStyle(
                        color: tDarkNavyblue,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                _placeRow(
                    dot: Colors.green,
                    label: 'Pickup',
                    place: _pickup,
                    empty: 'Set pickup location',
                    onTap: () => _choose(pickup: true)),
                const Divider(height: 1),
                _placeRow(
                    dot: Colors.red,
                    label: 'Drop',
                    place: _drop,
                    empty: 'Search destination on the map',
                    onTap: () => _choose(pickup: false)),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(_message!,
                        style: const TextStyle(color: Colors.redAccent)),
                  ),
                if (hasTrip) ...[
                  const SizedBox(height: 10),
                  if (_loadingVehicles)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_vehicles.isNotEmpty)
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _vehicles.length,
                        itemBuilder: (_, i) => _vehicleTile(i),
                      ),
                    ),
                  if (_vehicles.isNotEmpty) ...[
                    Row(children: [
                      Icon(Icons.payments_outlined, color: tPrimaryColor),
                      const SizedBox(width: 8),
                      Text('Cash',
                          style: TextStyle(
                              color: tDarkNavyblue,
                              fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text('Pay the taxi driver at the end of the ride',
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 12)),
                    ]),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: tPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: _booking ? null : _book,
                        child: _booking
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: Colors.white))
                            : Text(
                                'Book ${_vehicles[_selected].title}  ·  $currencySymbol${_vehicles[_selected].fare.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
// <<< END: TaxiBookingPage - map with "Where to?", the vehicle list and the Book button
