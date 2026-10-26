// =============================================================================
// WHAT : Server requests for the booking journey: list of services, fare
//        estimate (also saves the booking), coupons and cancellation charges.
// NOTES: The estimate call with saveBooking=true is what actually creates a
//        booking.
// =============================================================================
import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:base_project_flutter/constants/apiConstants.dart';
import 'package:flutter/material.dart';

// >>> START: ServicesAPI - server requests for the booking journey
class ServicesAPI {
  // >>> START: getServices - loads the service tiles (Drivers, Taxi, Auto...) for the home screen
  Future<dynamic> getServices(
    BuildContext context,
  ) async {
    var jsonMap;
    var headers = await ApiHelper().getHeader(context);
    var uri = SERVICES + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    return jsonMap;
  }
  // <<< END: getServices - loads the service tiles (Drivers, Taxi, Auto...) for the home screen

  // >>> START: getEstimate - asks the server for the fare estimate; with saveBooking=true it also creates the booking
  getEstimate(
    BuildContext context,
    Map<String, String> param,
    bool isSaveBooking 
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = GET_ESTIMATE + headers['auth_code']+'&saveBooking='+isSaveBooking.toString();

    Map<String, String> params = param;
    // saveBooking=true creates the booking, so only the preview may be retried.
    var response = await ApiHelper()
        .getTypePost(context, url, params, idempotent: !isSaveBooking);
    return response;
  }
  // <<< END: getEstimate - asks the server for the fare estimate; with saveBooking=true it also creates the booking

  // >>> START: getCancellationCharges - asks whether a cancellation fee is pending for this customer
  Future<dynamic> getCancellationCharges(
      BuildContext context,
      ) async {
    var jsonMap;
    var headers = await ApiHelper().getHeader(context);
    var uri = CANCELLATION_CHARGES + headers['auth_code'];

    jsonMap = await ApiHelper().getTypeGet(context, uri);
    return jsonMap;
  }
  // <<< END: getCancellationCharges - asks whether a cancellation fee is pending for this customer

  //Apply coupon 
   // >>> START: applyCoupon - applies a coupon code and returns the discount
   applyCoupon(
    BuildContext context,
    Map<String, String> param,
 
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = APPLY_COUPON + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
   // <<< END: applyCoupon - applies a coupon code and returns the discount
  //Apply coupon 
   // >>> START: removeCoupon - removes the applied coupon
   removeCoupon(
    BuildContext context,
    Map<String, String> param,
 
  ) async {
    var headers = await ApiHelper().getHeader(context);
    var url = REMOVE_COUPON + headers['auth_code'];

    Map<String, String> params = param;
    var response = await ApiHelper().getTypePost(context, url, params);
    return response;
  }
   // <<< END: removeCoupon - removes the applied coupon
}
// <<< END: ServicesAPI - server requests for the booking journey
