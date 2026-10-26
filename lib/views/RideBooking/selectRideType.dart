// =============================================================================
// WHAT : DRIVERS BOOKING step 1: choose One-way or Round trip and In-city or
//        Out-station.
// NOTES: Starts from the home screen's Drivers tile.
// =============================================================================
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/views/RideBooking/selectLocationPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalWidgets/buttonIconWidget.dart';
import '../../globalWidgets/buttonWidget.dart';
import '../../providers/riderProvider.dart';
import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../select_ridePage/components/one_wayPage/one_way_Trip.dart';

// >>> START: SelectRideType - screen/widget shell (the visible part is in its State class)
class SelectRideType extends StatefulWidget {
  const SelectRideType({Key? key}) : super(key: key);

  @override
  State<SelectRideType> createState() => _SelectRideTypeState();
}
// <<< END: SelectRideType - screen/widget shell (the visible part is in its State class)

// >>> START: _SelectRideTypeState - the data and logic behind its screen
class _SelectRideTypeState extends State<SelectRideType>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // The app's memory of the booking in progress: this screen writes the
    // customer's choice (one-way or round trip) into it.
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    // The screen has two tabs: "One way" and "Round trip".
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        // Phone's back button: abandon the booking and return to Home.
        onWillPop: () {
          return Twl.forceNavigateTo(
              context,
              BottomNavigation(
                tabIndexId: 0,
              ));
        },
        child: Scaffold(
          // ---- Header: back arrow + title "Select ride type" ----
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 7,
            backgroundColor: tDarkNavyblue,
            leading: GestureDetector(
                onTap: () {
                  // Back arrow: clear everything chosen so far, go Home.
                  tripOptionsProvider.resetProviderValues();
                  Twl.forceNavigateTo(
                      context,
                      BottomNavigation(
                        tabIndexId: 0,
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                  child: BackIconWidget(),
                )),
            centerTitle: true,
            title: Text('select_ride_type'.tr,
                style: GoogleFonts.mulish(
                    color: tWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: isTab(context) ? 10.sp : 17.sp)),
          ),
          // ---- Body: a map in the background with the choice cards on top ----
          body: Stack(
            children: [
              // Background map centred on Hyderabad (only decoration here).
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
                children: [
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
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
                            // Customer taps a tab: remember the choice.
                            //   left tab  -> one-way trip (driver takes the
                            //                customer one way only)
                            //   right tab -> round trip (driver waits and
                            //                brings the customer back)
                            onTap: (index) {
                              if (index == 0) {
                                tripOptionsProvider
                                    .setRiderType(RIDER_TYPE_ONEWAY);
                              } else {
                                tripOptionsProvider
                                    .setRiderType(RIDER_TYPE_ROUNDTRIP);
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
                              borderRadius: BorderRadius.circular(10),
                              color: tPrimaryColor,
                            ),

                            tabs: [
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0 ,right: 10.0),                                  child: Text(
                                    'one_way'.tr,
                                    style: TextStyle(


                                        // color: tDarkNavyblue,
                                        fontSize: isTab(context) ? 10.sp : 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0 ,right: 10.0),
                                  child: Text(
                                    'round'.tr,
                                    style: TextStyle(
                                        // color: tDarkNavyblue,
                                        fontSize: isTab(context) ? 10.sp : 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  // The card under the tabs: choose In-city or Out-station.
                  // Both tabs show the same card (OneWayTrip).
                  Container(
                    height: MediaQuery.of(context).size.height / 4.5,
                    child: TabBarView(
                      children: [
                        // one-way tab
                        Center(child: OneWayTrip()),

                        // round-trip tab
                        Center(child: OneWayTrip()),
                      ],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: isTab(context) ? 30.w : 50.w,
                      height: isTab(context) ? 6.h : 7.h,
                      child: ButtonWidget(
                        borderSide: BorderSide(color: tPrimaryColor),
                        color: tPrimaryColor,
                        borderRadius: isTab(context) ? 16.0 : 14.0,
                        child: Text('next'.tr,
                            style: GoogleFonts.mulish(
                                color: tWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: isTab(context) ? 9.sp : 14.sp)),
                        // "Next": go to step 2 - choose pickup and drop.
                        onTap: (startLoading, stopLoading, btnState) async {
                          startLoading();

                          Twl.navigateTo(context, SelectLocationPage());

                          setState(() {});

                          stopLoading();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SelectRideTypeState - the data and logic behind its screen
