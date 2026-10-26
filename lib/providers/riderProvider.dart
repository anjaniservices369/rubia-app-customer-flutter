// =============================================================================
// WHAT : The app's trip memory (class TripOptionsProvider): everything chosen
//        during a booking - pickup, drop, date, time, car type, hours, coupon,
//        payment method, fare estimate.
// NOTES: Also holds the live taxi-ride state. Screens read it to stay in sync
//        as the customer moves through the booking steps.
// =============================================================================

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/taxiservices/Ride/completedride/rideCompleted.dart';
import 'package:base_project_flutter/taxiservices/Ride/start_ride.dart';
import 'package:base_project_flutter/taxiservices/searchlocation/components.dart/riderRating.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api_services/servicesApi.dart';
import '../constants/constants.dart';
import '../taxiservices/Ride/going_to_pickup.dart';
import '../taxiservices/rideDetails.dart';
import '../taxiservices/searchlocation/RideComponents/driver_searching.dart';

// >>> START: TripOptionsProvider - the app's memory of the booking in progress (pickup, drop, time, car, fare...)
class TripOptionsProvider with ChangeNotifier {
  String serviceType = '';
  int serviceVehicleType = 0;
  int serviceRideFare = 0;
  int vehicalId = 0;
  int rideFare = 0;
  String storedServiceValue = '0';
  int tripType = 1;
  int riderType = 1;
  String pickupLatitude = '';
  String pickupLongitude = '';
  String dropLatitude = '';
  String dropLongitude = '';
  String pickupAddress = '';
  String dropAddress = '';
  String currentLatitude = '';
  String currentLongitude = '';
  String currentAddress = '';
  int carType = 1;
  String carModel = '';
  String pickupDate = '';
  String pickupTime = '';
  int usageHours = 2;
  String couponCode = '';
  String estimateFare = '0.0';
  String paymentMethod = '1';
  String isVehicleDamageProtection = '1';
  bool isLoading = false;
  bool isSaveBooking = false;
  String couponDiscount = '0';
  int couponId = 0;
  int locationType = 1;
  int selectedCityId = 0;
  int pickupCityId = 0;
  int dropCityId = 0;

  int selectedIndex = 0;

