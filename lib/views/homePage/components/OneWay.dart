// =============================================================================
// WHAT : DRIVERS BOOKING step 2 (estimate and confirm): trip summary, fare,
//        hours of use, coupon and payment, with the 'Confirm Ride' button that
//        saves the booking on the server.
// NOTES: Replaces the old estimate page + confirmation sheet. On success shows
//        'Order placed', starts the background status checker and opens My
//        Bookings.
// =============================================================================
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/dummy.dart';
import 'package:base_project_flutter/views/homePage/components/coupons.dart';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonIconWidget.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../globalWidgets/locationcard.dart';
import '../../../periodic_notification/periodic_notification.dart';
import '../../../providers/riderProvider.dart';
import '../../../responsive.dart';
import '../../RideBooking/RideEstimateInfo.dart';
import '../../Bookings/components/rateRide.dart';

// >>> START: OneWay - screen/widget shell (the visible part is in its State class)
/// The estimate-and-confirm screen of the Drivers booking. The customer can:
///  - see pickup/drop, date/time and car,
///  - change the date/time or the number of hours (the fare is recalculated by
///    the server),
///  - apply a coupon,
///  - confirm the ride with "Confirm Ride".
class OneWay extends StatefulWidget {
  const OneWay({Key? key}) : super(key: key);

  @override
  State<OneWay> createState() => _OneWayState();
}
// <<< END: OneWay - screen/widget shell (the visible part is in its State class)

// >>> START: _OneWayState - the data and logic behind its screen
class _OneWayState extends State<OneWay> {
  // >>> START: _back - goes back to the booking screen (or Home if there is none)
  /// Back goes to the booking screen with all choices kept; when this page was
  /// opened without one behind it, the booking is abandoned and Home opens.
  Future<bool> _back(TripOptionsProvider provider) async {
    if (Navigator.canPop(context)) return true;
    provider.resetProviderValues();
    Twl.forceNavigateTo(context, BottomNavigation(tabIndexId: 0));
    return false;
  }
  // <<< END: _back - goes back to the booking screen (or Home if there is none)

  // >>> START: _setHours - changes the trip length (outstation round trip) and asks for the new fare
  void _setHours(TripOptionsProvider provider, int hours) {
    final h = hours.clamp(1, provider.maxUsageHours);
    provider.setUsageHours(h);
    setState(() => provider.usageHours = h);
    provider.getEstimate(context);
  }
  // <<< END: _setHours - changes the trip length (outstation round trip) and asks for the new fare

  // >>> START: _hoursAsDays - "hours" under the stepper, with the same length in days for a long trip
  String _hoursAsDays(int hours) {
    if (hours < 24) return hours == 1 ? 'hour' : 'hours';
    final d = hours ~/ 24, r = hours % 24;
    return 'hours  (${d} ${d == 1 ? 'day' : 'days'}${r > 0 ? ' $r hrs' : ''})';
  }
  // <<< END: _hoursAsDays - "hours" under the stepper, with the same length in days for a long trip

