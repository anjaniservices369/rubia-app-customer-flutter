// =============================================================================
// WHAT : TAXI: shows the taxi options with fares and the Book Ride button.
//        Booking creates the ride on the server and asks it to find nearby
//        drivers.
// NOTES: The Taxi service is currently shown as 'Coming soon' on the home
//        screen.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/taxiservices/rideservices/riderServices.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/buttonIconWidget.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/taxiservices/rideservices/rideLayout.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/homePage/components/coupons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../globalWidgets/buttonWidget.dart';

// >>> START: AvailableRides - screen/widget shell (the visible part is in its State class)
class AvailableRides extends StatefulWidget {
  const AvailableRides({Key? key}) : super(key: key);

  @override
  State<AvailableRides> createState() => _AvailableRidesState();
}
// <<< END: AvailableRides - screen/widget shell (the visible part is in its State class)

// >>> START: _AvailableRidesState - the data and logic behind its screen
class _AvailableRidesState extends State<AvailableRides> {
  bool isLoading = true;
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override



  void initState() {
    super.initState();

    // Access your provider instance
    final tripOptionsProvider =
        Provider.of<TripOptionsProvider>(context, listen: false);

    // Call your provider method to fetch data
    tripOptionsProvider.getVehicles(context).then((_) {
      setState(() {
        isLoading = false; // Update loading state once data is fetched
      });

      // Set the initial selected vehicle if the list is not empty
      if (tripOptionsProvider.vehicles.isNotEmpty) {
        tripOptionsProvider.setSelectedVehicle(0); // Select the first vehicle
        tripOptionsProvider
            .setServiceVehicleType(tripOptionsProvider.vehicles[0]['id']);
        tripOptionsProvider
            .setServiceRideFare(tripOptionsProvider.vehicles[0]['total_fare']);
      }
    });
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Consumer<TripOptionsProvider>(
              builder: (context, tripOptionsProvider, _) {
                if (isLoading) {
                  return Center(
                    child: Container(
                      child: SpinKitThreeBounce(
                        color: tPrimaryColor,
                        size: 20.0,
                      ),
                    ),
                  );
                } else if (tripOptionsProvider.vehicles.isEmpty) {
                  return Container(
                      child: Center(
                    child: Text(
                      'No Riders found',
                      style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontWeight: FontWeight.w700,
                        fontSize: isTab(context) ? 11.sp : 15.sp,
                      ),
                    ),
                  ));
                } else {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Container(
                              width: 10.w,
                              child: GestureDetector(
                                  onTap: () async {
                                    tripOptionsProvider.resetValues();
                                    tripOptionsProvider.resetProviderValues();
                                    Twl.navigateBack(context);
                                  },
                                  child: BackIconWidget()),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              'Available Rides',
                              style: GoogleFonts.mulish(
                                color: tDarkNavyblue,
                                fontWeight: FontWeight.w700,
                                fontSize: isTab(context) ? 13.sp : 16.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: tripOptionsProvider.vehicles.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final vehicle =
                                    tripOptionsProvider.vehicles[index];
                                return GestureDetector(
                                  onTap: () {
                                    tripOptionsProvider
                                        .setSelectedVehicle(index);
                                    tripOptionsProvider
                                        .setServiceVehicleType(vehicle['id']);
                                    tripOptionsProvider.setServiceRideFare(
                                        vehicle['total_fare']);

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [tBackbtnBoxShadow],
                                      color:
                                          tripOptionsProvider.selectedIndex ==
                                                  index
                                              ? tPrimaryColor
                                              : tWhite,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              isTab(context) ? 20 : 14)),
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
                                                          Radius.circular(12)),
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
                                                  vehicle['title'].toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: tBlack,
                                                    fontSize: isTab(context)
                                                        ? 11.sp
                                                        : 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1.h),
                                              Row(
                                                children: [
                                                  Text(
                                                    ' ${vehicle['no_of_person']} persons',
                                                    style: GoogleFonts.mulish(
                                                      color: tripOptionsProvider
                                                                  .selectedIndex ==
                                                              index
                                                          ? tBlack
                                                          : tGray,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: isTab(context)
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
                                                    style: GoogleFonts.mulish(
                                                      color: tripOptionsProvider
                                                                  .selectedIndex ==
                                                              index
                                                          ? tBlack
                                                          : tGray,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: isTab(context)
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
                                            padding: EdgeInsets.only(right: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${currencySymbol}${vehicle['total_fare']}',
                                                  style: TextStyle(
                                                    color: tBlack,
                                                    fontSize: isTab(context)
                                                        ? 10.sp
                                                        : 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: () {
                            if (tripOptionsProvider.couponCode != null &&
                                tripOptionsProvider.couponCode.isNotEmpty) {
                              tripOptionsProvider.removeCoupon(context);
                            } else {
                              Twl.forceNavigateTo(
                                  context, CouponsPage(boolcouponpage: true));
                            }
                          },
                          child: Container(
                            // width: 45.w,
                            decoration: BoxDecoration(
                                color: tWhite,
                                boxShadow: [tBackbtnBoxShadow],
                                borderRadius:
                                    BorderRadiusDirectional.circular(10)),
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
                                    tripOptionsProvider.couponCode != null &&
                                            tripOptionsProvider
                                                .couponCode.isNotEmpty
                                        ? tripOptionsProvider.couponCode
                                        : "Apply Coupon Code",
                                    style: GoogleFonts.mulish(
                                      color: tDarkNavyblue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTab(context) ? 8.sp : 12.sp,
                                    ),
                                  ),
                                  Spacer(),
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
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                          // },
                          child: Container(
                            decoration: BoxDecoration(
                                color: tWhite,
                                boxShadow: [tBackbtnBoxShadow],
                                borderRadius:
                                    BorderRadiusDirectional.circular(10)),
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
                        SizedBox(height: 2.h),
                        Center(
                          child: SizedBox(
                            width: isTab(context) ? 50.w : 70.w,
                            height: isTab(context) ? 6.h : 7.h,
                            child: ButtonWidget(
                                borderSide: BorderSide(color: tPrimaryColor),
                                color: tPrimaryColor,
                                borderRadius: isTab(context) ? 40.0 : 30.0,
                                child: Text(
                                  'Book Ride',
                                  style: TextStyle(
                                      color: tWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTab(context) ? 10.sp : 15.sp),
                                ),
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();

                                  startLoading();
                                  if (await RideService().hasOpenRide()) {
                                    stopLoading();
                                    Twl.navigateTo(
                                        context,
                                        NewRideLayout(
                                            child: BottomNavigation(
                                          tabIndexId: 0,
                                        )));
                                    return;
                                  }
                                  var response = await tripOptionsProvider
                                      .getRideRequest(context);
                                  if (response['status'] == 'OK') {
                                    // The backend dispatches the ride to
                                    // nearby drivers; the state is polled.
                                    final rideId =
                                        response['details']['id'].toString();
                                    await RideService.setActiveRide(rideId);
                                    var assign = await UserAPI()
                                        .autoAssignRide(context, rideId);
                                    if (assign is Map &&
                                        assign['status'] != 'OK') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(assign['error']
                                                ?.toString() ??
                                            'No drivers available right now'),
                                      ));
                                    }

                                    // Twl.navigateTo(
                                    //     context, SearchingDriverPage());
                                    Twl.navigateTo(
                                        context,
                                        NewRideLayout(
                                            child: BottomNavigation(
                                          tabIndexId: 0,
                                        )));
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                        content:
                                            Text('failed_to_save_try_again'.tr),
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _AvailableRidesState - the data and logic behind its screen
