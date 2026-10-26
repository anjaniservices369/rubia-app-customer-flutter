// =============================================================================
// WHAT : List of every request the customer app can make to the server:
//        login/OTP, profile, wallet, bookings, favourites, emergency contacts,
//        notifications, coupons, ride status.
// NOTES: Each method = one server endpoint. The endpoint addresses live in
//        constants/apiConstants.dart.
// =============================================================================
import 'dart:io';

import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:base_project_flutter/api_services/sessionGuard.dart';
import 'package:base_project_flutter/constants/apiConstants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/walletTransactionsModel.dart';

// >>> START: UserAPI - every request the customer app can send to the server
class UserAPI {
//Check API
  // >>> START: checkApi - asks the server who is logged in and whether the login is valid
  checkApi(String authCode) async {
    var client = http.Client();
    var url = apiBaseUrl + CHECK_API + authCode;
    var jsonMap;
    try {
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        jsonMap = json.decode(jsonString);
        await SessionGuard.handle(jsonMap);
        return jsonMap;
      } else {
      }
    } on SocketException {
    } catch (exception) {
      return jsonMap;
    }
  }
  // <<< END: checkApi - asks the server who is logged in and whether the login is valid

  //Ride state (replaces the Firestore listeners)
  // >>> START: rideRequestDetail - gets the current status of one taxi ride (polled every few seconds)
  /// Reads one ride. Context-free so it can be used from a polling stream.
  /// Returns the decoded reply, or null on a network problem.
  Future<dynamic> rideRequestDetail(String rideId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authCode = prefs.getString('authCode');
      if (authCode == null || authCode.isEmpty) return null;
      final url = apiBaseUrl +
          RIDE_REQUEST_DETAIL +
          authCode +
          '&rideRequestId=' +
          rideId;
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final jsonMap = json.decode(response.body);
      await SessionGuard.handle(jsonMap);
      return jsonMap;
    } catch (e) {
      return null;
    }
  }
  // <<< END: rideRequestDetail - gets the current status of one taxi ride (polled every few seconds)

  // >>> START: autoAssignRide - asks the server to offer a taxi ride to nearby drivers
  /// Asks the backend to offer the ride to the nearby drivers.
  autoAssignRide(BuildContext context, String rideId) async {
    var headers = await ApiHelper().getHeader(context);
    var url = AUTO_ASSIGN_RIDE + headers['auth_code'] + '&ride_id=' + rideId;
    return await ApiHelper().getTypeGet(context, url);
  }
  // <<< END: autoAssignRide - asks the server to offer a taxi ride to nearby drivers

  //Send OTP
  // >>> START: sendOtp - asks the server to SMS a login code to the mobile number
  sendOtp(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var url = SEND_OTP;
    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: sendOtp - asks the server to SMS a login code to the mobile number

  //Verify OTP
  // >>> START: verifyOtp - checks the code the customer entered and returns the login key
  verifyOtp(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var url = VERIFY_OTP;
    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: verifyOtp - checks the code the customer entered and returns the login key

//Emergency Contact
  // >>> START: emergenyContact - saves the emergency contact entered at sign-up
  emergenyContact(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = EMERGENCY_CONTACT_NUM + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: emergenyContact - saves the emergency contact entered at sign-up

//Apply referral
  // >>> START: applyReferral - applies a friend's referral code to this account
  applyReferral(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = APPLY_REFERRAL + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: applyReferral - applies a friend's referral code to this account

  // CheckBoundary
  // >>> START: checkBoundary - checks a map point is inside Rubia's service area
  checkBoundary(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = CHECK_BOUNDARY + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: checkBoundary - checks a map point is inside Rubia's service area

  // >>> START: sendLocation - tells the server the customer's current position
  sendLocation(
      BuildContext context,
      Map<String, String> param,
      ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = CURRENT_CITY + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: sendLocation - tells the server the customer's current position

  //update latlng
  // >>> START: getUpdateLatLong - updates the customer's saved latitude/longitude
  getUpdateLatLong(BuildContext context, String latitude, String longitude) async {
    var headers = await ApiHelper().getHeader(context);
    var url = UPDATE_LAT_LNG + headers['auth_code'];
    Map<String, String> params = {'latitude': latitude, 'longitude': longitude};
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: getUpdateLatLong - updates the customer's saved latitude/longitude

  //personal Details
  // >>> START: personalDetails - saves name, email, gender and date of birth
  personalDetails(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = PERSONAL_DETAILS + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: personalDetails - saves name, email, gender and date of birth

  // >>> START: updateProfilePic - saves the link of the new profile photo
  updateProfilePic(BuildContext context, String profilePic) async {
    var headers = await ApiHelper().getHeader(context);
    var url = UPDATE_PROFILE_PIC + headers['auth_code'];

    Map<String, String> params = {
      'profile_image': profilePic,
    };
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: updateProfilePic - saves the link of the new profile photo

  //LogOut
  // >>> START: getlogout - logs out on the server and clears everything saved on the phone
  getlogout(BuildContext context) async {
    var response;
    var jsonMap;
    var url;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = await ApiHelper().getHeader(context);
    url = LOGOUT + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, url);
    response = jsonMap;
    await sharedPreferences.clear();
    return response;
  }
  // <<< END: getlogout - logs out on the server and clears everything saved on the phone
//notifaction

  // >>> START: getMyNotifaction - loads the notification list (paged)
  Future<dynamic> getMyNotifaction(
    BuildContext context,
    String page,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var uri = NOTIFICATION + headers['auth_code'] + '&page=' + page;
    // Map<String, String> params = param;
    var response = await ApiHelper().getTypeGet(
      context,
      uri,
    );
    return response;
  }
  // <<< END: getMyNotifaction - loads the notification list (paged)

  //wallet
  // >>> START: emergencyContacts - loads the saved emergency contacts
  emergencyContacts(
    BuildContext context,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = EMERGENCY_CONTACTS + headers['auth_code'];

    var response = await ApiHelper().getTypeGet(context, url);
    return response;
  }
  // <<< END: emergencyContacts - loads the saved emergency contacts

  // >>> START: addEmergencyContacts - adds one emergency contact
  addEmergencyContacts(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = ADD_EMERGENCY + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: addEmergencyContacts - adds one emergency contact

  // >>> START: editEmergencyContacts - changes one emergency contact
  editEmergencyContacts(
    BuildContext context,
    String id,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = EDIT_EMERGENCY + headers['auth_code'] + '&id=' + id;

    Map<String, String> params = param;

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: editEmergencyContacts - changes one emergency contact

  // refer and earn
  // >>> START: referEarnings - loads the refer-and-earn code and rewards
  referEarnings(
    BuildContext context,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = REFER_EARN + headers['auth_code'];

    var response = await ApiHelper().getTypeGet(context, url);
    return response;
  }
  // <<< END: referEarnings - loads the refer-and-earn code and rewards

  //VehicleType
  // >>> START: vehicleType - loads the car types (SUV+, SUV, Sedan, Hatchback)
  vehicleType(
    BuildContext context,
    String vehicleTypeId,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = VEHICLE_TYPES + headers['auth_code'];

    Map<String, String> params = {
      'type': vehicleTypeId,
    };

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: vehicleType - loads the car types (SUV+, SUV, Sedan, Hatchback)

  // >>> START: deleteEmergencyContacts - removes one emergency contact
  deleteEmergencyContacts(
    BuildContext context,
    String id,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = DELETE_EMERGENCY + headers['auth_code'] + '&id=' + id;

    Map<String, String> params = {
      'Id': id,
    };
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: deleteEmergencyContacts - removes one emergency contact

  // All transaction
  // >>> START: allTranscations - loads the wallet transactions (with filters and paging)
  Future<WalletTransactionModel> allTranscations(BuildContext context, String page) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var startDate;
    var endDate;
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
    endDate = DateTime.now().add(Duration(days: 1));

    startDate = formatter.format(now);

    startDate = sharedPreferences.getString('startDate') != null ? sharedPreferences.getString('startDate') : startDate;
    endDate = sharedPreferences.getString('endDate') != null ? sharedPreferences.getString('endDate') : endDate;

    var jsonMap;
    var headers = await ApiHelper().getHeader(context);
    var url = ALL_TRANSACTIONS + headers['auth_code'];
    Map<String, String> params = {
      'page': page,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
    };
    jsonMap = await ApiHelper().getTypePost(context, url, params);
    var response = WalletTransactionModel.fromJson(jsonMap);
    return response;
  }
  // <<< END: allTranscations - loads the wallet transactions (with filters and paging)

  //All transaction without model
  // >>> START: walletTransactionWithoutModel - loads wallet transactions as raw data
  walletTransactionWithoutModel(
    BuildContext context,
    String page,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var startDate;
    var endDate;
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
    endDate = DateTime.now().add(Duration(days: 1));

    startDate = formatter.format(now);

    startDate = sharedPreferences.getString('startDate') != null ? sharedPreferences.getString('startDate') : startDate;
    endDate = sharedPreferences.getString('endDate') != null ? sharedPreferences.getString('endDate') : endDate;

    var headers = await ApiHelper().getHeader(context);
    var url = ALL_TRANSACTIONS + headers['auth_code'];
    Map<String, String> params = {
      'page': page,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
    };
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: walletTransactionWithoutModel - loads wallet transactions as raw data

  //Available Balance wallet page
  // >>> START: walletAmount - loads the wallet balance
  Future<dynamic> walletAmount(
    BuildContext context,
  ) async {
    var jsonMap;
    var url;
    var headers = await ApiHelper().getHeader(context);
    url = WALLET_AMOUNT + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, url);
    return jsonMap;
  }
  // <<< END: walletAmount - loads the wallet balance
  //add money

  // >>> START: addMoneyApi - adds money to the wallet
  addMoneyApi(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = ADD_BALANCE + headers['auth_code'];
    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: addMoneyApi - adds money to the wallet

  // favorite location list
  // >>> START: favoriteList - loads the saved favourite addresses
  Future<dynamic> favoriteList(
    BuildContext context,
  ) async {
    var jsonMap;
    var url;
    var headers = await ApiHelper().getHeader(context);
    url = FAVORITE_LIST + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, url);
    return jsonMap;
  }
  // <<< END: favoriteList - loads the saved favourite addresses

  // add favorite locatons
  // >>> START: createFavLocation - saves a new favourite address
  createFavLocation(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = CREATE_FAVORITE + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: createFavLocation - saves a new favourite address

  //delete favourite location
  // >>> START: deleteFavLocations - removes a favourite address
  deleteFavLocations(
    BuildContext context,
    favLocationId,
  ) async {
    var response;
    var jsonMap;
    var url;
    var headers = await ApiHelper().getHeader(
      context,
    );
    url = DELETE_FAVORITE + headers['auth_code'] + '&id=' + favLocationId;
    jsonMap = await ApiHelper().getTypeGet(context, url);
    response = jsonMap;
    return response;
  }
  // <<< END: deleteFavLocations - removes a favourite address

  //edit favorite location
  // >>> START: editFavLocation - changes a favourite address
  editFavLocation(BuildContext context, Map<String, String> param, editId) async {
    var headers = await ApiHelper().getHeader(context);
    var url = EDIT_FAVORITE + headers['auth_code'] + '&id=' + editId;

    Map<String, String> params = param;

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: editFavLocation - changes a favourite address

  // >>> START: fetchCouponsList - loads the available coupons (paged)
  fetchCouponsList(BuildContext context, String page) async {
    var headers = await ApiHelper().getHeader(context);
    var url = COUPONS_LIST + headers['auth_code'] + '&page=' + page;
    Map<String, String> params = {};

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: fetchCouponsList - loads the available coupons (paged)

  // >>> START: fetchBookingsList - loads My Bookings (active, completed, cancelled)
  fetchBookingsList(BuildContext context, String page, String status, String vehicle_id) async {

    var headers = await ApiHelper().getHeader(context);
    var url = BOOKINGS_LIST + headers['auth_code'] + '&page=' + page + "&status=" + status + "&vehicle_id=" + vehicle_id;
    Map<String, String> params = {};

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: fetchBookingsList - loads My Bookings (active, completed, cancelled)

  // >>> START: rideInfo - gets the details of a booking
  rideInfo(
    BuildContext context,
    String bookingId,
  ) async {

    var headers = await ApiHelper().getHeader(context);
    var url = RIDE_INFO + headers['auth_code'];
    Map<String, String> params = {'booking_id': bookingId};

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: rideInfo - gets the details of a booking

  // >>> START: viewBooking - gets the full details and live status of one booking
  viewBooking(
    BuildContext context,
    String bookingId,
  ) async {

    var headers = await ApiHelper().getHeader(context);
    var url = VIEW_BOOKING + headers['auth_code'];
    Map<String, String> params = {'booking_id': bookingId};

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: viewBooking - gets the full details and live status of one booking

  // >>> START: viewBookingBG - same as viewBooking but for the background status checker
  viewBookingBG(
      String bookingId,
      ) async {

    var headers = await ApiHelper().getHeaderBG();
    var url = VIEW_BOOKING + headers['auth_code'];
    Map<String, String> params = {'booking_id': bookingId};

    var response = await ApiHelper().getTypePostBG(url, params);
    return response;
  }
  // <<< END: viewBookingBG - same as viewBooking but for the background status checker

  // >>> START: cancelRide - cancels a driver booking with the chosen reason
  cancelRide(BuildContext context, String bookingId, String cancelReason) async {
    var headers = await ApiHelper().getHeader(context);
    var url = CANCEL_RIDE + headers['auth_code'];
    Map<String, String> params = {'booking_id': bookingId, 'cancel_reason': cancelReason};
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: cancelRide - cancels a driver booking with the chosen reason

  // //booking list
  //   Future<dynamic> bookingList(
  // rating and Review api
  // >>> START: myAddReview - sends the customer's rating and comment for a driver
  myAddReview(BuildContext context, param) async {

    var headers = await ApiHelper().getHeader(context);
    var url = ADD_REVIEW + headers['auth_code'];
    Map<String, String> params = param;

    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: myAddReview - sends the customer's rating and comment for a driver

  // >>> START: reviewAndRating - loads the customer's reviews
  Future<dynamic> reviewAndRating(
    BuildContext context,
    String page,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var uri = RATING_ADD_REVIEW + headers['auth_code'] + '&page=' + page;
    // Map<String, String> params = param;
    var response = await ApiHelper().getTypeGet(
      context,
      uri,
    );
    return response;
  }
  // <<< END: reviewAndRating - loads the customer's reviews

  // >>> START: taxiRideInfo - gets the details of a taxi ride
  taxiRideInfo(
    BuildContext context,
    String rideId,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var uri = TAXI_RIDE_INFO + headers['auth_code'] + '&ride_id=' + rideId;
    // Map<String, String> params = param;
    var response = await ApiHelper().getTypeGet(
      context,
      uri,
    );
    return response;
  }
  // <<< END: taxiRideInfo - gets the details of a taxi ride

  // >>> START: getClearNotifaction - clears all notifications
  getClearNotifaction(BuildContext context) async {
    var jsonMap;
    var headers = await ApiHelper().getHeader(context);
    var uri = NOTIFICATION_CLEAR + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    var response = jsonMap;
    return response;
  }
  // <<< END: getClearNotifaction - clears all notifications

  // >>> START: getBanners - loads the home-screen banners
  getBanners(BuildContext context) async {
    var jsonMap;
    var headers = await ApiHelper().getHeader(context);
    var uri = BANNER_WITH_CATEGORY + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    var response = jsonMap;
    return response;
  }
  // <<< END: getBanners - loads the home-screen banners

  // >>> START: getVechiles - loads vehicles and fares for the taxi service
  getVechiles(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = GET_VEHICLES + headers['auth_code'];
    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: getVechiles - loads vehicles and fares for the taxi service

  // >>> START: rideRequest - creates a taxi ride request on the server
  rideRequest(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = RIDE_REQUEST + headers['auth_code'];
    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: rideRequest - creates a taxi ride request on the server

  // >>> START: rideCompletedDetails - gets the final bill of a completed taxi ride
  Future<dynamic> rideCompletedDetails(BuildContext context, String rideId) async {
    var jsonMap;
    var headers = await ApiHelper().getHeader(context);
    var uri = RIDE_COMPLETION_DETAIL + headers['auth_code'];
    Map<String, String> params = {'ride_id': rideId};
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    return jsonMap;
  }
  // <<< END: rideCompletedDetails - gets the final bill of a completed taxi ride

  //add rating
  // >>> START: addSkipperRating - rates the taxi driver
  addSkipperRating(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = SKIPPER_RATING + headers['auth_code'];
    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: addSkipperRating - rates the taxi driver

  //cancel ride
  // >>> START: SkippercancelRide - cancels a taxi ride
  SkippercancelRide(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = SKIPPER_CANCEL_RIDE + headers['auth_code'];
    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
  // <<< END: SkippercancelRide - cancels a taxi ride

  // >>> START: downloadInvoice - downloads the invoice of a ride
  downloadInvoice(
    BuildContext context,
    Map<String, String> param,
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = DOWNLOAD_INNVOICE + headers['auth_code'];
    return url;
  }
  // <<< END: downloadInvoice - downloads the invoice of a ride
}
// <<< END: UserAPI - every request the customer app can send to the server