  // >>> START: _confirm - saves the booking on the server
  Future<void> _confirm(TripOptionsProvider provider,
      void Function() stopLoading) async {
    // 1. Tell the next estimate call to SAVE the booking (saveBooking=true),
    //    not just calculate a price.
    provider.setSaveBooking(true);
    // 2. Send everything chosen so far to the server.
    var response = await provider.getEstimate(context);
    if (!mounted) return;
    if (response != null && response['status'] == 'OK') {
      // 3. Saved: remember the booking id so the background checker can
      //    follow its status.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('booking_id', response['booking_id'].toString());
      // 4. Tell the customer, with a sound, that the booking was received,
      //    and start the status checker (runs every ~30 s even when the app
      //    is closed).
      PeriodicNotification.showBookingPlaced(response['booking_id'].toString());
      PeriodicNotification.startOnDemandTask();
      // 5. Go straight to the Bookings tab (Active Rides), clearing the
      //    booking screens behind it.
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => BottomNavigation(tabIndexId: 1)),
          (route) => false);
    } else {
      // Not saved: a later fare change must not save the booking by accident.
      provider.setSaveBooking(false);
      stopLoading();
      // the page's own context: the dialog's one is gone once it is closed
      final pageContext = context;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('error'.tr),
          // the server's reason (for example: rate your previous ride first), else the generic text
          content: Text(provider.lastEstimateError.isNotEmpty ? provider.lastEstimateError : 'failed_to_save_try_again'.tr),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // an unrated previous ride blocks the booking: ask for its (compulsory) rating now
                if (provider.lastRateBookingId.isNotEmpty && pageContext.mounted) {
                  RideRatingPrompt.promptForBooking(pageContext, provider.lastRateBookingId);
                }
              },
              child: Text('ok'.tr),
            ),
          ],
        ),
      );
    }
  }
  // <<< END: _confirm - saves the booking on the server

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // The booking in progress (pickup, drop, fare, coupon...).
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    // The amount currently shown as "Estimate fare".
    String estimateFare = tripOptionsProvider.estimateFare.toString();

    return WillPopScope(
      // Phone's back button: back to the booking screen.
      onWillPop: () => _back(tripOptionsProvider),
      child: Scaffold(
        backgroundColor: tWhite,
        // ---- Header: back arrow + "One way" / "Round trip" ----
        appBar: AppBar(
          backgroundColor: tWhite,
          centerTitle: true,
          title: Text(
            tripOptionsProvider.tripTitle,
            style: GoogleFonts.mulish(
              color: tSecondaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: GestureDetector(
            // Back arrow: back to the booking screen.
            onTap: () async {
              if (await _back(tripOptionsProvider) && mounted) {
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(isTab(context) ? 10 : 13.0),
              child: BackIconWidget(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                // -------------------------------------------------------
                // CARD 1 - Pickup and drop addresses of the trip.
                // -------------------------------------------------------
                Container(
                    decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(8)),
                    child: LocationCards(
                        status: '${tripOptionsProvider.riderType}',
                        pickupAddress: '${tripOptionsProvider.pickupAddress}',
                        dropAddress: '${tripOptionsProvider.dropAddress}',
                        tripStatus: '${tripOptionsProvider.tripType}')),
                SizedBox(
                  height: 1.h,
                ),
                // -------------------------------------------------------
                // CARD 2 - Date/time (tap to change) and the car chosen.
                // -------------------------------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.4.h),
                    decoration: BoxDecoration(color: tWhite, borderRadius: BorderRadius.circular(10), boxShadow: [tBoxShadow]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: calendar + date/time. Tapping reopens the
                        // date/time sheet (Clock) so the customer can edit.
                        GestureDetector(
                          onTap: () async {
                            final changed = await showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: Clock()),
                            );
                            // A new time can change the fare (night charge).
                            if (changed == true && mounted) {
                              tripOptionsProvider.getEstimate(context);
                            }
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Image.asset(
                                  Images.CALENDER,
                                  scale: 3,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Container(
                                  width: 35.w,
                                  child: Text(
                                    Twl.dateActual(tripOptionsProvider.pickupDate) + ',' + '${tripOptionsProvider.pickupTime}',
                                    maxLines: 2,
                                    style: GoogleFonts.mulish(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 9.sp : 11.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  Images.EDIT_ICON,
                                  scale: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Vertical separator line.
                        Container(
                          height: 4.h,
                          width: 0.3.w,
                          color: tSecondaryColor,
                        ),
                        // Right: car icon, car type and "(Automatic)/(Manual)".
                        Row(
                          children: [
                            Image.asset(
                              Images.CAR,
                              scale: 4.5,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${tripOptionsProvider.carModel}',
                                  style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 9.sp : 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 1.h,
                                ),
                                Text(
                                  // carType 1 = automatic, 2 = manual
                                  tripOptionsProvider.carType.toString() == '1' ? '(Automatic)' : '(Manual)',
                                  style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 9.sp : 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                // -------------------------------------------------------
                // CARD 3 - "Estimate fare" with the amount. Tapping opens
                // the explanation sheet (how the fare is made up).
                // -------------------------------------------------------
                GestureDetector(
                  onTap: () {
                    tripOptionsProvider.setFinalFare(estimateFare);
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                          child: Container(
                              height: 90.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              child: RentalVehicleInfo())),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.4.h),
                    decoration: BoxDecoration(color: tWhite, boxShadow: [tBackbtnBoxShadow], borderRadius: BorderRadiusDirectional.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            // The server priced this as an outstation trip: say so before the customer confirms.
                            if (tripOptionsProvider.tripNotice.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                // The column sits in a row that gives it any width it asks for, so the text is given a limit to wrap at.
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 80.w),
                                  child: Text(
                                    tripOptionsProvider.tripNotice,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mulish(
                                      color: tDarkOrangeColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 7.sp : 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                Text(
                                  'estimate_fare'.tr,
                                  style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTab(context) ? 8.sp : 16.sp,
                                  ),
                                ),
                                Column(
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
                                )
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            // While the server is recalculating show a
                            // spinner, otherwise the amount (2 decimals).
                            tripOptionsProvider.isLoading
                                ? Column(
                                    children: [
                                      CircularProgressIndicator(
                                        color: tPrimaryColor,
                                      ),
                                    ],
                                  )
                                : RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: double.tryParse(tripOptionsProvider.estimateFare) != null
                                              ? currencySymbol + '${double.parse(tripOptionsProvider.estimateFare).toStringAsFixed(2)} '
                                              : '',
                                          style: GoogleFonts.mulish(
                                            color: tPrimaryColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: isTab(context) ? 12.sp : 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                // -------------------------------------------------------
                // CARD 4 - "Estimate usage": how many hours the driver is
                // needed (1 to 15). Changing it asks the server for a new
                // fare immediately.
                // -------------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.4.h),
                  decoration: BoxDecoration(color: tWhite, boxShadow: [tBackbtnBoxShadow], borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tripOptionsProvider.isLongTrip ? 'Trip length' : 'estimate_usage'.tr,
                            style: GoogleFonts.mulish(
                              color: tSecondaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: isTab(context) ? 8.sp : 16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      // An outstation round trip can last days, so its length is a minus / plus stepper (1 hour a step, with +12 hours
                      // buttons, up to 30 days). Everything else is a short hours picker.
                      tripOptionsProvider.isLongTrip
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      iconSize: 30,
                                      color: tPrimaryColor,
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: tripOptionsProvider.usageHours <= 1 ? null : () => _setHours(tripOptionsProvider, tripOptionsProvider.usageHours - 1),
                                    ),
                                    Container(
                                      width: 64,
                                      height: 64,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tappbarclr)),
                                      child: Text('${tripOptionsProvider.usageHours}',
                                          style: TextStyle(color: tDarkNavyblue, fontWeight: FontWeight.w800, fontSize: 18.sp)),
                                    ),
                                    IconButton(
                                      iconSize: 30,
                                      color: tPrimaryColor,
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: tripOptionsProvider.usageHours >= tripOptionsProvider.maxUsageHours ? null : () => _setHours(tripOptionsProvider, tripOptionsProvider.usageHours + 1),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.2.h),
                                Text(
                                  _hoursAsDays(tripOptionsProvider.usageHours),
                                  style: GoogleFonts.mulish(color: tSecondaryColor, fontWeight: FontWeight.w700, fontSize: isTab(context) ? 8.sp : 12.sp),
                                ),
                                SizedBox(height: 0.6.h),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    for (final extra in const [12, 24, 168])
                                      ActionChip(
                                        label: Text(extra == 168 ? '+7 days' : '+$extra hrs'),
                                        onPressed: () => _setHours(tripOptionsProvider, tripOptionsProvider.usageHours + extra),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          : NumberPicker(
                        haptics: false,
                        textStyle: TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w800, fontSize: 15.sp),
                        selectedTextStyle: TextStyle(color: tDarkNavyblue, fontWeight: FontWeight.w800, fontSize: 15.sp),
                        value: tripOptionsProvider.usageHours,
                        minValue: 1,
                        // days for an outstation round trip, else hours (a driver's duty is at most 12 hours; time beyond what was
                        // booked is charged hourly when the ride ends)
                        maxValue: tripOptionsProvider.maxUsageHours,
                        step: 1,
                        itemHeight: 42,
                        itemWidth: 50,
                        axis: Axis.horizontal,
                        // Customer picks a different number of hours.
                        onChanged: (value) async {
                          // 1. Remember the hours ...
                          tripOptionsProvider.setUsageHours(value);
                          setState(() => tripOptionsProvider.usageHours = value);
                          // 2. ... and fetch the new fare from the server.
                          tripOptionsProvider.getEstimate(context);
                        },
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: tappbarclr),
                        ),
                      ),
                      if (!tripOptionsProvider.isLongTrip)
                      Text(
                        tripOptionsProvider.isLongTrip ? _hoursAsDays(tripOptionsProvider.usageHours) : 'hours'.tr,
                        style: GoogleFonts.mulish(
                          color: tSecondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: isTab(context) ? 8.sp : 12.sp,
                        ),
                      ),
                      if (tripOptionsProvider.isLongTrip)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                          child: Text(
                            "After the base hours, every hour is charged by the hour. Driver's food and stay are provided by you.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mulish(color: tGray, fontSize: isTab(context) ? 7.sp : 10.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                // -------------------------------------------------------
                // CARD 5 - Two shortcuts: Coupon (left) and payment method
                // "Cash" (right, display only).
                // -------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Coupon: if one is applied, tapping removes it;
                    // otherwise open the coupons list.
                    GestureDetector(
                      onTap: () {
                        if (tripOptionsProvider.couponCode != null && tripOptionsProvider.couponCode.isNotEmpty) {
                          tripOptionsProvider.removeCoupon(context);
                        } else {
                          Twl.forceNavigateTo(context, CouponsPage());
                        }
                      },
                      child: Container(
                        width: 45.w,
                        decoration: BoxDecoration(color: tWhite, boxShadow: [tBackbtnBoxShadow], borderRadius: BorderRadiusDirectional.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              SizedBox(width: 1.w),
                              Image.asset(
                                Images.COUPON,
                                scale: isTab(context) ? 3 : 3,
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              // Shows the applied code, or the word "Coupon".
                              Text(
                                tripOptionsProvider.couponCode != null && tripOptionsProvider.couponCode.isNotEmpty
                                    ? tripOptionsProvider.couponCode
                                    : 'coupon'.tr,
                                style: GoogleFonts.mulish(
                                  color: tSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isTab(context) ? 8.sp : 12.sp,
                                ),
                              ),
                              Spacer(),
                              // "x" when a coupon is applied, arrow otherwise.
                              tripOptionsProvider.couponCode.isNotEmpty
                                  ? Icon(
                                      Icons.clear,
                                      color: tPrimaryColor,
                                      size: isTab(context) ? 40 : 30,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_right,
                                      color: tPrimaryColor,
                                      size: isTab(context) ? 40 : 30,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Payment method: only cash is offered at the moment.
                    GestureDetector(
                      child: Container(
                        width: 45.w,
                        decoration: BoxDecoration(color: tWhite, boxShadow: [tBackbtnBoxShadow], borderRadius: BorderRadiusDirectional.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              SizedBox(width: 1.w),
                              Image.asset(
                                Images.CURRENCY,
                                scale: isTab(context) ? 3 : 3,
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Center(
                                child: Text(
                                  'cash'.tr,
                                  style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isTab(context) ? 8.sp : 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                // -------------------------------------------------------
                // "Confirm Ride" button - creates the booking on the server.
                // Hidden while the fare is being recalculated so a stale price
                // cannot be confirmed.
                // -------------------------------------------------------
                tripOptionsProvider.isLoading
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            width: isTab(context) ? 60.w : 60.w,
                            height: isTab(context) ? 6.h : 7.h,
                            child: ButtonWidget(
                                borderSide: BorderSide(
                                  color: tPrimaryColor,
                                ),
                                borderRadius: 14.0,
                                color: tPrimaryColor,
                                textcolor: tDarkNavyblue,
                                child: Text(
                                  'Confirm_Ride'.tr,
                                  style: TextStyle(
                                      letterSpacing: 1, color: tWhite, fontWeight: FontWeight.w700, fontSize: isTab(context) ? 10.sp : 16.sp),
                                ),
                                onTap: (startLoading, stopLoading, btnState) async {
                                  startLoading();
                                  await _confirm(tripOptionsProvider, stopLoading);
                                }),
                          ),
                        ),
                      ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _OneWayState - the data and logic behind its screen
