// =============================================================================
// WHAT : DRIVERS BOOKING: choose Automatic/Manual and the car type, then pick
//        date and time.
// NOTES: Opens the date/time sheet (views/dummy.dart).
// =============================================================================
// import 'package:base_project_flutter/views/homePage/demo.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../globalFuctions/globalFunctions.dart';

import '../../../../../../responsive.dart';
import '../../globalWidgets/buttonIconWidget.dart';
import '../../globalWidgets/buttonWidget.dart';
import '../../globalWidgets/locationcard.dart';
import '../dummy.dart';

import 'components/one_wayPage/components/automatic_page.dart';
import 'components/one_wayPage/one_way_Trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// >>> START: SelectRidePage - screen/widget shell (the visible part is in its State class)
class SelectRidePage extends StatefulWidget {
  const SelectRidePage(
      {Key? key, this.pickupAddress, this.dropAddress, this.status})
      : super(key: key);
  final pickupAddress;
  final dropAddress;
  final status;

  @override
  State<SelectRidePage> createState() => _SelectRidePageState();
}
// <<< END: SelectRidePage - screen/widget shell (the visible part is in its State class)

// >>> START: _SelectRidePageState - the data and logic behind its screen
class _SelectRidePageState extends State<SelectRidePage>
    with SingleTickerProviderStateMixin {
  var rideDetails;
  var status = 0;
  late TabController _tabController;

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    fetchAddress();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  var pickupAddress;
  var pickupLat;
  var pickupLng;
  var pickupPincode;
  var dropAddress;
  var dropLat;
  var dropLng;
  var dropPincode;

  // >>> START: fetchAddress - fetches address
  fetchAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      pickupAddress = sharedPreferences.getString('pickUpAddress');
      pickupLat = sharedPreferences.getDouble('pickUplat');
      pickupLng = sharedPreferences.getDouble('pickUplng');
      pickupPincode = sharedPreferences.getString('pickUpPinCode');
      //drop
      dropAddress = sharedPreferences.getString('dropAddress');
      dropLat = sharedPreferences.getDouble('droplat');
      dropLng = sharedPreferences.getDouble('droplng');
      dropPincode = sharedPreferences.getString('dropPinCode');
    });
  }
  // <<< END: fetchAddress - fetches address

  var tripStatus = 1;
  var statusType = 1;
  var vehicleType = 1;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            titleSpacing: 7,
            backgroundColor: tWhite,
            leading: GestureDetector(
                onTap: () {
                  Twl.navigateBack(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                  child: BackIconWidget(),
                )),
            centerTitle: true,
            title: tripStatus == 0
                ? Text('Select_Ride'.tr,
                    style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontWeight: FontWeight.w800,
                        fontSize: isTab(context) ? 10.sp : 17.sp))
                : tripStatus == RIDER_TYPE_ONEWAY
                    ? Text('One-way'.tr,
                        style: GoogleFonts.mulish(
                            color: tDarkNavyblue,
                            fontWeight: FontWeight.w800,
                            fontSize: isTab(context) ? 10.sp : 17.sp))
                    : Text('Round'.tr,
                        style: GoogleFonts.mulish(
                            color: tDarkNavyblue,
                            fontWeight: FontWeight.w800,
                            fontSize: isTab(context) ? 10.sp : 17.sp))),
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                //method called when map is created
                setState(() {
                  controller = controller;
                });
              },
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(17.448294, 78.391487),
                zoom: 17.0,
              ),
              // markers: Set<Marker>.of(markers.values),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  child: status != 1
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                              color: tWhite,
                              boxShadow: [tBoxShadow],
                              borderRadius: BorderRadius.circular(8)),
                          child: LocationCards(
                              status: statusType,
                              pickupAddress: pickupAddress,
                              dropAddress: dropAddress,
                              tripStatus: tripStatus)),
                ),
                // // construct the profile details widget here
                // SizedBox(height: MediaQuery.of(context).size.height / 3),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: status == 0
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 9.w),
                            height: 60,
                            decoration: BoxDecoration(
                              color: tWhite,
                              boxShadow: [tBoxShadow],
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            child: TabBar(
                              onTap: (index) {
                                if (index == 0) {
                                  setState(() {
                                    tripStatus = RIDER_TYPE_ONEWAY;
                                  });
                                } else {
                                  setState(() {
                                    tripStatus = RIDER_TYPE_ROUNDTRIP;
                                  });
                                }
                              },
                              labelColor: tWhite,
                              unselectedLabelColor: tPrimaryColor,
                              // indicatorWeight: 10,
                              labelPadding: EdgeInsets.all(10),
                              indicatorPadding: EdgeInsets.all(10),
                              // controller: _tabController,
                              // give the indicator a decoration (color and border radius)
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: tPrimaryColor,
                              ),

                              tabs: [
                                GestureDetector(
                                  onTap: () {
                                    // Twl.forceNavigateTo(context, customizetabbar());
                                  },
                                  child: Tab(
                                    child: Text(
                                      "One_Way".tr,
                                      style: TextStyle(
                                          // color: tDarkNavyblue,
                                          fontSize:
                                              isTab(context) ? 10.sp : 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Round".tr,
                                    style: TextStyle(
                                        // color: tDarkNavyblue,
                                        fontSize:
                                            isTab(context) ? 10.sp : 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : status == 1
                            ? Container()
                            : status == 2
                                ? SizedBox(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: AppBar(
                                      backgroundColor: tWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                      bottom: TabBar(
                                        onTap: (index) async {
                                          SharedPreferences sharedPreferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          if (index == 0) {
                                            setState(() {
                                              vehicleType = CAR_TYPE_AUTOMATIC;
                                              sharedPreferences.setInt(
                                                  'VEHICLE_TYPE', vehicleType);
                                            });
                                          } else {
                                            setState(() {
                                              vehicleType = CAR_TYPE_MANUAL;

                                              sharedPreferences.setInt(
                                                  'VEHICLE_TYPE', vehicleType);
                                            });
                                          }
                                        },
                                        labelColor: tWhite,
                                        unselectedLabelColor: tPrimaryColor,
                                        // indicatorWeight: 10,
                                        labelPadding: EdgeInsets.all(5),
                                        indicatorPadding: EdgeInsets.all(4),

                                        // controller: _tabController,
                                        // give the indicator a decoration (color and border radius)
                                        indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: tPrimaryColor,
                                        ),

                                        tabs: [
                                          Tab(
                                            child: Text(
                                              "Automatic".tr,
                                              style: TextStyle(
                                                  // color: tDarkNavyblue,
                                                  fontSize: isTab(context)
                                                      ? 10.sp
                                                      : 12.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Tab(
                                            child: Text(
                                              "Manual".tr,
                                              style: TextStyle(
                                                  // color: tDarkNavyblue,
                                                  fontSize: isTab(context)
                                                      ? 10.sp
                                                      : 12.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: Text('bsf'),
                                  ),
                  ),
                ),

                // create widgets for each tab bar here
                status == 0
                    ? Container(
                        height: MediaQuery.of(context).size.height / 4.5,
                        child: TabBarView(
                          children: [
                            // first tab bar view widget
                            Center(child: OneWayTrip()),

                            // second tab bar viiew widget
                            Center(child: OneWayTrip()),
                          ],
                        ),
                      )
                    : status == 1
                        ? Container()
                        : status == 2
                            ? Container(
                                height: MediaQuery.of(context).size.height / 5,
                                child: TabBarView(
                                  children: [
                                    // first tab bar view widget
                                    Center(
                                        child: AutomaticTabPage(
                                            vehicleType: vehicleType)),

                                    // second tab bar viiew widget
                                    Center(
                                        child: AutomaticTabPage(
                                            vehicleType: vehicleType)),
                                  ],
                                ),
                              )
                            : Container(),

                status == 0
                    ? Center(
                        child: SizedBox(
                          width: isTab(context) ? 30.w : 50.w,
                          height: isTab(context) ? 6.h : 7.h,
                          child: ButtonWidget(
                            borderSide: BorderSide(color: tPrimaryColor),
                            color: tPrimaryColor,
                            borderRadius: isTab(context) ? 16.0 : 14.0,
                            child: Text('Next',
                                style: GoogleFonts.mulish(
                                    color: tWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTab(context) ? 9.sp : 14.sp)),
                            onTap: (startLoading, stopLoading, btnState) async {
                              startLoading();
                              setState(() {
                                status = 1;
                                statusType = 1;
                              });
                            },
                          ),
                        ),
                      )
                    : status == 1
                        ? Center(
                            child: SizedBox(
                              width: isTab(context) ? 30.w : 50.w,
                              height: isTab(context) ? 6.h : 7.h,
                              child: ButtonWidget(
                                borderSide: BorderSide(color: tPrimaryColor),
                                color: tPrimaryColor,
                                borderRadius: isTab(context) ? 16.0 : 14.0,
                                child: Text('Nextt',
                                    style: GoogleFonts.mulish(
                                        color: tWhite,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            isTab(context) ? 9.sp : 14.sp)),
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  startLoading();
                                  Map<String, String> param = {
                                    'pickup_lat': pickupLat.toString(),
                                    'pickup_lng': pickupLng.toString(),
                                    'drop_lat': dropLat.toString(),
                                    'drop_lng': dropLng.toString()
                                  };
                                  var res = await UserAPI()
                                      .checkBoundary(context, param);
                                  if (res != null && res['status'] == 'OK') {
                                    setState(() {
                                      status = 2;
                                    });
                                  } else {
                                    stopLoading();
                                    Twl.createAlert(context, 'Oops',
                                        res['error'].toString());
                                  }

                                },
                              ),
                            ),
                          )
                        : status == 2
                            ? Center(
                                child: SizedBox(
                                  width: isTab(context) ? 30.w : 50.w,
                                  height: isTab(context) ? 6.h : 7.h,
                                  child: ButtonWidget(
                                    borderSide:
                                        BorderSide(color: tPrimaryColor),
                                    color: tPrimaryColor,
                                    borderRadius: isTab(context) ? 16.0 : 14.0,
                                    child: Text('Next',
                                        style: GoogleFonts.mulish(
                                            color: tWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                isTab(context) ? 9.sp : 14.sp)),
                                    onTap: (startLoading, stopLoading,
                                        btnState) async {
                                      startLoading();
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        // expand: false,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: Clock()),
                                      );

                                      setState(() {
                                       Twl.forceNavigateTo(context,  Clock());
                                      });
                                    },
                                  ),
                                ),
                              )
                            : Container(),
                SizedBox(
                  height: 2.h,
                )
              ],
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     titleSpacing: 7,
    //     backgroundColor: tYellow,
    //     leading: GestureDetector(
    //         onTap: () {
    //           Twl.navigateBack(context);
    //         },
    //         child: Padding(
    //           padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
    //           child: BackIconWidget(),
    //         )),
    //     title: Text('Emergency'.tr,
    //         style: GoogleFonts.mulish(
    //             color: tDarkNavyblue,
    //             fontWeight: FontWeight.w800,
    //             fontSize: isTab(context) ? 10.sp : 17.sp)),
    //   ),
    //   body: Container(
    //     child: WillPopScope(
    //       onWillPop: () {
    //         return Twl.navigateBack(context);
    //       },
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Container(
    //                 height: 50,
    //                 width: MediaQuery.of(context).size.width / 1.5,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey[300],
    //                   borderRadius: BorderRadius.circular(
    //                     25.0,
    //                   ),
    //                 ),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     TabBar(
    //                       controller: _tabController,
    //                       // give the indicator a decoration (color and border radius)
    //                       indicator: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(
    //                           25.0,
    //                         ),
    //                         color: Colors.green,
    //                       ),
    //                       labelColor: tBlack,
    //                       unselectedLabelColor: tDarkNavyblue,
    //                       tabs: [
    //                         Tab(
    //                           icon: Icon(Icons.people),
    //                         ),
    //                         Tab(
    //                           icon: Icon(Icons.person),
    //                         )
    //                       ],

    //                       indicatorSize: TabBarIndicatorSize.tab,
    //                     ),
    //                     Expanded(
    //                         child: TabBarView(children: [
    //                       // first tab bar view widget
    //                       Container(
    //                         color: Colors.red,
    //                         child: Center(
    //                           child: Text(
    //                             'Bike',
    //                           ),
    //                         ),
    //                       ),

    //                       // second tab bar viiew widget
    //                       Container(
    //                         color: Colors.pink,
    //                         child: Center(
    //                           child: Text(
    //                             'Car',
    //                           ),
    //                         ),
    //                       ),
    //                     ]))
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SelectRidePageState - the data and logic behind its screen
