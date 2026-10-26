// =============================================================================
// WHAT : TAXI: full-screen map where the rider moves the map under a centre
//        pin to choose the pickup or drop; the address and pincode of the
//        pinned spot are shown and returned when the rider confirms.
// NOTES: Addresses come from the phone's own geocoder (no key needed).
//        Also holds describePlace(), which turns a position into a TaxiPlace.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/constants.dart';
import 'taxiApi.dart';

// >>> START: describePlace - turns a position into an address and pincode
/// Address and pincode of a position, or null when the phone cannot find one.
Future<TaxiPlace?> describePlace(double lat, double lng) async {
  try {
    final marks = await placemarkFromCoordinates(lat, lng);
    if (marks.isEmpty) return null;
    final m = marks.first;
    final parts = <String>[
      if ((m.name ?? '').isNotEmpty) m.name!,
      if ((m.subLocality ?? '').isNotEmpty) m.subLocality!,
      if ((m.locality ?? '').isNotEmpty) m.locality!,
    ];
    final address = parts.isEmpty ? (m.street ?? 'Selected location') : parts.join(', ');
    var pin = (m.postalCode ?? '').trim();
    if (pin.isEmpty) {
      final found = RegExp(r'\b\d{6}\b').firstMatch(address);
      pin = found?.group(0) ?? '';
    }
    return TaxiPlace(address, lat, lng, pin);
  } catch (_) {
    return null;
  }
}
// <<< END: describePlace - turns a position into an address and pincode

// >>> START: currentPlace - where the phone is now
/// The phone's current position as a TaxiPlace, or null (no permission / GPS off).
Future<TaxiPlace?> currentPlace() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return await describePlace(pos.latitude, pos.longitude);
  } catch (_) {
    return null;
  }
}
// <<< END: currentPlace - where the phone is now

// >>> START: TaxiPlacePicker - choose a place by moving the map under a pin
class TaxiPlacePicker extends StatefulWidget {
  const TaxiPlacePicker(
      {Key? key, required this.title, required this.start, this.pickup = false})
      : super(key: key);
  final String title;
  final LatLng start;
  // true: the pin is green (pickup); false: red (drop).
  final bool pickup;

  @override
  State<TaxiPlacePicker> createState() => _TaxiPlacePickerState();
}

class _TaxiPlacePickerState extends State<TaxiPlacePicker> {
  GoogleMapController? _map;
  late LatLng _center = widget.start;
  TaxiPlace? _place;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _lookup();
  }

  // >>> START: _lookup - finds the address of the pinned spot
  Future<void> _lookup() async {
    setState(() => _loading = true);
    final spot = _center;
    final p = await describePlace(spot.latitude, spot.longitude);
    // The map may have moved on while the address was looked up.
    if (!mounted || spot != _center) return;
    setState(() {
      _place = p;
      _loading = false;
    });
  }
  // <<< END: _lookup - finds the address of the pinned spot

  // >>> START: _goToMe - moves the map to the phone's position
  Future<void> _goToMe() async {
    final me = await currentPlace();
    if (me == null || !mounted) return;
    _map?.animateCamera(CameraUpdate.newLatLng(LatLng(me.lat, me.lng)));
  }
  // <<< END: _goToMe - moves the map to the phone's position

  @override
  Widget build(BuildContext context) {
    final pinColor = widget.pickup ? Colors.green : Colors.red;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: widget.start, zoom: 16),
            onMapCreated: (c) => _map = c,
            onCameraMove: (pos) => _center = pos.target,
            onCameraIdle: _lookup,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          // The pin stays in the middle; its tip marks the chosen spot.
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Icon(Icons.location_on, size: 48, color: pinColor),
              ),
            ),
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
          Positioned(
            right: 12,
            bottom: 190,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: _goToMe,
              child: Icon(Icons.my_location, color: tPrimaryColor),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                  Text(widget.title,
                      style: TextStyle(
                          color: tDarkNavyblue,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: pinColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _loading
                              ? 'Finding address...'
                              : (_place?.address ?? 'Address not found'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: tDarkNavyblue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: (_loading || _place == null)
                          ? null
                          : () => Navigator.pop(context, _place),
                      child: const Text('Confirm location',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// <<< END: TaxiPlacePicker - choose a place by moving the map under a pin
