// =============================================================================
// WHAT : DRIVERS BOOKING: summary of the one-way trip with the fare estimate.
// NOTES: Next step: confirm ride.
// =============================================================================
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/dummy.dart';
import 'package:base_project_flutter/views/homePage/components/confirmride.dart';
import 'package:base_project_flutter/views/homePage/components/coupons.dart';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonIconWidget.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../globalWidgets/locationcard.dart';
import '../../../providers/riderProvider.dart';
import '../../../responsive.dart';
import '../../RideBooking/RideEstimateInfo.dart';

// >>> START: OneWay - screen/widget shell (the visible part is in its State class)
/// The fare-estimate screen of the Drivers booking. The customer can:
///  - see pickup/drop, date/time and car,
///  - change the number of hours (the fare is recalculated by the server),
///  - apply a coupon,
///  - continue with "Next" to the confirmation sheet.
class OneWay extends StatefulWidget {
  const OneWay({Key? key}) : super(key: key);

  @override
  State<OneWay> createState() => _OneWayState();
}
// <<< END: OneWay - screen/widget shell (the visible part is in its State class)

// >>> START: _OneWayState - the data and logic behind its screen
class _OneWayState extends State<OneWay> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // The booking in progress (pickup, drop, fare, coupon...).
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    // The amount currently shown as "Estimate fare".
    String estimateFare = tripOptionsProvider.estimateFare.toString();

    return WillPopScope(
      // Phone's back button: abandon the booking and return Home.
      onWillPop: () {
        tripOptionsProvider.resetProviderValues();
        return Twl.forceNavigateTo(context, BottomNavigation(tabIndexId: 0));
      },
      child: Scaffold(
        backgroundColor: tWhite,
        // ---- Header: back arrow + "One way" / "Round trip" ----
        appBar: AppBar(
          backgroundColor: tWhite,
          centerTitle: true,
          title: Text(
            tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY ? 'one_way'.tr : 'round'.tr,
            style: GoogleFonts.mulish(
              color: tSecondaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: GestureDetector(
            // Back arrow: clear the booking and go Home.
            onTap: () {
              tripOptionsProvider.resetProviderValues();
              Twl.forceNavigateTo(context, BottomNavigation(tabIndexId: 0));
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
                    padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 3.h),
                    decoration: BoxDecoration(color: tWhite, borderRadius: BorderRadius.circular(10), boxShadow: [tBoxShadow]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: calendar + date/time. Tapping reopens the
                        // date/time sheet (Clock) so the customer can edit.
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: Clock()),
                            );
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
                    padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 3.h),
                    decoration: BoxDecoration(color: tWhite, boxShadow: [tBackbtnBoxShadow], borderRadius: BorderRadiusDirectional.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
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
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
                  decoration: BoxDecoration(color: tWhite, boxShadow: [tBackbtnBoxShadow], borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'estimate_usage'.tr,
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
                      NumberPicker(
                        haptics: false,
                        textStyle: TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w800, fontSize: 15.sp),
                        selectedTextStyle: TextStyle(color: tDarkNavyblue, fontWeight: FontWeight.w800, fontSize: 15.sp),
                        value: tripOptionsProvider.usageHours,
                        minValue: 1,
                        maxValue: 15,
                        step: 1,
                        itemHeight: 50,
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
                      Text(
                        'hours'.tr,
                        style: GoogleFonts.mulish(
                          color: tSecondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: isTab(context) ? 8.sp : 12.sp,
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
                // "Next" button - opens the confirmation sheet. Hidden while
                // the fare is being recalculated so a stale price cannot be
                // confirmed.
                // -------------------------------------------------------
                tripOptionsProvider.isLoading
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            width: isTab(context) ? 60.w : 50.w,
                            height: isTab(context) ? 6.h : 7.h,
                            child: ButtonWidget(
                                borderSide: BorderSide(
                                  color: tPrimaryColor,
                                ),
                                borderRadius: 14.0,
                                color: tPrimaryColor,
                                textcolor: Colors.black,
                                child: Text(
                                  'next'.tr,
                                  style: TextStyle(
                                      letterSpacing: 1, color: tWhite, fontWeight: FontWeight.w700, fontSize: isTab(context) ? 10.sp : 16.sp),
                                ),
                                onTap: (startLoading, stopLoading, btnState) async {
                                  startLoading();
                                  // Show the ConfirmRide sheet.
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0),
                                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)), child: ConfirmRide())),
                                  );
                                  stopLoading();
                                }),
                          ),
                        ),
                      ),
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
