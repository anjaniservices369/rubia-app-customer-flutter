// =============================================================================
// WHAT : TAXI: choose the type of vehicle (bike, auto, car) for the ride.
// NOTES: Taxi service, currently hidden.
// =============================================================================
import 'dart:math';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/buttonIconWidget.dart';
import 'package:base_project_flutter/globalWidgets/buttonWidget.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../responsive.dart';
import '../views/homePage/components/paymentSelection.dart';

// >>> START: SelectVehicle - screen/widget shell (the visible part is in its State class)
class SelectVehicle extends StatefulWidget {
  const SelectVehicle({Key? key}) : super(key: key);

  @override
  _SelectVehicleState createState() => _SelectVehicleState();
}
// <<< END: SelectVehicle - screen/widget shell (the visible part is in its State class)

// >>> START: _SelectVehicleState - the data and logic behind its screen
class _SelectVehicleState extends State<SelectVehicle> {
  GoogleMapController? mapController;
  PanelController panelController = PanelController();
  // int selectedIndex = 0;

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();

    // Access your provider instance
    final tripOptionsProvider =
        Provider.of<TripOptionsProvider>(context, listen: false);

    // Call your provider method to fetch data
    tripOptionsProvider.getVehicles(context);
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    final polylineCoordinates = tripOptionsProvider.polylineCoordinates;

