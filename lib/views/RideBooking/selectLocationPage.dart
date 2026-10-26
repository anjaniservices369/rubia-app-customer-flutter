// =============================================================================
// WHAT : DRIVERS BOOKING step 2: pickup and drop addresses with a map; checks
//        the service area.
// NOTES: Server: check-boundary, vehicle-types.
// =============================================================================
import 'package:base_project_flutter/views/RideBooking/selectRideType.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/buttonIconWidget.dart';
import '../../globalWidgets/buttonWidget.dart';
import '../../globalWidgets/locationcard.dart';
import '../../providers/riderProvider.dart';
import '../../responsive.dart';
import '../dummy.dart';
import '../select_ridePage/components/one_wayPage/components/automatic_page.dart';

// >>> START: SelectLocationPage - screen/widget shell (the visible part is in its State class)
/// Step 2 of the Drivers booking: the customer sees the pickup address (taken
/// from the phone's location), picks the drop address, chooses Automatic or
/// Manual gears and a car type, then continues to the date/time sheet.
class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({Key? key}) : super(key: key);

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}
// <<< END: SelectLocationPage - screen/widget shell (the visible part is in its State class)

// >>> START: _SelectLocationPageState - the data and logic behind its screen
class _SelectLocationPageState extends State<SelectLocationPage> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // The app's memory of the booking in progress (read and written here).
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    // 1. No pickup yet: find the phone's current position and address.
    if (tripOptionsProvider.pickupAddress == null ||
        tripOptionsProvider.pickupAddress.isEmpty) {
      tripOptionsProvider.getCurrentLocation(context);
    }

    // 2. The car-type tabs and the Next button only appear when the trip is
    //    complete enough to price:
    //      one-way    -> pickup AND drop are both filled
    //      round trip -> pickup is enough (the driver returns to it)
    final bool pickupFilled = tripOptionsProvider.pickupAddress != null &&
        tripOptionsProvider.pickupAddress.isNotEmpty;
    final bool dropFilled = tripOptionsProvider.dropAddress != null &&
        tripOptionsProvider.dropAddress.isNotEmpty;
    final bool readyToContinue =
        (tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY &&
                pickupFilled &&
                dropFilled) ||
            (tripOptionsProvider.riderType == RIDER_TYPE_ROUNDTRIP &&
                pickupFilled);

    // Two tabs: Automatic / Manual (the gear type of the customer's car).
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // ---- Header: back arrow + "One way" / "Round trip" ----
        appBar: AppBar(
            elevation: 0,
            titleSpacing: 7,
            backgroundColor: tWhite,
            leading: GestureDetector(
                onTap: () {
                  // Back arrow: clear the booking and return to step 1.
                  tripOptionsProvider.resetProviderValues();
                  Twl.forceNavigateTo(context, SelectRideType());
                },
                child: Padding(
                  padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                  child: BackIconWidget(),
                )),
            centerTitle: true,
            // The title follows the choice made in step 1.
            title: tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY
                ? Text('one_way'.tr,
                    style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontWeight: FontWeight.w800,
                        fontSize: isTab(context) ? 10.sp : 17.sp))
                : Text('round'.tr,
                    style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontWeight: FontWeight.w800,
                        fontSize: isTab(context) ? 10.sp : 17.sp))),
        // ---- Body: map in the background, cards stacked at the bottom ----
        body: Stack(
          children: [
            // Background map centred on Hyderabad.
            GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                // -------------------------------------------------------
                // CARD 1 - Pickup and drop addresses. Tapping a row opens a
                // map picker (see LocationCards / pickupgoogleMap.dart /
                // dropGoogleMap.dart).
                // -------------------------------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  child: Container(
                      decoration: BoxDecoration(
                          color: tWhite,
                          boxShadow: [tBoxShadow],
                          borderRadius: BorderRadius.circular(8)),
                      child: LocationCards(
                          pickupAddress: '${tripOptionsProvider.pickupAddress}',
                          dropAddress: '${tripOptionsProvider.dropAddress}',
                          tripStatus: '${tripOptionsProvider.tripType}')),
                ),
                // -------------------------------------------------------
                // CARD 2 - "Automatic | Manual" tab bar. Choosing a tab
                // stores the gear type of the customer's car.
                // -------------------------------------------------------
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: readyToContinue
                        ? SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.25,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: AppBar(
                                backgroundColor: tWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                bottom: TabBar(
                                  onTap: (index) async {
                                    // left tab = Automatic, right = Manual
                                    if (index == 0) {
                                      tripOptionsProvider
                                          .setCarType(CAR_TYPE_AUTOMATIC);
                                    } else {
                                      tripOptionsProvider
                                          .setCarType(CAR_TYPE_MANUAL);
                                    }
                                    setState(() {});
                                  },
                                  labelColor: tWhite,
                                  unselectedLabelColor: tPrimaryColor,
                                  labelPadding: EdgeInsets.all(5),
                                  indicatorPadding: EdgeInsets.all(4),
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: tPrimaryColor,
                                  ),
                                  tabs: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Tab(
                                        child: Text(
                                          'automatic'.tr,
                                          style: TextStyle(
                                            fontSize:
                                                isTab(context) ? 10.sp : 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Tab(
                                        child: Text(
                                          'manual'.tr,
                                          style: TextStyle(
                                            fontSize:
                                                isTab(context) ? 10.sp : 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ),
                // -------------------------------------------------------
                // CARD 3 - The car types (SUV+, SUV, Sedan, Hatchback) for
                // the chosen gear type, loaded from the server.
                // -------------------------------------------------------
                readyToContinue
                    ? Container(
                        height: MediaQuery.of(context).size.height / 5,
                        child: TabBarView(
                          children: [
                            // Automatic cars
                            Center(child: AutomaticTabPage(vehicleType: 1)),

                            // Manual cars
                            Center(child: AutomaticTabPage(vehicleType: 2)),
                          ],
                        ),
                      )
                    : Container(),
                // -------------------------------------------------------
                // "Next" button - opens the date and time sheet (Clock),
                // which leads to the fare estimate and the confirmation.
                // -------------------------------------------------------
                readyToContinue
                    ? Center(
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
                            onTap: (startLoading, stopLoading, btnState) async {
                              startLoading();
                              // Open the "select date and time" sheet.
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    child: Clock()),
                              );

                              setState(() {});
                              stopLoading();
                            },
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SelectLocationPageState - the data and logic behind its screen
