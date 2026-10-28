// =============================================================================
// WHAT : The booking detail page with status, OTP and the Cancel Ride flow
//        (terms -> reason -> submit).
// NOTES: Contains the cancellation reason list. Server: cancel-ride.
// =============================================================================
import 'dart:async';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/views/RideBooking/rideBill.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/constants.dart';
import '../../../../../constants/imageConstant.dart';
import '../../../../../globalFuctions/globalFunctions.dart';
import '../../../../../globalWidgets/buttonIconWidget.dart';
import '../../../../../globalWidgets/buttonWidget.dart';
import '../../../../../globalWidgets/rideDriverCard.dart';
import '../../../../../responsive.dart';
import '../../../../bottomNavigation.dart/bottomNavigation.dart';
import '../../../../profilePage/components/support.dart';
import '../../riderDetailsPayment.dart';

// >>> START: RideInfo - booking details with status, OTP and cancel
class RideInfo extends StatefulWidget {
  const RideInfo({Key? key, this.bookingDetails}) : super(key: key);

  final bookingDetails;

  @override
  State<RideInfo> createState() => _RideInfoState();
}
// <<< END: RideInfo - booking details with status, OTP and cancel

final TextEditingController _reasonController = TextEditingController();

// >>> START: _RideInfoState - the data and logic behind its screen
class _RideInfoState extends State<RideInfo> {
  var details;
  var rideDetails;
  var resNOK;
  var viewbookingDetails;
  var usageText;
  // >>> START: usagehour - usagehour
  usagehour() {
    double? usageHours = double.tryParse(
      widget.bookingDetails['usage_hours'].toString(),
    );

    if (usageHours != null) {
      if (usageHours >= 1) {
        int wholeHours = usageHours.toInt();
        int wholeMinutes = ((usageHours - wholeHours) * 60).toInt();
        if (wholeMinutes > 0) {
          usageText = '$wholeHours hrs $wholeMinutes mins ';
        } else {
          usageText = '$wholeHours hrs ';
        }
      } else {
        int usageMinutes = (usageHours * 60).toInt();
        usageText = '$usageMinutes mins ';
      }
    } else {
      usageText = 'Usage hours not available'; // Handle the case where 'usage_hours' is null
    }
  }
  // <<< END: usagehour - usagehour

  // >>> START: getRideInfo - gets ride info
  getRideInfo() async {
    details = await UserAPI().rideInfo(context, widget.bookingDetails['id'].toString());
    if (details != null && details['status'] == 'OK') {
      setState(() {
        rideDetails = details['details'];
      });
      usagehour();
    } else {
      setState(() {
        resNOK = details['status'];
      });
    }
  }
  // <<< END: getRideInfo - gets ride info

  // >>> START: getViewBooking - gets view booking
  getViewBooking() async {
    details = await UserAPI().viewBooking(context, widget.bookingDetails['id'].toString());
    if (details != null && details['status'] == 'OK') {
      setState(() {
        viewbookingDetails = details['details'];
      });
    } else {
      setState(() {
        resNOK = details['status'];
      });
    }
  }
  // <<< END: getViewBooking - gets view booking

  // The status changes while this page is open (a driver accepts, arrives...): it is read again every 6 seconds, quietly.
  Timer? _refreshTimer;

