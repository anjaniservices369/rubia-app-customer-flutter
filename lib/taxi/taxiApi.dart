// =============================================================================
// WHAT : TAXI (Uber / Rapido style): everything the new taxi booking flow asks
//        the server: vehicles with fares, ride request, driver search, live
//        ride status, cancel and rating.
// NOTES: Rubia runs taxi as three services with their own rider addresses:
//        /bike-user, /auto-user and /car-user (each its own backend and
//        database on the server). The rider picks one of them (Bike, Auto,
//        Car) before booking. The id and service of the
//        ride in progress are saved on the phone so the ride resumes.
// =============================================================================
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_services/ApiHelper.dart';
import '../api_services/sessionGuard.dart';
import '../constants/apiConstants.dart';

// >>> START: TaxiService - one of the three taxi services (bike, auto, car)
class TaxiService {
  const TaxiService(this.key, this.path, this.vehicleType, this.label);
  final String key;
  // Rider address of the service: /api/<path>/...
  final String path;
  // vehicle_type the server uses for this service (bike 4, auto 3, car 2).
  final int vehicleType;
  final String label;
}

/// In the order a rider expects them: cheapest first.
const List<TaxiService> taxiServices = [
  TaxiService('bike', 'bike-user', 4, 'Bike'),
  TaxiService('auto', 'auto-user', 3, 'Auto'),
  TaxiService('car', 'car-user', 2, 'Car'),
];

TaxiService taxiServiceByKey(String key) =>
    taxiServices.firstWhere((s) => s.key == key, orElse: () => taxiServices.last);
// <<< END: TaxiService - one of the three taxi services (bike, auto, car)

// >>> START: TaxiPlace - a picked place: address, position and pincode
class TaxiPlace {
  const TaxiPlace(this.address, this.lat, this.lng, this.pincode);
  final String address;
  final double lat;
  final double lng;
  final String pincode;
}
// <<< END: TaxiPlace - a picked place: address, position and pincode

// >>> START: TaxiVehicle - one bookable option in the list (Bike / Auto / Taxi) with its fare
class TaxiVehicle {
  TaxiVehicle(this.service, this.json);
  final TaxiService service;
  final Map json;

  int get id => int.tryParse(json['id'].toString()) ?? 0;
  String get title => (json['title'] ?? service.label).toString();
  String get image => (json['image'] ?? '').toString();
  int get seats => int.tryParse(json['no_of_person'].toString()) ?? 1;
  double get fare => double.tryParse(json['total_fare'].toString()) ?? 0;
  String get distanceText =>
      ((json['driving_distance'] ?? const {})['distance'] ?? '').toString();
  String get timeText =>
      ((json['driving_distance'] ?? const {})['time'] ?? '').toString();
  String get cgst => ((json['gst'] ?? const {})['cgst_amount'] ?? 0).toString();
  String get sgst => ((json['gst'] ?? const {})['sgst_amount'] ?? 0).toString();
}
// <<< END: TaxiVehicle - one bookable option in the list (Bike / Auto / Taxi) with its fare

// >>> START: TaxiApi - requests of the taxi flow
class TaxiApi {
  static const String _activeKey = 'taxi_active_ride';

