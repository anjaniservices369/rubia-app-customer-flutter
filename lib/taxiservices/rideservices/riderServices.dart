// =============================================================================
// WHAT : TAXI: keeps the current ride up to date by asking the server for its
//        status every 3 seconds (class RideService). Replaces the old cloud
//        live database.
// NOTES: Also stores the active ride id on the phone so the ride resumes after
//        a restart.
// =============================================================================
import 'dart:async';
import 'dart:convert';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// >>> START: RideService - keeps the open taxi ride up to date by asking the server every 3 seconds
/// Live ride state, backed by the Rubia REST API.
///
/// Dispatch is done by the backend (`auto-assign`), and the ride state is read
/// by polling `ride-request-detail`. The id of the ride that is currently open
/// is kept in [SharedPreferences] so the ride resumes after an app restart.
class RideService {
  // The key under which the open ride's id is saved on the phone.
  static const String _activeRideKey = 'active_ride_id';
  // How often the ride status is asked from the server.
  static const Duration pollInterval = Duration(seconds: 3);

  // ---- active ride bookkeeping -------------------------------------------

  // >>> START: setActiveRide - remembers which ride is open on this phone
  /// Remember which ride is open (called right after booking).
  static Future<void> setActiveRide(dynamic rideId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeRideKey, rideId.toString());
  }
  // <<< END: setActiveRide - remembers which ride is open on this phone

  // >>> START: activeRideId - returns the id of the open ride, if any
  /// The id of the open ride, or null when there is none.
  static Future<String?> activeRideId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeRideKey);
  }
  // <<< END: activeRideId - returns the id of the open ride, if any

  // >>> START: clearActiveRide - forgets the open ride (finished or cancelled)
  /// Forget the open ride (finished or cancelled).
  static Future<void> clearActiveRide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeRideKey);
  }
  // <<< END: clearActiveRide - forgets the open ride (finished or cancelled)

  // >>> START: hasOpenRide - tells whether a ride is still running on the server
  /// True when a ride that is still running exists on the server. A finished
  /// or cancelled ride is forgotten.
  Future<bool> hasOpenRide() async {
    // 1. No saved ride id means no open ride.
    final rideId = await activeRideId();
    if (rideId == null) return false;
    // 2. Ask the server for the ride's current status.
    final res = await UserAPI().rideRequestDetail(rideId);
    if (res is Map && res['status'] == 'OK' && res['details'] is Map) {
      final status =
          int.tryParse((res['details'] as Map)['status'].toString()) ?? 0;
      // 3. These statuses mean the ride is over.
      const finished = [
        TAXI_STATUS_CANCEL_BY_USER,
        TAXI_STATUS_CANCEL_BY_SKIPPER,
        TAXI_STATUS_AMOUNT_COLLECTED,
        TAXI_STATUS_RATING_COMPLETED,
      ];
      // 4. Any other status: the ride is still running.
      if (!finished.contains(status)) return true;
      // 5. Over: forget it so a new booking can be made.
      await clearActiveRide();
    }
    return false;
  }
  // <<< END: hasOpenRide - tells whether a ride is still running on the server

  // ---- mapping ------------------------------------------------------------

  // >>> START: toRideData - converts the server reply into what the ride screens read
  /// Converts the `ride-request-detail` payload into the map shape the ride UI
  /// already consumes (`status`, `ride_id`, `driver`, `otp`, ...).
  static Map<String, dynamic> toRideData(Map details) {
    // The server nests the driver and the customer; read them defensively.
    final driver = details['driver'] is Map ? details['driver'] as Map : {};
    final user = details['user'] is Map ? details['user'] as Map : {};
    final driverId =
        (details['driver_id'] ?? driver['driver_id'] ?? driver['id'] ?? '')
            .toString();
    return {
      // Which ride and its current status number (see constants.dart).
      'ride_id': details['id'],
      'status': int.tryParse(details['status'].toString()) ??
          TAXI_STATUS_NEW_REQUEST,
      // Where from and where to.
      'pickup_address': details['pickup_address'],
      'pickup_pincode': details['pickup_pincode'],
      'pickup_latitude': details['pickup_latitude'],
      'pickup_longitude': details['pickup_longitude'],
      'drop_address': details['drop_address'],
      'drop_pincode': details['drop_pincode'],
      'drop_latitude': details['drop_latitude'],
      'drop_longitude': details['drop_longitude'],
      // Money and payment.
      'ride_fare': (details['total_fare'] ?? details['ride_fare']).toString(),
      'payment_method': details['payment_method'],
      'payment_status': details['payment_status'],
      // The code the customer tells the driver to start the ride.
      'otp': details['otp'],
      // Who is involved.
      'userId': (user['id'] ?? details['user_id'] ?? '').toString(),
      'skipperId': driverId,
      'vehical_id': details['vehical_type'],
      // The driver card: name, photo, contact, vehicle and live position.
      'driver': {
        'id': driverId,
        'name': driver['name'],
        'profile_image': driver['profile_image'],
        'driver_contact': driver['contact_no'],
        'vehicle_number': driver['vehical_number'],
        'vehicle_type': driver['vehical'],
        'latitude': driver['latitude'] ?? driver['lat'],
        'longitude': driver['longitude'] ?? driver['lng'],
      },
    };
  }
  // <<< END: toRideData - converts the server reply into what the ride screens read

  // ---- polling ------------------------------------------------------------

  // >>> START: rideStream - a live feed of the ride: emits again whenever its status changes
  /// Emits the open ride whenever it changes, or null when there is none.
  Stream<Map<String, dynamic>?> rideStream({String? uid}) async* {
    // The last value we sent out, so identical updates are not repeated.
    String? last;
    while (true) {
      Map<String, dynamic>? data;
      bool failed = false;
      // 1. Is there an open ride on this phone?
      final rideId = await activeRideId();
      if (rideId != null) {
        // 2. Ask the server for its latest state.
        final res = await UserAPI().rideRequestDetail(rideId);
        if (res is Map && res['status'] == 'OK' && res['details'] is Map) {
          data = toRideData(res['details'] as Map);
          // 3. A cancelled ride ends the live feed and is forgotten.
          final status = data['status'];
          if (status == TAXI_STATUS_CANCEL_BY_USER ||
              status == TAXI_STATUS_CANCEL_BY_SKIPPER) {
            await clearActiveRide();
            data = null;
          }
        } else {
          // Network error or session problem: keep whatever is on screen.
          failed = true;
        }
      }
      // 4. Only tell the screens when something actually changed.
      if (!failed) {
        final encoded = jsonEncode(data);
        if (encoded != last) {
          last = encoded;
          yield data;
        }
      }
      // 5. Wait 3 seconds and ask again.
      await Future.delayed(pollInterval);
    }
  }
  // <<< END: rideStream - a live feed of the ride: emits again whenever its status changes

  // >>> START: driverLocation - gets the driver's latest position for the map
  /// Latest known driver position for [rideId] as `{lat, lng}`, or null when
  /// the backend does not report one.
  Future<Map<String, double>?> driverLocation(dynamic rideId) async {
    // 1. Read the ride; give up if the server does not answer properly.
    final res = await UserAPI().rideRequestDetail(rideId.toString());
    if (res is! Map || res['status'] != 'OK' || res['details'] is! Map) {
      return null;
    }
    // 2. Find the driver block and read its coordinates.
    final driver = (res['details'] as Map)['driver'];
    if (driver is! Map) return null;
    final lat =
        double.tryParse((driver['latitude'] ?? driver['lat'] ?? '').toString());
    final lng = double.tryParse(
        (driver['longitude'] ?? driver['lng'] ?? '').toString());
    // 3. No usable position yet.
    if (lat == null || lng == null) return null;
    return {'lat': lat, 'lng': lng};
  }
  // <<< END: driverLocation - gets the driver's latest position for the map

  // ---- lifecycle (kept with the old names so call sites stay unchanged) ---

  // >>> START: removeDocument - forgets the open ride (name kept from the older code)
  /// The ride is finished or cancelled: forget it locally. The server already
  /// holds the final state (cancel-ride / rating endpoints).
  Future<bool> removeDocument({String? uid, String? skipperId}) async {
    await clearActiveRide();
    return true;
  }
  // <<< END: removeDocument - forgets the open ride (name kept from the older code)

  // >>> START: removeSkipperRequest - forgets the open ride (name kept from the older code)
  /// Same as [removeDocument]; the name is kept for older call sites.
  Future<bool> removeSkipperRequest(context) async {
    await clearActiveRide();
    return true;
  }
  // <<< END: removeSkipperRequest - forgets the open ride (name kept from the older code)

  // >>> START: removeMiddleSkipperRequest - forgets the open ride (name kept from the older code)
  /// Same as [removeDocument]; the name is kept for older call sites.
  Future<bool> removeMiddleSkipperRequest(
      {String? uid, String? skipperId}) async {
    await clearActiveRide();
    return true;
  }
  // <<< END: removeMiddleSkipperRequest - forgets the open ride (name kept from the older code)
}
// <<< END: RideService - keeps the open taxi ride up to date by asking the server every 3 seconds