  // Estimatevalues
  dynamic baseFare = 0.0;
  dynamic baseHour = 0.0;
  dynamic baseKm = 0.0;
  dynamic extraKmCharge = 0.0;
  dynamic extraMinCharge = 0.0;
  dynamic nightCharge = 0.0;
  dynamic nightChargePerNight = 0;
  dynamic nightCharges = 0;
  dynamic outStationCharge = 0.0;
  dynamic additionalCharges = 0.0;
  dynamic estimatedDistance = 0.0;
  dynamic isNightChargeApplicable = 0.0;
  dynamic gst = 0.0;
  dynamic securedFee = 0.0;
  dynamic platFormCharges = 0.0;
  dynamic cancellationCharges = 0.0;
  dynamic userCancellationCharges = 100;
  dynamic finalFare = 0.0;
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};
  List<dynamic> vehicles = [];
  bool isDataLoaded = false;

  //skipper data
  var skipperData;
  var newRideId;

  // >>> START: resetValues - clears the trip values chosen so far
  void resetValues() {
    pickupLatitude = '';
    pickupLongitude = '';
    dropLatitude = '';
    dropLongitude = '';
    pickupAddress = '';
    dropAddress = '';
    polylineCoordinates.clear();
    // Add any other values that need to be reset
    // Remove the drop location marker
    markers.removeWhere((marker) => marker.markerId.value == 'drop');
    // Remove the drop location marker

    notifyListeners();
  }
  // <<< END: resetValues - clears the trip values chosen so far

  // >>> START: resetProviderValues - clears everything after a booking is finished or cancelled
  void resetProviderValues() {
    tripType = 1;
    riderType = 1;
    pickupLatitude = '';
    pickupLongitude = '';
    dropLatitude = '';
    dropLongitude = '';
    pickupAddress = '';
    dropAddress = '';
    carType = 1;
    carModel = '';
    pickupDate = '';
    pickupTime = '';
    usageHours = 2;
    couponCode = '';
    couponId = 0;
    couponDiscount = '0';
    paymentMethod = "1";
    estimateFare = '0.0';
    isVehicleDamageProtection = '1';
    isSaveBooking = false;
    selectedCityId = 0;
    storedServiceValue = '0';
  }
  // <<< END: resetProviderValues - clears everything after a booking is finished or cancelled

  // >>> START: getCurrentLocation - finds the phone's current position and address
  getCurrentLocation(BuildContext context) async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle it accordingly
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle the case when the user denies the location permission permanently
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          "${placemark.name}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";

      Map<String, String> param = {
        'lat': position.latitude.toString(),
        'lng': position.longitude.toString(),
      };
      var res = await UserAPI().checkBoundary(context, param);
      if (res['status'] == "OK") {
        setCityId(res['selected_city_id']);
        setPickupLocation(
          position.latitude.toString(),
          position.longitude.toString(),
          address,
        );
      }
    }
  }
  // <<< END: getCurrentLocation - finds the phone's current position and address

  // >>> START: sendLocation - tells the server the customer's current position
  sendLocation(BuildContext context) async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle it accordingly
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle the case when the user denies the location permission permanently
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          "${placemark.name}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";

      Map<String, String> param = {
        'lat': position.latitude.toString(),
        'lng': position.longitude.toString(),
      };
      var res = await UserAPI().sendLocation(context, param);
      if (res['status'] == "OK") {
        setCityId(res['selected_city_id']);
        setPickupLocation(
          position.latitude.toString(),
          position.longitude.toString(),
          address,
        );
      }
    }
  }
  // <<< END: sendLocation - tells the server the customer's current position

  // >>> START: isRequiredFieldsValid - tells whether all fields needed to book are filled
  bool isRequiredFieldsValid() {
    if (riderType == RIDER_TYPE_ONEWAY) {
      return pickupAddress != null &&
          dropAddress != null &&
          pickupAddress.isNotEmpty &&
          dropAddress.isNotEmpty;
    } else if (riderType == RIDER_TYPE_ROUNDTRIP) {
      return pickupAddress != null && pickupAddress.isNotEmpty;
    }
    return false; // Handle any other cases as needed
  }
  // <<< END: isRequiredFieldsValid - tells whether all fields needed to book are filled

  // >>> START: setServiceType - sets service type
  void setServiceType(String type) {
    serviceType = type;
    notifyListeners();
  }
  // <<< END: setServiceType - sets service type

  // >>> START: setServiceVehicleType - sets service vehicle type
  void setServiceVehicleType(int type) {
    serviceVehicleType = type;
    notifyListeners();
  }
  // <<< END: setServiceVehicleType - sets service vehicle type

  // >>> START: setServiceRideFare - sets service ride fare
  void setServiceRideFare(int type) {
    serviceRideFare = type;
    notifyListeners();
  }
  // <<< END: setServiceRideFare - sets service ride fare

  // >>> START: setSelectedVehicle - sets selected vehicle
  void setSelectedVehicle(int type) {
    selectedIndex = type;
    notifyListeners();
  }
  // <<< END: setSelectedVehicle - sets selected vehicle

  // >>> START: setRideFare - sets ride fare
  void setRideFare(int type) {
    rideFare = type;
    notifyListeners();
  }
  // <<< END: setRideFare - sets ride fare

  // >>> START: setVehicleId - sets vehicle id
  void setVehicleId(int type) {
    vehicalId = type;
    notifyListeners();
  }
  // <<< END: setVehicleId - sets vehicle id

  // >>> START: setFinalFare - sets final fare
  void setFinalFare(dynamic type) {
    finalFare = type;
    notifyListeners();
  }
  // <<< END: setFinalFare - sets final fare

  // >>> START: setStoreServiceValues - sets store service values
  void setStoreServiceValues(String type) {
    storedServiceValue = type;

    notifyListeners();
  }
  // <<< END: setStoreServiceValues - sets store service values

  // >>> START: setLocationType - sets location type
  void setLocationType(int type) {
    locationType = type;
    notifyListeners();
  }
  // <<< END: setLocationType - sets location type

  // >>> START: setCityId - sets city id
  void setCityId(int type) {
    selectedCityId = type;
    notifyListeners();
  }
  // <<< END: setCityId - sets city id

  // >>> START: setDropCityId - sets drop city id
  void setDropCityId(int type) {
    dropCityId = type;
    notifyListeners();
  }
  // <<< END: setDropCityId - sets drop city id

  // >>> START: setPickupCityId - sets pickup city id
  void setPickupCityId(int type) {
    pickupCityId = type;
    notifyListeners();
  }
  // <<< END: setPickupCityId - sets pickup city id

  // >>> START: setSaveBooking - marks whether the next estimate call should save the booking
  void setSaveBooking(bool type) {
    isSaveBooking = type;
    notifyListeners();
  }
  // <<< END: setSaveBooking - marks whether the next estimate call should save the booking

  // >>> START: setpaymentMethod - stores how the customer pays
  void setpaymentMethod(String type) {
    paymentMethod = type;

    notifyListeners();
  }
  // <<< END: setpaymentMethod - stores how the customer pays

  // >>> START: setisVehicleDamageProtection - setis vehicle damage protection
  void setisVehicleDamageProtection(String type) {
    isVehicleDamageProtection = type;

    notifyListeners();
  }
  // <<< END: setisVehicleDamageProtection - setis vehicle damage protection

  // >>> START: setTripType - stores in-city or out-station
  void setTripType(int type) {
    tripType = type;
    notifyListeners();
  }
  // <<< END: setTripType - stores in-city or out-station

  // >>> START: setRiderType - stores one-way or round trip
  void setRiderType(int type) {
    riderType = type;
    notifyListeners();
  }
  // <<< END: setRiderType - stores one-way or round trip

  // >>> START: setPickupLocation - stores the pickup address and coordinates
  void setPickupLocation(String latitude, String longitude, String address) {
    pickupLatitude = latitude;
    pickupLongitude = longitude;
    pickupAddress = address;
    notifyListeners();
  }
  // <<< END: setPickupLocation - stores the pickup address and coordinates

  // >>> START: setDropLocation - stores the drop address and coordinates
  void setDropLocation(String latitude, String longitude, String address) {
    dropLatitude = latitude;
    dropLongitude = longitude;
    dropAddress = address;
    notifyListeners();
  }
  // <<< END: setDropLocation - stores the drop address and coordinates

  // >>> START: setCarType - stores automatic or manual
  void setCarType(int type) {
    carType = type;
    notifyListeners();
  }
  // <<< END: setCarType - stores automatic or manual

  // >>> START: setCarModel - stores the car type (SUV+, SUV, Sedan, Hatchback)
  void setCarModel(String model) {
    carModel = model;
    notifyListeners();
  }
  // <<< END: setCarModel - stores the car type (SUV+, SUV, Sedan, Hatchback)

  // >>> START: setPickupDateTime - stores the chosen pickup date
  void setPickupDateTime(String date) {
    pickupDate = date;

    notifyListeners();
  }
  // <<< END: setPickupDateTime - stores the chosen pickup date

  // >>> START: setPickupTime - stores the chosen pickup time
  void setPickupTime(String time) {
    pickupTime = time;
    notifyListeners();
  }
  // <<< END: setPickupTime - stores the chosen pickup time

  // >>> START: setUsageHours - stores how many hours the driver is needed
  void setUsageHours(int hours) {
    usageHours = hours;
    notifyListeners();
  }
  // <<< END: setUsageHours - stores how many hours the driver is needed

  // >>> START: setCouponCode - stores the coupon code
  void setCouponCode(String code) {
    couponCode = code;
    notifyListeners();
  }
  // <<< END: setCouponCode - stores the coupon code

  // >>> START: setCouponDiscount - stores the coupon discount amount
  void setCouponDiscount(String amount) {
    couponDiscount = amount;
    notifyListeners();
  }
  // <<< END: setCouponDiscount - stores the coupon discount amount

  // >>> START: setEstimatePrice - stores the final estimate shown to the customer
  void setEstimatePrice(String estimate) {
    estimateFare = estimate;
    notifyListeners();
  }
  // <<< END: setEstimatePrice - stores the final estimate shown to the customer

  // >>> START: setEstimate - stores the fare breakdown returned by the server
  void setEstimate(Map<String, dynamic> calculateEstimate) {
    baseFare = calculateEstimate['baseFare'].toString();
    baseHour = calculateEstimate['baseHour'].toString();
    baseKm = calculateEstimate['baseKm'].toString();
    extraKmCharge = calculateEstimate['extraKmCharge'].toString();
    extraMinCharge = calculateEstimate['extraMinCharge'].toString();
    nightCharge = calculateEstimate['nightCharge'].toString();
    // The rate card's charge for one night (the 'nightCharge' above is only
    // the amount that applies to this trip, so it is 0 for a daytime trip).
    nightChargePerNight =
        (calculateEstimate['nightChargePerNight'] ?? 0).toString();
    outStationCharge = calculateEstimate['outStationCharge'].toString();
    additionalCharges = calculateEstimate['additionalCharges'].toString();
    estimatedDistance = calculateEstimate['estimatedDistance'].toString();
    isNightChargeApplicable =
        calculateEstimate['isNightChargeApplicable'].toString();
    gst = calculateEstimate['gst'].toString();

    securedFee = calculateEstimate['securedFee'].toString();
    platFormCharges = calculateEstimate['platformCharges'].toString();
    couponDiscount = couponDiscount.toString();
    cancellationCharges = calculateEstimate['cancellation_charges'].toString();

    notifyListeners();
  }
  // <<< END: setEstimate - stores the fare breakdown returned by the server


  //     // Handle the error here, such as providing a fallback value or showing an error message
  //     // For example:
  //     // parsedEstimateFare = 0.0;
  //   }

  //         parsedCouponDiscount = 0.0;
  //         setCouponDiscount(parsedCouponDiscount.toString());
  //       } else {
  //         print('Error parsing couponDiscount: $e');
  //         // Handle the error as needed
  //     // Handle the case where couponDiscount is null
  //     // For example:
  //     parsedCouponDiscount = 0.0;
  //   }


  // >>> START: getEstimate - asks the server for the fare estimate; with saveBooking=true it also creates the booking
  getEstimate(BuildContext context) async {
    Map<String, String> param = {
      'rider_type': riderType.toString(),
      'trip_type': tripType.toString(),
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'car_type': carType.toString(),
      'car_model': carModel.toString(),
      'pickup_date': pickupDate.toString(),
      'pickup_time': pickupTime.toString(),
      'usage_hours': usageHours.toString(),
      'drop_latitude': dropLatitude,
      'drop_longitude': dropLongitude,
      'pickup_address': pickupAddress,
      'drop_address': dropAddress,
      'coupon_code': couponCode,
      'coupon_discount': couponDiscount.toString(),
      'is_vehicle_damage_protection': isVehicleDamageProtection,
      'payment_method': paymentMethod,
      'city_id': selectedCityId.toString()
    };

    // Check if the 'usage_hours' value is not zero
    if (usageHours != 0) {
      isLoading = true;
      // Make the API request with the 'usage_hours' parameter
      var response =
          await ServicesAPI().getEstimate(context, param, isSaveBooking);
      if (response != null && response['status'] == 'OK') {
        isLoading = false;
        // Get the estimate value from the response
        final estimate = response['estimate'] + response['calculateEstimate']['cancellation_charges'];

        // Update the estimate property in the provider
        this.estimateFare = estimate.toString();
        this.couponDiscount = response['coupon_discount'].toString();
        // // Get the calculateEstimate values from the response
        final calculateEstimate = response['calculateEstimate'];
        this.setEstimate(calculateEstimate);
        this.userCancellationCharges = response['calculateEstimate']['userCancellationCharge'];

        // // Save the values in the corresponding variables
        isLoading = false;

        if (isSaveBooking == true) {
          resetProviderValues();
        }
        // Notify listeners about the changes
        notifyListeners();

        return response;
      } else {
        isLoading = false;
        notifyListeners();
        var reason = (response is Map && response['error'] != null)
            ? response['error'].toString()
            : 'Could not get the fare estimate. Please try again.';
        // Server-side SQL errors are not for the rider.
        if (reason.contains('SQLSTATE') || reason.contains('SQL being executed')) {
          reason = 'Something went wrong on our side. Please try again.';
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(reason)));
        }
      }
    } else {
      isLoading = false;
      // Remove the 'usage_hours' parameter from the map
      param.remove('usage_hours');
      await ServicesAPI().getEstimate(context, param, isSaveBooking);
    }
  }
  // <<< END: getEstimate - asks the server for the fare estimate; with saveBooking=true it also creates the booking