  // >>> START: _auth - the saved login code
  static Future<String?> _auth() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('authCode');
    return (code == null || code.isEmpty) ? null : code;
  }
  // <<< END: _auth - the saved login code

  // >>> START: vehicles - asks the three services which vehicles serve this trip and at what fare
  /// The vehicles of one taxi service (each service has its own backend), cheapest
  /// first. A service that does not serve the area (or fails) gives an empty list.
  static Future<List<TaxiVehicle>> vehicles(
      TaxiPlace pickup, TaxiPlace drop, TaxiService service) async {
    final auth = await _auth();
    if (auth == null) return [];
    final answers = await Future.wait([service].map((s) async {
      final res = await ApiHelper().getTypePostBG(
          '/${s.path}/get-vehicles?auth_code=$auth', {
        'pickup_pincode': pickup.pincode,
        'drop_pincode': drop.pincode,
        'pickup_latitude': pickup.lat.toString(),
        'pickup_longitude': pickup.lng.toString(),
        'drop_latitude': drop.lat.toString(),
        'drop_longitude': drop.lng.toString(),
        'vehicle_type': s.vehicleType.toString(),
      });
      final out = <TaxiVehicle>[];
      if (res is Map && res['status'] == 'OK' && res['details'] is List) {
        for (final v in res['details'] as List) {
          if (v is Map) out.add(TaxiVehicle(s, v));
        }
      }
      return out;
    }));
    final all = answers.expand((e) => e).toList()
      ..sort((a, b) => a.fare.compareTo(b.fare));
    return all;
  }
  // <<< END: vehicles - asks the three services which vehicles serve this trip and at what fare

  // >>> START: requestRide - creates the ride request and offers it to nearby drivers
  /// Returns {'ride': ...} with the ride as sent by the server, or {'error': text}.
  static Future<Map<String, dynamic>> requestRide(TaxiVehicle v,
      TaxiPlace pickup, TaxiPlace drop, int paymentMethod) async {
    final auth = await _auth();
    if (auth == null) return {'error': 'Please log in again.'};
    final res = await ApiHelper()
        .getTypePostBG('/${v.service.path}/ride-request?auth_code=$auth', {
      'vehical_id': v.id.toString(),
      'ride_fare': v.fare.toString(),
      'pickup_address': pickup.address,
      'pickup_pincode': pickup.pincode,
      'pickup_latitude': pickup.lat.toString(),
      'pickup_longitude': pickup.lng.toString(),
      'drop_address': drop.address,
      'drop_pincode': drop.pincode,
      'drop_latitude': drop.lat.toString(),
      'drop_longitude': drop.lng.toString(),
      'payment_method': paymentMethod.toString(),
      'cgst': v.cgst,
      'sgst': v.sgst,
    });
    if (res is Map && res['status'] == 'OK' && res['details'] is Map) {
      final ride = Map<String, dynamic>.from(res['details'] as Map);
      await saveActive(v.service.key, ride['id'].toString());
      // Offer the ride to the nearby drivers right away.
      await assign(v.service, ride['id'].toString());
      return {'ride': ride};
    }
    return {
      'error': (res is Map && res['error'] != null)
          ? res['error'].toString()
          : 'Could not book the ride. Please try again.'
    };
  }
  // <<< END: requestRide - creates the ride request and offers it to nearby drivers

  // >>> START: assign - asks the server to offer the ride to nearby drivers
  /// Safe to repeat: the server offers the ride again to drivers who have not
  /// seen it. Returns the server's reply (or null).
  static Future<dynamic> assign(TaxiService s, String rideId) async {
    final auth = await _auth();
    if (auth == null) return null;
    try {
      final r = await http
          .get(Uri.parse(apiBaseUrl +
              '/${s.path}/auto-assign?auth_code=$auth&ride_id=$rideId'))
          .timeout(const Duration(seconds: 30));
      return r.statusCode == 200 ? json.decode(r.body) : null;
    } catch (_) {
      return null;
    }
  }
  // <<< END: assign - asks the server to offer the ride to nearby drivers

  // >>> START: rideDetail - the ride as it is now (polled every few seconds)
  /// Returns the ride map, or null when the server could not be reached.
  static Future<Map<String, dynamic>?> rideDetail(
      TaxiService s, String rideId) async {
    final auth = await _auth();
    if (auth == null) return null;
    try {
      final r = await http
          .get(Uri.parse(apiBaseUrl +
              '/${s.path}/ride-request-detail?auth_code=$auth&rideRequestId=$rideId'))
          .timeout(const Duration(seconds: 10));
      if (r.statusCode != 200) return null;
      final body = json.decode(r.body);
      await SessionGuard.handle(body);
      if (body is Map && body['status'] == 'OK' && body['details'] is Map) {
        return Map<String, dynamic>.from(body['details'] as Map);
      }
    } catch (_) {}
    return null;
  }
  // <<< END: rideDetail - the ride as it is now (polled every few seconds)

  // >>> START: cancel - cancels the ride before it starts
  /// Returns null when cancelled, else the reason it could not be.
  static Future<String?> cancel(TaxiService s, String rideId) async {
    final auth = await _auth();
    if (auth == null) return 'Please log in again.';
    final res = await ApiHelper().getTypePostBG(
        '/${s.path}/cancel-ride?auth_code=$auth', {'ride_id': rideId});
    if (res is Map && res['status'] == 'OK') {
      await clearActive();
      return null;
    }
    return (res is Map && res['error'] != null)
        ? res['error'].toString()
        : 'Could not cancel. Please try again.';
  }
  // <<< END: cancel - cancels the ride before it starts

  // >>> START: rate - rates the driver of a completed ride
  /// Returns null when saved, else the reason it was not.
  static Future<String?> rate(
      TaxiService s, String rideId, double rating, String review) async {
    final auth = await _auth();
    if (auth == null) return 'Please log in again.';
    final res = await ApiHelper().getTypePostBG(
        '/${s.path}/add-rating?auth_code=$auth', {
      'ride_id': rideId,
      'rating': rating.round().clamp(1, 5).toString(),
      'review': review,
    });
    if (res is Map && res['status'] == 'OK') return null;
    return (res is Map && res['error'] != null)
        ? res['error'].toString()
        : 'Could not save the rating. Please try again.';
  }
  // <<< END: rate - rates the driver of a completed ride

  // >>> START: saveActive / active / clearActive - the ride in progress, kept on the phone
  static Future<void> saveActive(String serviceKey, String rideId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeKey, '$serviceKey:$rideId');
  }

  /// The saved ride as {service, id}, or null.
  static Future<Map<String, String>?> active() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_activeKey);
    if (v == null || !v.contains(':')) return null;
    final i = v.indexOf(':');
    return {'service': v.substring(0, i), 'id': v.substring(i + 1)};
  }

  static Future<void> clearActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeKey);
  }
  // <<< END: saveActive / active / clearActive - the ride in progress, kept on the phone
}
// <<< END: TaxiApi - requests of the taxi flow
