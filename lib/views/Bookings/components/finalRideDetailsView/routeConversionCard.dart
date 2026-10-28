// =============================================================================
// WHAT : "Booked in-city, travelled and billed outstation" card for the closing details of a ride.
// NOTES: Shown only when the server says the ride was converted (radius_converted). It gives the plain-language
//        message (radius_note) and a map of the route the driver recorded, with the pickup and the end point.
//        Data comes with the booking details: radius_converted, radius_note, route_points (list of lat/lng).
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:base_project_flutter/constants/constants.dart';

// >>> START: RouteConversionCard - the message and the route map
class RouteConversionCard extends StatefulWidget {
  const RouteConversionCard({Key? key, required this.rideDetails}) : super(key: key);
  final dynamic rideDetails;

  @override
  State<RouteConversionCard> createState() => _RouteConversionCardState();
}
// <<< END: RouteConversionCard - the message and the route map

// >>> START: _RouteConversionCardState - the data and logic behind its screen
class _RouteConversionCardState extends State<RouteConversionCard> {
  GoogleMapController? _controller;

  // >>> START: _points - the route as map points (bad or missing points are skipped)
  List<LatLng> _points() {
    final raw = widget.rideDetails['route_points'];
    if (raw is! List) return [];
    final out = <LatLng>[];
    for (final p in raw) {
      if (p is! Map) continue;
      final lat = double.tryParse(p['lat'].toString());
      final lng = double.tryParse(p['lng'].toString());
      if (lat != null && lng != null) out.add(LatLng(lat, lng));
    }
    return out;
  }
  // <<< END: _points - the route as map points (bad or missing points are skipped)

  // >>> START: _fit - zooms the map so the whole route is visible
  Future<void> _fit(List<LatLng> points) async {
    if (_controller == null || points.length < 2) return;
    double minLat = points.first.latitude, maxLat = minLat;
    double minLng = points.first.longitude, maxLng = minLng;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    // The map needs a moment to be laid out before it can be fitted.
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      await _controller!.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)), 40));
    } catch (_) {}
  }
  // <<< END: _fit - zooms the map so the whole route is visible

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    if (widget.rideDetails['radius_converted'] != true) return const SizedBox.shrink();
    final points = _points();
    final note = (widget.rideDetails['radius_note'] ?? '').toString();

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: tWhite, borderRadius: BorderRadius.circular(10), boxShadow: [tBoxShadow]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.alt_route, size: 20, color: tPrimaryColor),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    note,
                    style: GoogleFonts.mulish(
                        color: tPrimaryColor, fontWeight: FontWeight.w700, fontSize: 11.sp),
                  ),
                ),
              ],
            ),
            if (points.length >= 2) ...[
              SizedBox(height: 1.5.h),
              Text('Route travelled',
                  style: GoogleFonts.mulish(fontWeight: FontWeight.w700, fontSize: 11.sp)),
              SizedBox(height: 1.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 24.h,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: points.first, zoom: 10),
                    polylines: {
                      Polyline(
                          polylineId: const PolylineId('route'),
                          points: points,
                          color: tPrimaryColor,
                          width: 4),
                    },
                    markers: {
                      Marker(
                          markerId: const MarkerId('pickup'),
                          position: points.first,
                          infoWindow: const InfoWindow(title: 'Pickup'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
                      Marker(
                          markerId: const MarkerId('end'),
                          position: points.last,
                          infoWindow: const InfoWindow(title: 'Ride end'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: (c) {
                      _controller = c;
                      _fit(points);
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _RouteConversionCardState - the data and logic behind its screen