// Apply coupon
  // >>> START: applyCoupon - applies a coupon code and returns the discount
  applyCoupon(BuildContext context, param) async {
    // Call your API or perform the necessary logic to apply the coupon
    // Update the estimatePrice based on the applied coupon
    // Example:
    final response = await ServicesAPI().applyCoupon(context, param);
    if (response['status'] == 'OK') {
      this.couponDiscount = response['details']['coupon_discount'].toString();
      this.couponCode = response['details']['coupon_code'].toString();
      this.couponId = response['details']['coupon_id'];
      getEstimate(context);
      notifyListeners();
      return true;
    } else {
      String errorMessage = response['error'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Coupon Application Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      notifyListeners();
      return false;
    }
  }
  // <<< END: applyCoupon - applies a coupon code and returns the discount

// Apply coupon
  // >>> START: removeCoupon - removes the applied coupon
  removeCoupon(BuildContext context) async {
    // Call your API or perform the necessary logic to apply the coupon
    // Update the estimatePrice based on the applied coupon
    // Example:

    this.couponDiscount = '0';
    this.couponCode = '';
    this.couponId = 0;
    getEstimate(context);

    notifyListeners();
    return true;
  }
  // <<< END: removeCoupon - removes the applied coupon

//   //Get Route
//   Future<void> getRoute() async {
//     if (pickupLatitude.isEmpty ||
//         pickupLongitude.isEmpty ||
//         dropLatitude.isEmpty ||
//         dropLongitude.isEmpty) {
//       return;
//     }


//     LatLng pickupLocation = LatLng(pickupLat, pickupLng);
//     LatLng dropLocation = LatLng(dropLat, dropLng);

//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> result = [];

//     PolylineResult polylineResult =
//         await polylinePoints.getRouteBetweenCoordinates(
//       mapKey, // Replace with your actual API key

//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
// // Update pickup and drop markers
//       position: pickupLocation,
//       position: dropLocation,

//   CameraPosition getInitialCameraPosition() {
//     if (polylineCoordinates.isEmpty) {
//       // If polylineCoordinates is empty, set a default initial position
//       return CameraPosition(
//         target: LatLng(0, 0),
//         zoom: 12,
//       );
//     } else {
//       // Calculate the center point of the polyline coordinates
//         sumLat += coordinate.latitude;
//         sumLng += coordinate.longitude;

//       // Set the camera position at the center of the route
//       return CameraPosition(
//         target: LatLng(avgLat, avgLng),
//         zoom: 12,

  // >>> START: getVehicles - loads the vehicles available between pickup and drop
  getVehicles(BuildContext context) async {
    vehicles = [];
    try {
      Map<String, String> params = {
        'pickup_pincode': '500081',
        'drop_pincode': '500081',
        'pickup_latitude': pickupLatitude.toString(),
        'pickup_longitude': pickupLongitude.toString(),
        'drop_latitude': dropLatitude.toString(),
        'drop_longitude': dropLongitude.toString(),
        'coupon_code': couponCode.toString(),
        //have to change switch case
        'vehicle_type': serviceVehicleType.toString()
        // serviceVehicleType == 'BIKE' ? BIKE.toString() : TAXI.toString(),
      };

      var response = await UserAPI().getVechiles(context, params);

      if (response['status'] == 'OK') {
        vehicles = response['details'];

        notifyListeners();
      } else {
        // Handle error case
      }
    } catch (error) {
      // Handle error case
    }
  }
  // <<< END: getVehicles - loads the vehicles available between pickup and drop

  // >>> START: getRideRequest - creates the taxi ride on the server
  getRideRequest(BuildContext context) async {
    try {
      Map<String, String> params = {
        'vehical_id': serviceVehicleType.toString(),
        'ride_fare': serviceRideFare.toString(),
        'pickup_address': pickupAddress,
        'pickup_pincode': '500081',
        'pickup_latitude': pickupLatitude,
        'pickup_longitude': pickupLongitude,
        'drop_address': dropAddress,
        'drop_pincode': '500081',
        'drop_latitude': dropLatitude,
        'drop_longitude': dropLongitude,
        'payment_method': paymentMethod,
        'cgst': '0',
        'sgst': '0',
        'coupon_code': couponCode,
      };

      var response = await UserAPI().rideRequest(context, params);

      if (response['status'] == 'OK') {
        // Need to get nearby drivers and store the user request and skipper request

        notifyListeners();
        return response;
      } else {
        return response;
        // Handle error case
      }
    } catch (error) {
      // Handle error case
    }
  }
  // <<< END: getRideRequest - creates the taxi ride on the server

// Taxi rides


  Map<String, dynamic>? _rideData;

  Map<String, dynamic>? get rideData => _rideData;

  // >>> START: setRideData - stores the latest status of the open taxi ride
  void setRideData(Map<String, dynamic> data) {
    _rideData = data;
    notifyListeners();
  }
  // <<< END: setRideData - stores the latest status of the open taxi ride

  // Function to return different widgets based on status
  // >>> START: getWidgetForStatus - chooses which card to show for the taxi ride status
  Widget getWidgetForStatus() {
    final int status = _rideData?['status'] as int;
    switch (status) {
      case TAXI_STATUS_COMPLETE_RIDE:
        return RideCompletedScreen(
          rideData: _rideData,
        );
      case TAXI_STATUS_ACCEPTED_BY_SKIPPER:
        return Riderdetails(rideData: _rideData);
      case TAXI_STATUS_CANCEL_BY_SKIPPER:
        return Text('Hi');
      case TAXI_STATUS_ON_THE_WAY:
        return Riderdetails(rideData: _rideData);

      case TAXI_STATUS_ARRIVED:
        return Riderdetails(rideData: _rideData);

      case TAXI_STATUS_START_RIDE:
        return Riderdetails(rideData: _rideData);

      case TAXI_STATUS_NEW_REQUEST:
        return DriverSearch(rideData: _rideData);
      case TAXI_STATUS_RIDE_BOOKED:
      case TAXI_STATUS_CANCEL_BY_USER:
        return Text('Hi');

      case TAXI_STATUS_AMOUNT_COLLECTED:
        return AddRating(
          rideData: _rideData,
        );

      case TAXI_STATUS_RATING_COMPLETED:

      default:
        return Text('Hi');
    }
  }
  // <<< END: getWidgetForStatus - chooses which card to show for the taxi ride status

  // >>> START: getMapWidgetForStatus - chooses which map to show for the taxi ride status
  Widget getMapWidgetForStatus() {
    final int status = _rideData?['status'] as int;
    switch (status) {
      case TAXI_STATUS_COMPLETE_RIDE:

      case TAXI_STATUS_ACCEPTED_BY_SKIPPER:
        return NewPickUpRide(rideData: _rideData);
      case TAXI_STATUS_CANCEL_BY_SKIPPER:
        return Text('Hi');
      case TAXI_STATUS_ON_THE_WAY:
        return StartRide(
          rideData: _rideData,
        );

      case TAXI_STATUS_ARRIVED:
        return NewPickUpRide(rideData: _rideData);

      case TAXI_STATUS_START_RIDE:
        return StartRide(
          rideData: _rideData,
        );

      case TAXI_STATUS_NEW_REQUEST:
        return NewPickUpRide(rideData: _rideData);
      case TAXI_STATUS_RIDE_BOOKED:
        return NewPickUpRide(rideData: _rideData);

      case TAXI_STATUS_AMOUNT_COLLECTED:

      default:
        return Text('Hi');
    }
  }
  // <<< END: getMapWidgetForStatus - chooses which map to show for the taxi ride status


  // LatLng get sourceLatLng => sourceLatLngNotifier.value;
  // LatLng get destinationLatLng => destinationLatLngNotifier.value;

  // StreamSubscription<Map<String, dynamic>>? _driverDataStream;


  //     // Rest of your code

  //     //String status = rideData!['status'].toString();
  //     print('status>>>>>>>>>>>');

  //     if (status == TAXI_STATUS_ACCEPTED_BY_SKIPPER) {
  //       print("Here I am ");
  //       // Subscribe to the driver's data stream using the driver's ID
  //       String driverId = _rideData!['driver']['id'].toString();
  //       _driverDataStream = getDriverLatLngStream(driverId)
  //           .listen((Map<String, dynamic> driverSnapshot) {
  //         print(driverSnapshot);
  //         // Callback triggered whenever the driver data changes on the server
  //         // Get the driver's latitude and longitude from the driverSnapshot
  //         double driverLatitude = driverSnapshot['lat'] ?? 0.0;
  //         double driverLongitude = driverSnapshot['lng'] ?? 0.0;

  //         // Set the sourceLatLng to the driver's latitude and longitude
  //         sourceLatLngNotifier.value = LatLng(driverLatitude, driverLongitude);

  //         double pickupLatitude = double.parse(_rideData!['pickup_latitude']);
  //         double pickupLongitude = double.parse(_rideData!['pickup_longitude']);
  //         destinationLatLngNotifier.value =
  //             LatLng(pickupLatitude, pickupLongitude);

  //         // Notify the listeners that the sourceLatLng has changed
  //         notifyListeners();

  //       _driverDataStream = getDriverLatLngStream(driverId)
  //           .listen((Map<String, dynamic> driverSnapshot) {
  //         print(driverSnapshot);
  //         double driverLatitude = driverSnapshot['lat'] ?? 0.0;
  //         double driverLongitude = driverSnapshot['lng'] ?? 0.0;

  //         // Set the sourceLatLng to the driver's latitude and longitude
  //         sourceLatLngNotifier.value = LatLng(driverLatitude, driverLongitude);
  //       });

  //       // Use drop location as destinationLatLng

  //       // Notify the listeners that the destinationLatLng has changed
  //       notifyListeners();
  //     } else {
  //       // For other statuses, use pickup_latitude and pickup_longitude as sourceLatLng

  //       // Use drop_latitude and drop_longitude as destinationLatLng

  //       // Notify the listeners that the sourceLatLng and destinationLatLng have changed

  LatLng _sourceLatLng = LatLng(42.747932, -71.167889); // Default initial value
  LatLng _destinationLatLng =
      LatLng(17.5209327, 78.34424159999999); // Default initial value

  LatLng get sourceLatLng => _sourceLatLng;
  LatLng get destinationLatLng => _destinationLatLng;

  // ... Other methods and properties related to your trip options provider

  // >>> START: updateLatLngBasedOnStatus - updates lat lng based on status
  void updateLatLngBasedOnStatus() {
    // Implement your logic here to update the sourceLatLng and destinationLatLng based on status changes
    // For this example, I'll just update them with custom latitudes and longitudes
    _sourceLatLng = LatLng(42.747932, -71.167889);
    _destinationLatLng = LatLng(37.335685, -122.0605916);

    notifyListeners();
  }
  // <<< END: updateLatLngBasedOnStatus - updates lat lng based on status

  // >>> START: sourceLatLng - source lat lng
  set sourceLatLng(LatLng newLatLng) {
    _sourceLatLng = newLatLng;
    notifyListeners();
  }
  // <<< END: sourceLatLng - source lat lng

  // >>> START: destinationLatLng - destination lat lng
  set destinationLatLng(LatLng newLatLng) {
    _destinationLatLng = newLatLng;
    notifyListeners();
  }
  // <<< END: destinationLatLng - destination lat lng

}
// <<< END: TripOptionsProvider - the app's memory of the booking in progress (pickup, drop, time, car, fare...)