    return Scaffold(
        body: Stack(
      children: [
        Consumer<TripOptionsProvider>(
          builder: (context, tripOptionsProvider, _) {
            if (tripOptionsProvider.pickupLatitude.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            LatLngBounds? bounds;

            if (tripOptionsProvider.pickupLatitude.isNotEmpty &&
                tripOptionsProvider.pickupLongitude.isNotEmpty &&
                tripOptionsProvider.dropLatitude.isNotEmpty &&
                tripOptionsProvider.dropLongitude.isNotEmpty) {
              LatLng pickupLatLng = LatLng(
                double.parse(tripOptionsProvider.pickupLatitude),
                double.parse(tripOptionsProvider.pickupLongitude),
              );
              LatLng dropLatLng = LatLng(
                double.parse(tripOptionsProvider.dropLatitude),
                double.parse(tripOptionsProvider.dropLongitude),
              );
              bounds = LatLngBounds(
                southwest: LatLng(
                  min(pickupLatLng.latitude, dropLatLng.latitude),
                  min(pickupLatLng.longitude, dropLatLng.longitude),
                ),
                northeast: LatLng(
                  max(pickupLatLng.latitude, dropLatLng.latitude),
                  max(pickupLatLng.longitude, dropLatLng.longitude),
                ),
              );
              // tripOptionsProvider.getRoute();
            }

            CameraPosition initialCameraPosition = CameraPosition(
              target: LatLng(
                double.parse(tripOptionsProvider.pickupLatitude),
                double.parse(tripOptionsProvider.pickupLongitude),
              ),
              zoom: 12,
            );
            return GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: tripOptionsProvider.markers,
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: tripOptionsProvider.polylineCoordinates,
                  color: Colors.blue,
                  width: 5,
                ),
              },
            );
          },
        ),
        SlidingUpPanel(
          controller: panelController,
          minHeight: 60.h, // Minimum height of the panel
          maxHeight: 60.h, // Maximum height of the panel
          isDraggable: false,
          panelBuilder: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [tBoxShadow],
                  color: tWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [tBoxShadow],
                            color: tBlack),
                      ),
                      Container(
                        width: 10.w,
                        child: GestureDetector(
                            onTap: () async {
                              Twl.navigateBack(
                                context,
                              );
                            },
                            child: BackIconWidget()),
                      ),
                      Consumer<TripOptionsProvider>(
                        builder: (context, tripOptionsProvider, _) {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available Rides',
                                  style: GoogleFonts.mulish(
                                    color: tDarkNavyblue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTab(context) ? 13.sp : 16.sp,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      tripOptionsProvider.vehicles.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final vehicle =
                                        tripOptionsProvider.vehicles[index];
                                    return GestureDetector(
                                      onTap: () {
                                        tripOptionsProvider
                                            .setSelectedVehicle(index);
                                        tripOptionsProvider
                                            .setVehicleId(vehicle['id']);
                                        tripOptionsProvider
                                            .setRideFare(vehicle['total_fare']);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [tBackbtnBoxShadow],
                                            color: tripOptionsProvider
                                                        .selectedIndex ==
                                                    index
                                                ? tPrimaryColor
                                                : tWhite,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  isTab(context) ? 20 : 14),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 1.h),
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: tripOptionsProvider
                                                                    .selectedIndex ==
                                                                index
                                                            ? tPrimaryColor
                                                            : tGray,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12)),
                                                        border: Border.all(
                                                          color: tripOptionsProvider
                                                                      .selectedIndex ==
                                                                  index
                                                              ? tBlack
                                                              : tPrimaryColor,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Container(
                                                        height: 5.h,
                                                        width: 12.w,
                                                        child: Image.network(
                                                          vehicle[
                                                              'image'], // Replace with your image URL
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 6.w),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 20.w,
                                                      child: Text(
                                                        vehicle['title']
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: tBlack,
                                                          fontSize:
                                                              isTab(context)
                                                                  ? 11.sp
                                                                  : 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 1.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          ' ${vehicle['no_of_person']} persons',
                                                          style: GoogleFonts
                                                              .mulish(
                                                            color: tripOptionsProvider
                                                                        .selectedIndex ==
                                                                    index
                                                                ? tBlack
                                                                : tGray,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                isTab(context)
                                                                    ? 8.sp
                                                                    : 11.sp,
                                                          ),
                                                        ),
                                                        SizedBox(width: 3.w),
                                                        Image.asset(
                                                          Images.TIMER,
                                                          scale: isTab(context)
                                                              ? 3.5
                                                              : 7,
                                                          color: tripOptionsProvider
                                                                      .selectedIndex ==
                                                                  index
                                                              ? tBlack
                                                              : tGray,
                                                        ),
                                                        SizedBox(width: 0.8.w),
                                                        Text(
                                                          vehicle['driving_distance']
                                                              ['distance'],
                                                          style: GoogleFonts
                                                              .mulish(
                                                            color: tripOptionsProvider
                                                                        .selectedIndex ==
                                                                    index
                                                                ? tBlack
                                                                : tGray,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                isTab(context)
                                                                    ? 8.sp
                                                                    : 11.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${currencySymbol}${vehicle['total_fare']}',
                                                        style: TextStyle(
                                                          color: tBlack,
                                                          fontSize:
                                                              isTab(context)
                                                                  ? 10.sp
                                                                  : 13.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (tripOptionsProvider.couponCode !=
                                            null &&
                                        tripOptionsProvider
                                            .couponCode.isNotEmpty) {
                                      tripOptionsProvider.removeCoupon(context);
                                    } else {
                                      // Twl.forceNavigateTo(context,
                                      //     CouponsPage(boolcouponpage: true));
                                    }
                                  },
                                  child: Container(
                                    // width: 45.w,
                                    decoration: BoxDecoration(
                                        color: tWhite,
                                        boxShadow: [tBackbtnBoxShadow],
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                10)),
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
                                          Text(
                                            tripOptionsProvider.couponCode !=
                                                        null &&
                                                    tripOptionsProvider
                                                        .couponCode.isNotEmpty
                                                ? tripOptionsProvider.couponCode
                                                : "Apply Coupon Code",
                                            style: GoogleFonts.mulish(
                                              color: tDarkNavyblue,
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  isTab(context) ? 8.sp : 12.sp,
                                            ),
                                          ),
                                          Spacer(),
                                          tripOptionsProvider
                                                  .couponCode.isNotEmpty
                                              ? Icon(
                                                  Icons.clear,
                                                  color: tPrimaryColor,
                                                  size:
                                                      isTab(context) ? 40 : 30,
                                                )
                                              : Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: tPrimaryColor,
                                                  size:
                                                      isTab(context) ? 40 : 30,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Twl.forceNavigateTo(
                                        context, PaymentSelection());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: tWhite,
                                        boxShadow: [tBackbtnBoxShadow],
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                10)),
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
                                                fontSize: isTab(context)
                                                    ? 8.sp
                                                    : 12.sp,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.keyboard_arrow_right,
                                            color: tPrimaryColor,
                                            size: isTab(context) ? 40 : 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: isTab(context) ? 50.w : 76.w,
                                    height: isTab(context) ? 6.h : 7.h,
                                    child: ButtonWidget(
                                        borderSide: BorderSide(color: tBlack),
                                        color: tBlack,
                                        borderRadius:
                                            isTab(context) ? 40.0 : 30.0,
                                        child: Text(
                                          'Book Ride',
                                          style: TextStyle(
                                              color: tWhite,
                                              fontWeight: FontWeight.w600,
                                              fontSize: isTab(context)
                                                  ? 10.sp
                                                  : 15.sp),
                                        ),
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          startLoading();
                                          var response =
                                              await tripOptionsProvider
                                                  .getRideRequest(context);
                                          if (response['status'] == 'OK') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Your ride booked successfully"),
                                              ),
                                            );
                                            stopLoading();
                                            // Twl.navigateTo(context, OrderPlaced());
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('error'.tr),
                                                content: Text(
                                                    'failed_to_save_try_again'
                                                        .tr),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                    },
                                                    child: Text('ok'.tr),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          // print(param);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SelectVehicleState - the data and logic behind its screen
