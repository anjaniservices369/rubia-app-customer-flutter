// =============================================================================
// WHAT : Booking details with the driver, OTP and payment; polls the booking
//        status.
// NOTES: Server: view-booking-details.
// =============================================================================
import 'dart:async';
import 'dart:developer';

import 'package:base_project_flutter/globalWidgets/buttonIconWidget.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/views/RideBooking/rideBill.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';

import 'package:base_project_flutter/responsive.dart';
import '../../../api_services/userApi.dart';

import '../../../globalWidgets/helpandsos.dart';

import 'finalRideDetailsView/finalRideDetailsView.dart';
import 'rateRide.dart';
import 'rideDetailsView/components/rideInfo.dart';
import '../../bottomNavigation.dart/bottomNavigation.dart';

// >>> START: RideDetailsPayment - screen/widget shell (the visible part is in its State class)
class RideDetailsPayment extends StatefulWidget {
  const RideDetailsPayment({Key? key, this.bookingDetails, this.tripStatus, this.status, this.pickupAddress, this.dropAddress}) : super(key: key);
  final tripStatus;
  final status;
  final pickupAddress;
  final dropAddress;
  final bookingDetails;

  @override
  State<RideDetailsPayment> createState() => _RideDetailsPaymentState();
}
// <<< END: RideDetailsPayment - screen/widget shell (the visible part is in its State class)

TextEditingController _destinationController = TextEditingController();
TextEditingController _searchController = TextEditingController();

