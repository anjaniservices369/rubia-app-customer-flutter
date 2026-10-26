// =============================================================================
// WHAT : DRIVERS BOOKING: final confirmation sheet; 'Confirm Ride' saves the
//        booking on the server.
// NOTES: On success shows 'Order placed' and starts the background status
//        checker.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/RideBooking/RideEstimateInfo.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../periodic_notification/periodic_notification.dart';

// >>> START: ConfirmRide - final confirmation of the driver booking
/// The bottom sheet shown after the fare estimate: summary of fare, pickup
/// date/time and hours, with the "Confirm Ride" button.
class ConfirmRide extends StatefulWidget {
  const ConfirmRide({Key? key}) : super(key: key);

  @override
  State<ConfirmRide> createState() => _ConfirmRideState();
}
// <<< END: ConfirmRide - final confirmation of the driver booking

// >>> START: _ConfirmRideState - the data and logic behind its screen
class _ConfirmRideState extends State<ConfirmRide> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // The booking chosen so far (pickup, drop, time, car, fare...).
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);
    return SingleChildScrollView(
      child: Container(
        // Keep the sheet above the keyboard when it is open.
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [tBoxShadow]),
        child: Column(children: [
          // ---------------------------------------------------------------
          // SECTION 1 - "Estimate fare" with the amount.
          // Tapping the title or the (i) icon opens an info sheet that
          // explains how the fare is made up (RentalVehicleInfo).
          // ---------------------------------------------------------------
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
                color: tWhite,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [tBoxShadow]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      // Whole title row opens the fare-info sheet.
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 30.0),
                              child: Container(
                                  height: 90.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: RentalVehicleInfo())),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            // Title: "Estimate fare"
                            Text(
                              'estimate_fare'.tr,
                              style: GoogleFonts.mulish(
                                color: tSecondaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: isTab(context) ? 8.sp : 16.sp,
                              ),
                            ),
                            // The small (i) icon: same info sheet.
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 30.0),
                                      child: Container(
                                          height: 90.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: RentalVehicleInfo())),
                                );
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 15,
                                    color: tDarkOrangeColor,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    // The amount itself, e.g. "Rs 609" (value comes from the
                    // server estimate stored in the provider).
                    Row(
                      children: [
                        Text(
                          '  ' +
                              currencySymbol +
                              '${tripOptionsProvider.estimateFare}',
                          style: GoogleFonts.mulish(
                            color: tPrimaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: isTab(context) ? 16.sp : 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          // ---------------------------------------------------------------
          // SECTION 2 - Pickup date/time on the left, hours of use on the
          // right, separated by a vertical line.
          // ---------------------------------------------------------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              decoration: BoxDecoration(
                  color: tWhite,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [tBoxShadow]),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: calendar icon + "13-10-2026, 19:00".
                    Row(
                      children: [
                        Image.asset(
                          Images.CALENDER,
                          scale: 3,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        // Show nothing until a date has been chosen.
                        tripOptionsProvider.pickupDate == null ||
                                tripOptionsProvider.pickupDate == ""
                            ? Container()
                            : Container(
                                width: 35.w,
                                child: Text(
                                  Twl.dateActualFormate(
                                          tripOptionsProvider.pickupDate) +
                                      ',' +
                                      '${tripOptionsProvider.pickupTime}',
                                  maxLines: 2,
                                  style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 9.sp : 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    VerticalDivider(
                      color: tSecondaryColor,
                      thickness: 1.5,
                    ),
                    // Right: clock icon + "2 Hrs" (how long the driver is
                    // needed).
                    Row(
                      children: [
                        Image.asset(
                          Images.TIMER,
                          scale: 3,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          tripOptionsProvider.usageHours.toString() + " Hrs",
                          style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 12.sp : 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 0.6.h,
          ),
          // ---------------------------------------------------------------
          // SECTION 3 - The "Confirm Ride" button. This is where the booking
          // is actually created on the server.
          // ---------------------------------------------------------------
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: SizedBox(
                width: isTab(context) ? 60.w : 50.w,
                height: isTab(context) ? 6.h : 7.h,
                child: ButtonWidget(
                    borderSide: BorderSide(
                      color: tPrimaryColor,
                    ),
                    borderRadius: 8.0,
                    color: tPrimaryColor,
                    textcolor: Colors.black,
                    child: Text(
                      "Confirm_Ride".tr,
                      style: TextStyle(
                          letterSpacing: 1,
                          color: tWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: isTab(context) ? 10.sp : 16.sp),
                    ),
                    onTap: (startLoading, stopLoading, btnState) async {
                      // 1. Tell the next estimate call to SAVE the booking
                      //    (saveBooking=true), not just calculate a price.
                      tripOptionsProvider.setSaveBooking(true);
                      // 2. Show the spinner on the button.
                      startLoading();
                      // 3. Send everything chosen so far to the server.
                      var response =
                          await tripOptionsProvider.getEstimate(context);
                      if (response != null && response['status'] == 'OK') {
                        // 4. Saved: remember the booking id so the background
                        //    checker can follow its status.
                        await addBookingIdToPreferences(
                            response['booking_id'].toString());
                        // 5. Tell the customer, with a sound, that the booking
                        //    was received.
                        PeriodicNotification.showBookingPlaced(
                            response['booking_id'].toString());
                        // 5b. Start the status checker (runs every ~30 s even
                        //     when the app is closed).
                        PeriodicNotification.startOnDemandTask();
                        // 6. Go straight to the Bookings tab (Active Rides),
                        //    clearing the booking screens behind it.
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BottomNavigation(tabIndexId: 1)),
                                (route) => false);
                      } else {
                        // 4'. Not saved: stop the spinner and tell the
                        //     customer to try again.
                        stopLoading();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('error'.tr),
                            content: Text('failed_to_save_try_again'.tr),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('ok'.tr),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
        ]),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: addBookingIdToPreferences - adds booking id to preferences
  /// Saves the new booking's id on the phone. The background status checker
  /// (PeriodicNotification) reads it to know which booking to follow.
  Future<void> addBookingIdToPreferences(String bookingId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('booking_id', bookingId);
  }
  // <<< END: addBookingIdToPreferences - adds booking id to preferences
}
// <<< END: _ConfirmRideState - the data and logic behind its screen