  // >>> START: _refresh - reads the ride again without showing any message on a failed check
  Future<void> _refresh() async {
    final id = widget.bookingDetails['id'].toString();
    final info = await UserAPI().rideInfo(context, id, quiet: true);
    final view = await UserAPI().viewBooking(context, id, quiet: true);
    if (!mounted) return;
    setState(() {
      if (info != null && info['status'] == 'OK') rideDetails = info['details'];
      if (view != null && view['status'] == 'OK') viewbookingDetails = view['details'];
    });
  }
  // <<< END: _refresh - reads the ride again without showing any message on a failed check

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    getViewBooking();
    getRideInfo();
    _refreshTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (mounted) _refresh();
    });

    // TODO: implement initState
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // double? usageHours = double.tryParse(rideDetails['usage_hours'] ?? '');

    // String usageText;

    //   usageText = ''; // Handle the case where 'usage_hours' is null
    // }
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
            context,
            RideDetailsPayment(
              bookingDetails: widget.bookingDetails,
            ));
      },
      child: Scaffold(
        backgroundColor: tWhite,
        appBar: AppBar(
          elevation: 1,
          titleSpacing: 7,
          backgroundColor: tappbarclr,
          leading: GestureDetector(
              onTap: () {
                Twl.forceNavigateTo(
                    context,
                    RideDetailsPayment(
                      bookingDetails: widget.bookingDetails,
                    ));
                // Twl.forceNavigateTo(
                //     context,
                //     BottomNavigation(
                //       tabIndexId: 1,
                //     ));
              },
              child: Padding(
                padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                child: BackIconWidget(),
              )),
          title: Text(
            // 'Ride_Id '.tr + ': ' + rideDetails['id'].toString(),
            (rideDetails != null ? 'Ride_Id '.tr + ': ' + rideDetails['id'].toString() : 'Ride_Id '.tr + ': ' + ''),
            style: TextStyle(
              color: tSecondaryColor,
              fontFamily: "mulish",
              fontSize: isTab(context) ? 10.sp : 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: rideDetails == null
            ? Container(
                child: Align(
                    alignment: Alignment.center,
                    child: SpinKitThreeBounce(
                      color: tPrimaryColor,
                      size: 20.0,
                    )),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  //         horizontal: 3.5.w, vertical: 1.3.h),
                  //           color: tSecondaryColor,
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 12.sp),
                  Column(
                    children: [
                      SizedBox(
                        height: 1.h,
                      ),
                      GestureDetector(
                        // onTap: () {
                        //   Twl.navigateTo(context, RideDetailsView(rideDetails:widget.bookingDetails));
                        // },
                        child: rideDetails['status'] != STATUS_WAITING_FOR_DRIVER
                            ? RideDriverCard(rideDetails: rideDetails)
                            : Text(
                                'waiting_for_driver_'.tr,
                                style: TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w600, fontSize: 12.sp),
                              ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      GestureDetector(
                        //   onTap: () {
                        //   Twl.navigateTo(context, RideDetailsView(rideDetails:widget.bookingDetails));
                        // },
                        child: Container(
                          decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(isTab(context) ? 12 : 8),
                                        decoration: BoxDecoration(color: tBackground, shape: BoxShape.circle),
                                        child: Image.asset(
                                          Images.GREENLOCATIONICON,
                                          scale: isTab(context) ? 2 : 3.5,
                                        )),
                                    if (rideDetails['rider_type'] == 1)
                                      DottedLine(
                                        direction: Axis.vertical,
                                        lineLength: 30,
                                        lineThickness: 1.0,
                                        dashLength: 4.0,
                                        dashColor: tDotted,
                                        dashGapLength: 4.0,
                                        dashGapRadius: 0.0,
                                      ),
                                    if (rideDetails['rider_type'] == 1)
                                      Container(
                                          padding: EdgeInsets.all(isTab(context) ? 12 : 8),
                                          decoration: BoxDecoration(color: tBackground, shape: BoxShape.circle),
                                          child: Image.asset(
                                            Images.REDLOCATIONICON,
                                            scale: isTab(context) ? 2 : 3.5,
                                          )),
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rideDetails['pickup_address'].toString(),
                                        // 'Shrvan assigned as a driver',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.mulish(
                                          color: tDarkNavyblue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: isTab(context) ? 9.sp : 11.sp,
                                        ),
                                      ),
                                      // TextFormField(
                                      //   controller: _searchController
                                      //   // },
                                      //     hintText: 'Pickup Location',
                                      //     fillColor: tBackground,
                                      //     filled: false,
                                      // VerticalDivider(
                                      //   width: 10,
                                      //   color: tRed,
                                      //   indent: 30,
                                      // ),
                                      if (rideDetails['rider_type'] == 1)
                                        Divider(
                                          height: 4.h,
                                          thickness: 0.9,
                                          color: tDividerColor,
                                        ),
                                      // TextFormField(
                                      //   controller: _destinationController
                                      //   //       context,
                                      //   //       DropGoogleMap(
                                      //   //         status: widget.status,
                                      //   //       ));
                                      //   // },
                                      //     hintText: 'Drop Location',
                                      //     fillColor: tBackground,
                                      //     filled: false,
                                      if (rideDetails['rider_type'] == 1)
                                        Text(
                                          rideDetails['drop_address'].toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          // 'Shrvan assigned as a driver',
                                          style: GoogleFonts.mulish(
                                            color: tDarkNavyblue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isTab(context) ? 9.sp : 11.sp,
                                          ),
                                        )
                                      // Container(
                                      //     child: Text(
                                      //   'Secunderabad Railway Station, Secunderabad, Telangana (500081)',
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //  LocationCards(rideDetails: rideDetails)
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            // expand: false,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                                child: Container(
                                    height: 100.h,
                                    // height: MediaQuery.of(context).size.height / 1,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    child: RideBill(viewbookingDetails: viewbookingDetails))),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'estimate_fare'.tr,
                                    style: GoogleFonts.mulish(
                                      color: tSecondaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 8.sp : 14.sp,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 15,
                                        color: tDate,
                                      ),
                                      SizedBox(height: 2.h)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                currencySymbol + ((rideDetails['price_detail']['estimatePrice'] + (rideDetails['price_detail']['cancellation_charges'] ?? 0)).toString()),
                                style: GoogleFonts.inter(
                                  color: tPrimaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: isTab(context) ? 16.sp : 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(color: tWhite, borderRadius: BorderRadius.circular(10), boxShadow: [tBoxShadow]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  Images.CALENDER,
                                  scale: isTab(context) ? 2 : 3.5,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  Twl.dateActualFormate(rideDetails['pickup_date']).toString() + ', ' + rideDetails['pickup_time'].toString(),
                                  style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 12.sp : 12.sp,
                                    fontWeight: FontWeight.w700,
                                    // fontFamily:
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 5.h,
                              width: 0.4.w,
                              color: tSecondaryColor,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  Images.TIMER,
                                  scale: isTab(context) ? 2 : 3.5,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                rideDetails['usage_hours'] == null
                                    ? Container()
                                    : Text(
                                        usageText,
                                        style: GoogleFonts.mulish(
                                          color: tSecondaryColor,
                                          fontSize: isTab(context) ? 12.sp : 12.sp,
                                          fontWeight: FontWeight.w700,
                                          // fontFamily:
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                        decoration: BoxDecoration(color: tWhite, borderRadius: BorderRadius.circular(10), boxShadow: [tBoxShadow]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  // the "100 KM" sign belongs to an outstation trip only; an in-city ride shows the in-city icon
                                  rideDetails['trip_type'] == 1 ? Images.IN_CITY : Images.OUT_STATION,
                                  scale: isTab(context) ? 7 : 7.5,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                rideDetails['trip_type'] == 1
                                    ? Text(
                                        'in_city'.tr,
                                        style: GoogleFonts.mulish(
                                          color: tSecondaryColor,
                                          fontSize: isTab(context) ? 12.sp : 12.sp,
                                          fontWeight: FontWeight.w700,
                                          // fontFamily:
                                        ),
                                      )
                                    : Text(
                                        'out_station'.tr,
                                        style: GoogleFonts.mulish(
                                          color: tSecondaryColor,
                                          fontSize: isTab(context) ? 12.sp : 12.sp,
                                          fontWeight: FontWeight.w700,
                                          // fontFamily:
                                        ),
                                      ),
                              ],
                            ),
                            Container(
                              height: 5.h,
                              width: 0.4.w,
                              color: tSecondaryColor,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  Images.ROUND_TRIP,
                                  scale: isTab(context) ? 2 : 3.5,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                rideDetails['rider_type'] == 1
                                    ? Text(
                                        'one_way'.tr,
                                        style: GoogleFonts.mulish(
                                          color: tSecondaryColor,
                                          fontSize: isTab(context) ? 12.sp : 12.sp,
                                          fontWeight: FontWeight.w700,
                                          // fontFamily:
                                        ),
                                      )
                                    : Text(
                                        'round'.tr,
                                        style: GoogleFonts.mulish(
                                          color: tSecondaryColor,
                                          fontSize: isTab(context) ? 12.sp : 12.sp,
                                          fontWeight: FontWeight.w700,
                                          // fontFamily:
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
                        decoration: BoxDecoration(color: tWhite, boxShadow: [tBackbtnBoxShadow], borderRadius: BorderRadiusDirectional.circular(10)),
                        child: Row(
                          children: [
                            Image.asset(
                              Images.CAR,
                              scale: isTab(context) ? 2 : 3.5,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              rideDetails['car_model'],
                              style: GoogleFonts.mulish(
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 12.sp : 12.sp,
                                fontWeight: FontWeight.w700,
                                // fontFamily:
                              ),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Text(
                              rideDetails['car_type'].toString() == '1' ? '(Automatic)' : '(Manual)',
                              style: GoogleFonts.mulish(
                                color: tSecondaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: isTab(context) ? 9.sp : 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      CustomerSupport(),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                              width: isTab(context) ? 50.w : 50.w,
                              height: isTab(context) ? 6.h : 7.h,
                              child: widget.bookingDetails['status'] != STATUS_USER_CANCELLED && widget.bookingDetails['status'] != STATUS_START_RIDE
                                  ? ButtonWidget(
                                      borderSide: BorderSide(
                                        color: tCancelRidebtn,
                                      ),
                                      color: tCancelRidebtn,
                                      child: Text(
                                        "cancel_ride".tr,
                                        style: GoogleFonts.mulish(
                                          color: tWhite,
                                          fontWeight: FontWeight.w800,
                                          fontSize: isTab(context) ? 10.sp : 16.sp,
                                        ),
                                      ),
                                      borderRadius: 8.0,
                                      onTap: (startLoading, stopLoading, btnState) async {
                                        widget.bookingDetails['status'] == STATUS_GO_FOR_PICKUP ? Twl.CancellationChargesAlert(context,widget.bookingDetails['userCancellationCharge'] , bookingDetails: widget.bookingDetails) :
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          // expand: false,
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 0),
                                              child: CancelRideBottomSheet(bookingDetails: widget.bookingDetails)),
                                        );

                                      })
                                  : Container()),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                ]),
              ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _RideInfoState - the data and logic behind its screen

// >>> START: CancelRideBottomSheet - screen/widget shell (the visible part is in its State class)
/// STEP 1 of cancelling: "Confirm your cancellation" sheet. The customer must
/// tick the terms box (a fee may apply) before the reason sheet opens.
class CancelRideBottomSheet extends StatefulWidget {
  const CancelRideBottomSheet({Key? key, this.bookingDetails}) : super(key: key);
  final bookingDetails;

  @override
  State<CancelRideBottomSheet> createState() => _CancelRideBottomSheetState();
}
// <<< END: CancelRideBottomSheet - screen/widget shell (the visible part is in its State class)

// >>> START: _CancelRideBottomSheetState - the data and logic behind its screen
class _CancelRideBottomSheetState extends State<CancelRideBottomSheet> {
  // Whether the "I agree to the Terms & Conditions" box is ticked.
  bool _isChecked = false;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // Keep the sheet above the keyboard.
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [tBoxShadow]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 4.h,
          ),
          // Heading: "Confirm your cancellation".
          Container(
            child: Text(
              'confirm_your_cancellation'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: tSecondaryColor, fontFamily: "mulish", fontSize: isTab(context) ? 10.sp : 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          // Warning that a cancellation fee may apply.
          Container(
            width: 80.w,
            child: Text(
              // The rule: free until a driver accepts; after that a charge is added to the customer's next ride.
              (int.tryParse(widget.bookingDetails['status'].toString()) ?? 0) == STATUS_WAITING_FOR_DRIVER
                  ? 'No driver has accepted yet, so you can cancel for free.'
                  : 'A driver has already accepted this ride. A cancellation charge will be added to your next ride.',
              textAlign: TextAlign.center,
              style: TextStyle(color: tDarkOrangeColor, fontFamily: "mulish", fontSize: isTab(context) ? 10.sp : 11.sp, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 9.h,
          ),
          // The terms checkbox.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Checkbox(
                activeColor: tPrimaryColor,
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              Container(
                child: Text(
                  'i_agree_to_the'.tr,
                  style: GoogleFonts.mulish(
                    color: tSecondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: isTab(context) ? 8.sp : 12.sp,
                  ),
                ),
              ),
              Container(
                child: Text(
                  'terms_conditions'.tr,
                  style: GoogleFonts.mulish(
                    color: tappbarclr,
                    fontWeight: FontWeight.w600,
                    fontSize: isTab(context) ? 8.sp : 12.sp,
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 2.h,
          ),
          // The red "Cancel Ride" button.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: isTab(context) ? 50.w : 50.w,
                height: isTab(context) ? 6.h : 7.h,
                child: ButtonWidget(
                    borderSide: BorderSide(
                      color: tCancelRidebtn,
                    ),
                    color: tCancelRidebtn,
                    child: Text(
                      "cancel_ride".tr,
                      style: GoogleFonts.mulish(
                        color: tWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: isTab(context) ? 10.sp : 16.sp,
                      ),
                    ),
                    borderRadius: 8.0,
                    onTap: (startLoading, stopLoading, btnState) async {
                      if (_isChecked == true) {
                        // Terms accepted: close this sheet and open STEP 2
                        // (choose a reason).
                        Twl.navigateBack(context);
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CancelReasonWidget(bookingDetails: widget.bookingDetails));
                      } else {
                        // Terms not accepted: ask again.
                        stopLoading();
                        Twl.createAlert(context, 'Oops', 'Accept Terms & Conditions');
                        stopLoading();
                      }
                    }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _CancelRideBottomSheetState - the data and logic behind its screen

// >>> START: CancelReasonWidget - list of reasons to choose from when cancelling
/// STEP 2 of cancelling: choose a reason (or type one) and press Submit, which
/// cancels the booking on the server.
class CancelReasonWidget extends StatefulWidget {
  const CancelReasonWidget({Key? key, this.bookingDetails}) : super(key: key);
  final bookingDetails;

  @override
  State<CancelReasonWidget> createState() => _CancelReasonWidgetState();
}
// <<< END: CancelReasonWidget - list of reasons to choose from when cancelling

// >>> START: _CancelReasonWidgetState - the data and logic behind its screen
class _CancelReasonWidgetState extends State<CancelReasonWidget> {
  // Free-text reason, used when no list item is chosen.
  TextEditingController _descriptionController = TextEditingController();
  // Index of the chosen reason in [reasonsList] (null = none chosen).
  var selectedIndex;

  /// The reasons offered to the customer. The text of the chosen reason is what
  /// the server stores as the cancellation reason.
  List reasonsList = [
    {
      "id": 0,
      "value": false,
      "title": "cancel_reason_booked_by_mistake".tr,
    },
    {
      "id": 1,
      "value": false,
      "title": "cancel_reason_change_of_plans".tr,
    },
    {
      "id": 2,
      "value": false,
      "title": "cancel_reason_found_another_ride".tr,
    },
    {
      "id": 3,
      "value": false,
      "title": "wrong_Pickup_Location".tr,
    },
  ];

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [tBoxShadow]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              // Heading "Cancel Ride" and the instruction line.
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'cancel_ride'.tr,
                  style: GoogleFonts.lexend(color: tSecondaryColor, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 8.sp : 13.sp),
                ),
              ),
              SizedBox(
                height: 0.8.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Please_select_Reason'.tr,
                  style: GoogleFonts.lexend(color: tDarkOrangeColor, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 8.sp : 11.sp),
                ),
              ),
              Divider(
                color: tDividerColor,
                height: 3.5.h,
                thickness: 0.9,
              ),
              // The radio list of reasons.
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 0,
                ),
                child: Column(
                  children: List.generate(
                    reasonsList.length,
                    (index) => Theme(
                      data: Theme.of(context).copyWith(unselectedWidgetColor: tSecondaryColor, disabledColor: Colors.green),
                      child: RadioListTile(
                        value: index,
                        activeColor: tPrimaryColor,
                        groupValue: selectedIndex,
                        // Remember which reason was tapped.
                        onChanged: (ind) {
                          setState(() => selectedIndex = ind);
                        },
                        title: Text(
                          reasonsList[index]["title"],
                          style: GoogleFonts.lexend(color: tBlack, fontSize: isTab(context) ? 10.sp : 13.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              // Optional free-text reason (used only when no list item chosen).
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: isTab(context) ? 4 : 3,
                  decoration: InputDecoration(
                      fillColor: tWhite,
                      filled: true,
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(width: 1.5, color: tgreen)),
                      hintStyle: TextStyle(color: tGray, fontSize: isTab(context) ? 7.sp : 10.sp, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: tgreen, width: 1.5))),
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              // -------------------------------------------------------
              // "Submit": cancel the booking on the server.
              // -------------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: isTab(context) ? 50.w : 60.w,
                    height: isTab(context) ? 6.h : 7.h,
                    child: ButtonWidget(
                        borderSide: BorderSide(
                          color: tPrimaryColor,
                        ),
                        color: tPrimaryColor,
                        child: Text(
                          "Submit".tr,
                          style: GoogleFonts.mulish(
                            color: tWhite,
                            fontWeight: FontWeight.w800,
                            fontSize: isTab(context) ? 10.sp : 16.sp,
                          ),
                        ),
                        borderRadius: 8.0,
                        onTap: (startLoading, stopLoading, btnState) async {
                          // 1. The reason: the chosen list item, otherwise
                          //    whatever was typed.
                          String reason;
                          if (selectedIndex != null) {
                            reason = reasonsList[selectedIndex]["title"];
                          } else {
                            reason = _descriptionController.text;
                          }

                          // 2. Ask the server to cancel this booking.
                          var res = await UserAPI().cancelRide(context, widget.bookingDetails['id'].toString(), reason.toString());
                          _descriptionController.clear();

                          if (res != null && res['status'] == 'OK') {
                            // 3a. Cancelled: back to My Bookings with a note.
                            stopLoading();
                            // Clear every screen behind and land on the
                            // Bookings tab (tab 1).
                            Navigator.of(context, rootNavigator: true)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            BottomNavigation(tabIndexId: 1)),
                                    (route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Your booking has been cancelled'),
                            ));
                          } else {
                            // 3b. Not cancelled: show the server's reason, or
                            //     a general message when there was no reply.
                            stopLoading();
                            return Twl.createAlert(
                                context,
                                'Oops',
                                (res is Map && res['error'] != null)
                                    ? res['error'].toString()
                                    : 'Could not cancel the booking. Please try again.');
                          }
                          stopLoading();
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _CancelReasonWidgetState - the data and logic behind its screen