// >>> START: _RideDetailsPaymentState - the data and logic behind its screen
class _RideDetailsPaymentState extends State<RideDetailsPayment> {
  var details;
  var viewbookingDetails;
  var resNOK;
  bool isBack = false;
  Timer? timer;
  // final InAppReview inAppReview = InAppReview.instance;
  // >>> START: launchURL - launch url
  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
    }
  }
  // <<< END: launchURL - launch url

  // >>> START: getViewBooking - gets view booking
  getViewBooking() async {
    timer = Timer.periodic(Duration(seconds: 5), (_timer) async {
      details = await UserAPI().viewBooking(context, widget.bookingDetails['id'].toString());

      if (details != null && details['status'] == 'OK') {
        if (mounted) {
          setState(() {
            viewbookingDetails = details['details'];
            log('rideDetailssssssss $viewbookingDetails');
          });
        }
        if (viewbookingDetails['status'] == STATUS_DRIVER_REJECTED ||
            viewbookingDetails['status'] == STATUS_RIDE_COMPLETED ||
            viewbookingDetails['status'] == STATUS_USER_CANCELLED ||
            viewbookingDetails['status'] == STATUS_BOOKING_AUTO_CANCELLED ||
            viewbookingDetails['status'] == STATUS_CANCELLED) {
          // Stop polling first: the rating sheet below can stay open a while.
          timer!.cancel();
          _timer.cancel();
          final finished = viewbookingDetails;
          if (finished['status'] == STATUS_RIDE_COMPLETED) {
            // The ride just ended: ask for the rating right away. A rating
            // opens Home; 'Later' continues to the bill below.
            await RideRatingPrompt.promptCompleted(context, finished);
            if (!mounted) return;
          }
          Twl.navigateTo(
              context,
              FinalRideDetailsView(
                rideDetails: finished,
              ));
        }
      } else {
        timer!.cancel();
        _timer.cancel();
        setState(() {
          resNOK = details['status'];
        });
      }
    });
  }
  // <<< END: getViewBooking - gets view booking

  // >>> START: fetchAndUpdateOrderDetails - fetches and update order details
  Future<void> fetchAndUpdateOrderDetails() async {
    var updatedDetails = await UserAPI().viewBooking(context, widget.bookingDetails['id'].toString());

    if (updatedDetails != null && updatedDetails['status'] == 'OK') {
      setState(() {
        viewbookingDetails = updatedDetails['details'];

        // Additional UI updates based on the updated details

        if (shouldStopTimer(viewbookingDetails['status'])) {
          timer?.cancel();
        }
      });
    }
  }
  // <<< END: fetchAndUpdateOrderDetails - fetches and update order details

  // >>> START: shouldStartTimer - should start timer
  bool shouldStartTimer(String status) {
    return status == 'STATUS_START_RIDE' ||
        status == 'STATUS_WAITING_FOR_DRIVER ' ||
        status == 'STATUS_GO_FOR_PICKUP ' ||
        status == 'STATUS_ARRIVED_LOCATION' ||
        status == 'STATUS_DRIVER_ACCEPTED';
  }
  // <<< END: shouldStartTimer - should start timer

  // >>> START: shouldStopTimer - should stop timer
  bool shouldStopTimer(String status) {
    return status == 'STATUS_DRIVER_REJECTED ' ||
        status == 'STATUS_RIDE_COMPLETED' ||
        status == 'STATUS_CANCELLED' ||
        status == 'STATUS_DRIVER_CANCELLED' ||
        status == 'STATUS_BOOKING_AUTO_CANCELLED';
  }
  // <<< END: shouldStopTimer - should stop timer


  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  void initState() {
    viewbookingDetails = {};
    // Remember this booking, so the rating prompt still appears if the ride
    // ends while the customer is on another screen (see rateRide.dart).
    SharedPreferences.getInstance().then(
        (p) => p.setString('booking_id', widget.bookingDetails['id'].toString()));
    getViewBooking();

    // TODO: implement initState
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  GoogleMapController? _mapController;

  final Set<Polyline> _polylines = Set();

  final LatLng _point1 = LatLng(17.44654670, 78.39225210);
  final LatLng _point2 = LatLng(17.387140, 78.491684);

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
            context,
            BottomNavigation(
              tabIndexId: 1,
            ));
      },
      child: Scaffold(
        backgroundColor: tWhite,
        // appBar: AppBar(
        //   backgroundColor: null,
        //   leading: GestureDetector(
        //     onTap: () {
        //       Twl.forceNavigateTo(
        //           context,
        //           BottomNavigation(
        //             tabIndexId: 1,
        //           ));
        //     },
        body: Builder(builder: (context) {
          final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

          if (viewbookingDetails.isEmpty) {
            return Center(
                child: CircularProgressIndicator(
              color: tPrimaryColor,
            ));
          }
          // Extract the pickup and drop coordinates
          String pickupLatitude = viewbookingDetails['pickup_latitude'];
          String pickupLongitude = viewbookingDetails['pickup_longitude'];
          String dropLatitude = viewbookingDetails['drop_latitude'] ??  '';
          String dropLongitude = viewbookingDetails['drop_longitude']?? '';
          Set<Marker> markers = {};
          // Create LatLng objects for pickup and drop coordinates
          LatLng pickupLatLng = LatLng(double.parse(pickupLatitude), double.parse(pickupLongitude));
          LatLng dropLatLng;

          if (dropLatitude != null && dropLatitude.isNotEmpty && dropLongitude != null && dropLongitude.isNotEmpty) {
            dropLatLng = LatLng(double.parse(dropLatitude), double.parse(dropLongitude));

            markers.add(
              Marker(
                markerId: MarkerId('pickup'),
                position: pickupLatLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                // Add any additional properties for the marker
              ),
            );

            markers.add(
              Marker(
                markerId: MarkerId('drop'),
                position: dropLatLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                // Add any additional properties for the marker
              ),
            );
            _polylines.add(Polyline(
              polylineId: PolylineId("line 1"),
              visible: true,
              width: 2,
              patterns: [PatternItem.dash(30), PatternItem.gap(10)],
              points: MapsCurvedLines.getPointsOnCurve(pickupLatLng, dropLatLng),
              color: tBlack,
            ));
          } else {
            markers.add(
              Marker(
                markerId: MarkerId('pickup'),
                position: pickupLatLng,

                // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                // Add any additional properties for the marker
              ),
            );
          }

          return viewbookingDetails == null
              ? Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: SpinKitThreeBounce(
                        color: tPrimaryColor,
                        size: 20.0,
                      )),
                )
              : Container(
                  child: WillPopScope(
                    onWillPop: () {
                      return Twl.forceNavigateTo(
                          context,
                          BottomNavigation(
                            tabIndexId: 1,
                          ));
                    },
                    child: Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: (controller) {
                            _mapController = controller;
                            // _mapController!.setMapStyle(AutofillHints.location);
                          },
                          initialCameraPosition: CameraPosition(
                            target: pickupLatLng, // Initial camera position
                            zoom: 14.0,
                          ),
                          polylines: _polylines, // Set the polyline on the map
                          markers: markers,
                        ),
                        Positioned(
                          top: 30,
                          left: 5,
                          child: GestureDetector(
                            onTap: () {
                              Twl.forceNavigateTo(
                                  context,
                                  BottomNavigation(
                                    tabIndexId: 1,
                                  ));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(isTab(context) ? 10 : 13.0),
                              child: BackIconWidget(),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 70,
                          right: 5,
                          child: GestureDetector(
                            onTap: () async {
                              await launchURL(CHAT_LINK);
                            },
                            child: Container(
                              width: 25.w,
                              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
                              decoration: BoxDecoration(color: tPrimaryColor, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    Images.HELP_ICON,
                                    scale: isTab(context) ? 2.5 : 3.5,
                                    color: tWhite,
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Text(
                                    'help'.tr,
                                    style: GoogleFonts.mulish(color: tWhite, fontWeight: FontWeight.w700, fontSize: isTab(context) ? 8.sp : 11.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            showBarModalBottomSheet(
                              context: context,
                              backgroundColor: tWhite,
                              builder: (context) => Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: Emergencywidget()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(color: tpinkcolor, shape: BoxShape.circle),
                                    child: Text('SOS',
                                        style: GoogleFonts.mulish(
                                            color: tBackground, fontWeight: FontWeight.w800, fontSize: isTab(context) ? 7.sp : 9.sp)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Twl.forceNavigateTo(context, RideInfo());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        color: tWhite,
                                        boxShadow: [tBoxShadow],
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          viewbookingDetails['status'] == STATUS_DRIVER_ACCEPTED
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                                  decoration:
                                                      BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(8)),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tDarkNavyblue, width: 2)),
                                                        child: CircleAvatar(
                                                          backgroundColor: tWhite,
                                                          backgroundImage: viewbookingDetails['driver_image'] == ""
                                                              ? NetworkImage(Images.UNKNOWN_IMAGE)
                                                              : NetworkImage(viewbookingDetails['driver_image']),
                                                          radius: isTab(context) ? 20 : 30,
                                                        ),
                                                      ),
                                                      // Container(
                                                      //     decoration: BoxDecoration(
                                                      //         shape:
                                                      //             BoxShape.circle,
                                                      //         border: Border.all(
                                                      //             color:
                                                      //                 tDarkNavyblue,
                                                      //             width: 2)),
                                                      //     child: CircleAvatar(
                                                      //       backgroundColor:
                                                      //           tWhite,
                                                      //       backgroundImage: NetworkImage(
                                                      //           viewbookingDetails[
                                                      //               'driver_image']),
                                                      //       // AssetImage(Images.DRIVER),
                                                      //       radius: isTab(context)
                                                      //           ? 20
                                                      //           : 25,
                                                      //     ),
                                                      //   ),
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            viewbookingDetails['driver_name'],
                                                            style: GoogleFonts.mulish(
                                                                color: tDarkNavyblue,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: isTab(context) ? 9.sp : 12.sp),
                                                          ),
                                                          SizedBox(
                                                            height: 0.6.h,
                                                          ),
                                                          Text(
                                                            'Driver',
                                                            style: GoogleFonts.mulish(
                                                                color: tDarkOrangeColor,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: isTab(context) ? 7.sp : 9.sp),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          launch("tel://" + viewbookingDetails['driver_contact'].toString());
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(8),
                                                          decoration: BoxDecoration(color: tDarkGreen, shape: BoxShape.circle),
                                                          child: Icon(
                                                            Icons.call,
                                                            size: isTab(context) ? 15 : 22,
                                                            color: tWhite,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : viewbookingDetails['status'] == STATUS_START_RIDE
                                                  ? Text(
                                                      'Ongoing ride'.tr,
                                                      style: TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w600, fontSize: 12.sp),
                                                    )
                                                  : viewbookingDetails['status'] == STATUS_GO_FOR_PICKUP
                                                      ? Text(
                                                          'Driver Arriving Location'.tr,
                                                          style: TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w600, fontSize: 12.sp),
                                                        )
                                                      : viewbookingDetails['status'] == STATUS_WAITING_FOR_DRIVER
                                                          ? Text(
                                                              'waiting_for_driver'.tr,
                                                              style: TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w600, fontSize: 12.sp),
                                                            )
                                                          : viewbookingDetails['status'] == STATUS_ARRIVED_LOCATION
                                                              ? Text(
                                                                  'Arrived the location'.tr,
                                                                  style:
                                                                      TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w600, fontSize: 12.sp),
                                                                )
                                                              : Text(
                                                                  'Driver Arriving Location'.tr,
                                                                  style:
                                                                      TextStyle(color: tPrimaryColor, fontWeight: FontWeight.w600, fontSize: 12.sp),
                                                                )
                                        ]),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Container(
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
                                                    if (viewbookingDetails['rider_type'] == 1)
                                                      DottedLine(
                                                        direction: Axis.vertical,
                                                        lineLength: 30,
                                                        lineThickness: 1.0,
                                                        dashLength: 4.0,
                                                        dashColor: tDotted,
                                                        dashGapLength: 4.0,
                                                        dashGapRadius: 0.0,
                                                      ),
                                                    if (viewbookingDetails['rider_type'] == 1)
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
                                                        viewbookingDetails['pickup_address'],
                                                        style: GoogleFonts.mulish(
                                                            color: tDarkNavyblue,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: isTab(context) ? 7.sp : 10.sp),
                                                      ),

                                                      // TextFormField(
                                                      //   controller: _searchController
                                                      //     ..text = widget.pickupAddress
                                                      //         .toString(),
                                                      //   onTap: () {
                                                      //     Twl.forceNavigateTo(
                                                      //         context,
                                                      //         PickupAddressGoogleMapPage(
                                                      //           status: widget.status,
                                                      //         ));
                                                      //   },
                                                      //           ? 9.sp
                                                      //           : 11.sp,
                                                      //       fontWeight: FontWeight.w600,
                                                      //     ),
                                                      //     hintText: 'Pickup Location',
                                                      //     fillColor: tBackground,
                                                      //     filled: false,
                                                      // VerticalDivider(
                                                      //   width: 10,
                                                      //   color: tRed,
                                                      //   indent: 30,
                                                      // ),
                                                      if (viewbookingDetails['rider_type'] == 1)
                                                        Divider(
                                                          height: 4.h,
                                                          thickness: 0.9,
                                                          color: tDividerColor,
                                                        ),
                                                      // TextFormField(
                                                      //   controller: _destinationController
                                                      //     ..text = widget.dropAddress
                                                      //         .toString(),
                                                      //   onTap: () {
                                                      //     Twl.forceNavigateTo(
                                                      //         context,
                                                      //         DropGoogleMap(
                                                      //           status: widget.status,
                                                      //         ));
                                                      //   },
                                                      //           ? 9.sp
                                                      //           : 11.sp,
                                                      //       fontWeight: FontWeight.w600,
                                                      //     ),
                                                      //     hintText: 'Drop Location',
                                                      //     fillColor: tBackground,
                                                      //     filled: false,
                                                      if (viewbookingDetails['rider_type'] == 1)
                                                        Text(
                                                          viewbookingDetails['drop_address'],
                                                          style: GoogleFonts.mulish(
                                                              color: tDarkNavyblue,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: isTab(context) ? 7.sp : 10.sp),
                                                        ),
                                                      // Container(
                                                      //     child: Text(
                                                      //   'Secunderabad Railway Station, Secunderabad, Telangana (500081)',
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Twl.forceNavigateTo(
                                        //         context, PaymentSelection());
                                        //   },
                                        //   child: Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 3.5.w, vertical: 1.5.h),
                                        //     decoration: BoxDecoration(
                                        //         color: tWhite,
                                        //         boxShadow: [tBoxShadow],
                                        //         borderRadius:
                                        //             BorderRadius.circular(8)),
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.spaceBetween,
                                        //       children: [
                                        //         Container(
                                        //             padding: EdgeInsets.all(12),
                                        //             decoration: BoxDecoration(
                                        //                 color: tYellow,
                                        //                 shape: BoxShape.circle),
                                        //             child: Image.asset(
                                        //               Images.QR_SCANNER,
                                        //               scale:
                                        //                   isTab(context) ? 2.5 : 3,
                                        //             )),
                                        //         SizedBox(
                                        //           width: 3.w,
                                        //         ),
                                        //         Column(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             Text(
                                        //               'pay_at'.tr,
                                        //               style: GoogleFonts.mulish(
                                        //                   color: tDarkNavyblue,
                                        //                   fontWeight:
                                        //                       FontWeight.w700,
                                        //                   fontSize: isTab(context)
                                        //                       ? 9.sp
                                        //                       : 12.sp),
                                        //             ),
                                        //             SizedBox(
                                        //               height: 0.6.h,
                                        //             ),
                                        //             Text(
                                        //               'change_payment'.tr,
                                        //               style: GoogleFonts.mulish(
                                        //                   color: tDarkOrangeColor,
                                        //                   fontWeight:
                                        //                       FontWeight.w700,
                                        //                   fontSize: isTab(context)
                                        //                       ? 7.sp
                                        //                       : 9.sp),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         Spacer(),
                                        //         GestureDetector(
                                        //           // onTap: () {
                                        //           //   Twl.forceNavigateTo(
                                        //           //       context, PaymentSelection());
                                        //           // },
                                        //           child: Icon(
                                        //             Icons.keyboard_arrow_right,
                                        //             size: isTab(context) ? 25 : 35,
                                        //             color: tPrimaryColor,
                                        //           ),
                                        //         ),
                                        //       ],
                                        SizedBox(
                                          height: 1.8.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20, left: 0, right: 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                // expand: false,
                                                context: context,
                                                backgroundColor: Colors.transparent,
                                                builder: (context) => Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                                                    child: Container(
                                                        height: 90.h,
                                                        // height: MediaQuery.of(context).size.height / 1,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                        child: RideBill(viewbookingDetails: viewbookingDetails))),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadiusDirectional.circular(8)),
                                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                              child: Row(children: [
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    'Estimate Price'.tr,
                                                    style: TextStyle(
                                                        fontSize: isTab(context) ? 8.sp : 12.sp, fontWeight: FontWeight.w500, color: tDarkNavyblue),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 1.5.w,
                                                ),

                                                Row(
                                                  children: [
                                                    Text(
                                                      currencySymbol + ((viewbookingDetails['price_detail']['estimatePrice'] + (viewbookingDetails['price_detail']['cancellation_charges'] ?? 0)).toString()),
                                                      style: GoogleFonts.mulish(
                                                        color: tDarkNavyblue,
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: isTab(context) ? 14.sp : 20.sp,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Icon(
                                                          Icons.info_outline,
                                                          size: 15,
                                                          color: tPrimaryColor,
                                                        ),
                                                        SizedBox(height: 2.h)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                //         isTab(context) ? 12.0 : 8.0,
                                                //     color: tPrimaryColor,
                                                //     child: Text(
                                                //       "Pay".tr,
                                                //       // style: TextStyle(
                                                //       //     letterSpacing: 1,
                                                //       //     color: tBlack,
                                                //       //     fontWeight: FontWeight.w700,
                                                //       //
                                                //       style: GoogleFonts.mulish(
                                                //           color: tWhite,
                                                //           fontWeight:
                                                //               FontWeight.w700,
                                                //           fontSize: isTab(context)
                                                //               ? 9.sp
                                                //               : 16.sp),
                                                //     ),
                                                //     onTap: (startLoading,
                                                //         stopLoading, btnState) {
                                                //       Twl.forceNavigateTo(context,
                                                //           PaymentSelection());
                                                //     },
                                                //     borderSide: BorderSide(
                                              ]),
                                            ),
                                          ),
                                        )
                                        //           borderSide: BorderSide(
                                        //             color: tPrimaryColor,
                                        //           ),
                                        //           // borderRadius: BorderRadius.circular(15),
                                        //           borderRadius: 15.0,
                                        //           color: tPrimaryColor,
                                        //           textcolor: Colors.black,
                                        //           child: Text(
                                        //             "Login",
                                        //             style: TextStyle(
                                        //                 letterSpacing: 1,
                                        //                 color: tWhite,
                                        //                 fontWeight: FontWeight.w700,
                                        //                 fontSize:
                                        //                     isTab(context) ? 10.sp : 16.sp),
                                        //           ),
                                        //           onTap: (startLoading, stopLoading,
                                        //               btnState) async {
                                        //             //     print(_usernumbercontroller.text);
                                        //             //        Map<String, String> param = {
                                        //             //     'contact_no': _usernumbercontroller.text,
                                        //             //   };
                                        //             // Twl.navigateTo(
                                        //             //     context,
                                        //             //     Otppage(
                                        //             //         mobileNumber:
                                        //             //             _usernumbercontroller.text,
                                        //             //         // sessionCode: res['details']
                                        //             //         //     ['Details'],
                                        //             //         ));

                                        //             // // startLoading();
                                        //             // // if (_formKey.currentState!.validate()) {
                                        //             // //   // if (isChecked == true) {
                                        //             // //   Map<String, String> param = {
                                        //             // //     'contact_no': _usernumbercontroller.text,
                                        //             // //   };
                                        //             // //   print(param);
                                        //             // //   var res =
                                        //             // //       await UserAPI().sendOtp(context, param);
                                        //             // //   if (res != null && res['status'] == 'OK') {
                                        //             // //     Twl.navigateTo(
                                        //             // //         context,
                                        //             // //         Otppage(
                                        //             // //           mobileNumber:
                                        //             // //               _usernumbercontroller.text,
                                        //             // //           sessionCode: res['details']
                                        //             // //               ['Details'],
                                        //             // //         ));
                                        //             // //   } else {
                                        //             // //     stopLoading();
                                        //             // //     Twl.createAlert(context, 'Oops',
                                        //             // //         res['error'].toString());
                                        //             // //     stopLoading();
                                        //             // //   }
                                        //             // //   stopLoading();
                                        //             // //   // } else {
                                        //             // //   //   stopLoading();
                                        //             // //   //   // return _showDialog(context);
                                        //             // //   // }
                                        //             // // }
                                        //             // // stopLoading();
                                        //           }),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: isTab(context) ? -90 : -10,
                                  // left: isTab(context)?155:115,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                        decoration: BoxDecoration(color: tYellow, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('OTP : ' + viewbookingDetails['otp'],
                                                style: GoogleFonts.mulish(
                                                    color: tDarkNavyblue, fontWeight: FontWeight.w800, fontSize: isTab(context) ? 9.sp : 12.sp)),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      InkWell(
                                        //behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          Twl.navigateTo(context, RideInfo(bookingDetails: widget.bookingDetails));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: tPrimaryColor, shape: BoxShape.circle),
                                          child: InkWell(
                                            onTap: () {
                                              Twl.navigateTo(context, RideInfo(bookingDetails: widget.bookingDetails));
                                            },
                                            child: Icon(
                                              Icons.info,
                                              size: isTab(context) ? 25 : 35,
                                              color: tbrown,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _RideDetailsPaymentState - the data and logic behind its screen
