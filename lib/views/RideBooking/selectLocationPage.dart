// =============================================================================
// WHAT : DRIVERS BOOKING step 1 (the single booking screen): trip type, pickup
//        and drop with a map, gear and car type, pickup date and time; then
//        asks the server for the fare and opens the estimate page.
// NOTES: Server: check-boundary, vehicle-types, get-estimate. Replaces the old
//        "Select ride type" screen and the separate date/time step.
// =============================================================================
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/Bookings/bookingPageView.dart';
import 'package:base_project_flutter/views/homePage/components/OneWay.dart';
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
/// The single booking screen of the Drivers service. The customer chooses
/// One-way / Round trip and In-city / Out-station, sees the pickup address
/// (taken from the phone's location), picks the drop address, chooses Automatic
/// or Manual gears and a car type, and checks the pickup date and time (the
/// next free slot is pre-filled). "Next" asks the server for the fare and opens
/// the estimate page, where the ride is confirmed.
class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({Key? key}) : super(key: key);

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}
// <<< END: SelectLocationPage - screen/widget shell (the visible part is in its State class)

// >>> START: _SelectLocationPageState - the data and logic behind its screen
class _SelectLocationPageState extends State<SelectLocationPage> {
  // >>> START: initState - pre-fills the pickup date and time
  @override
  void initState() {
    super.initState();
    // After the first frame, so the provider is not changed while building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      applyDefaultPickupSlot(
          Provider.of<TripOptionsProvider>(context, listen: false));
    });
  }
  // <<< END: initState - pre-fills the pickup date and time

  // >>> START: _goHome - abandons the booking and returns to Home
  Future<bool> _goHome() async {
    Provider.of<TripOptionsProvider>(context, listen: false)
        .resetProviderValues();
    Twl.forceNavigateTo(context, BottomNavigation(tabIndexId: 0));
    // false: the navigation above already replaced this screen.
    return false;
  }
  // <<< END: _goHome - abandons the booking and returns to Home

  // >>> START: _choiceRow - a row of two choices (the selected one is filled)
  Widget _choiceRow(List<String> labels, int selected, void Function(int) onSelect) {
    return Row(
      children: List.generate(labels.length, (i) {
        final on = i == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.symmetric(vertical: 1.1.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? tPrimaryColor : tWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(labels[i],
                  style: TextStyle(
                      color: on ? tWhite : tPrimaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: isTab(context) ? 10.sp : 12.sp)),
            ),
          ),
        );
      }),
    );
  }
  // <<< END: _choiceRow - a row of two choices (the selected one is filled)

  // >>> START: _editTime - opens the date/time sheet and refreshes the screen
  Future<void> _editTime() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: Clock()),
    );
    if (mounted) setState(() {});
  }
  // <<< END: _editTime - opens the date/time sheet and refreshes the screen

  // >>> START: _next - checks the choices, gets the fare and opens the estimate page
  Future<void> _next(TripOptionsProvider provider, bool placesChosen) async {
    if (!placesChosen) {
      // One-way needs pickup and drop; round trip needs the pickup.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(provider.pickupAddress.isEmpty
              ? 'pick_up_location'.tr
              : 'drop_location'.tr)));
      return;
    }
    if (provider.carModel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No vehicles found. Please try again.')));
      return;
    }
    // The pre-filled slot may have passed while the customer was choosing.
    final when = pickupDateTimeOf(provider);
    if (when == null || !when.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_select_future_time'.tr)));
      applyDefaultPickupSlot(provider);
      await _editTime();
      return;
    }
    // Only the confirm button on the estimate page may save a booking.
    provider.setSaveBooking(false);
    final res = await provider.getEstimate(context);
    if (!mounted) return;
    if (res != null && res['status'] == 'OK') {
      Twl.navigateTo(context, OneWay());
    }
  }
  // <<< END: _next - checks the choices, gets the fare and opens the estimate page

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

    // 2. Next only goes on when the trip is complete enough to price:
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
    // The phone's back button abandons the booking and returns Home.
    return WillPopScope(
      onWillPop: _goHome,
      child: DefaultTabController(
      length: 2,
      // Opens on the gear type already chosen (the screen is rebuilt after
      // the map pickers).
      initialIndex:
          tripOptionsProvider.carType == CAR_TYPE_MANUAL ? 1 : 0,
      child: Scaffold(
        // ---- Header: back arrow + "Book a driver" ----
        appBar: AppBar(
            elevation: 0,
            titleSpacing: 7,
            backgroundColor: tWhite,
            leading: GestureDetector(
                onTap: () {
                  // Back arrow: clear the booking and return Home.
                  _goHome();
                },
                child: Padding(
                  padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                  child: BackIconWidget(),
                )),
            centerTitle: true,
            title: Text('Book a driver',
                style: GoogleFonts.mulish(
                    color: tDarkNavyblue,
                    fontWeight: FontWeight.w800,
                    fontSize: isTab(context) ? 10.sp : 17.sp)),
            // My Bookings lives here, inside the driver booking (it is no
            // longer a tab of the bottom bar).
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => BookingPageView())),
                icon: Icon(Icons.receipt_long, color: tPrimaryColor, size: 20),
                label: Text('bookings'.tr,
                    style: TextStyle(
                        color: tPrimaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: isTab(context) ? 9.sp : 12.sp)),
              ),
            ]),
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
                // CARD 0 - Trip type: One way | Round trip, and
                // In-city | Out-station.
                // -------------------------------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  child: Container(
                    decoration: BoxDecoration(
                        color: tWhite,
                        boxShadow: [tBoxShadow],
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        _choiceRow(
                          ['one_way'.tr, 'round'.tr],
                          tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY
                              ? 0
                              : 1,
                          (i) => tripOptionsProvider.setRiderType(
                              i == 0 ? RIDER_TYPE_ONEWAY : RIDER_TYPE_ROUNDTRIP),
                        ),
                        _choiceRow(
                          ['in_city'.tr, 'out_station'.tr],
                          tripOptionsProvider.tripType == TRIP_TYPE_INTERCITY
                              ? 0
                              : 1,
                          (i) {
                            final type =
                                i == 0 ? TRIP_TYPE_INTERCITY : TRIP_TYPE_OUTSTATION;
                            if (type == tripOptionsProvider.tripType) return;
                            tripOptionsProvider.setTripType(type);
                            // A drop chosen for the other trip type may be
                            // outside the allowed area: choose it again.
                            tripOptionsProvider.setDropLocation("", "", "");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                // -------------------------------------------------------
                // CARD 0b - "Automatic | Manual" tab bar (the gear type of
                // the customer's car) and, below it, the car types (SUV+,
                // SUV, Sedan, Hatchback) for the chosen gear type, loaded
                // from the server. Chosen first, before the places.
                // -------------------------------------------------------
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 1.25,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: AppBar(
                      backgroundColor: tWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      bottom: TabBar(
                        onTap: (index) async {
                          // left tab = Automatic, right = Manual
                          if (index == 0) {
                            tripOptionsProvider.setCarType(CAR_TYPE_AUTOMATIC);
                          } else {
                            tripOptionsProvider.setCarType(CAR_TYPE_MANUAL);
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
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Tab(
                              child: Text(
                                'automatic'.tr,
                                style: TextStyle(
                                  fontSize: isTab(context) ? 10.sp : 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Tab(
                              child: Text(
                                'manual'.tr,
                                style: TextStyle(
                                  fontSize: isTab(context) ? 10.sp : 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: TabBarView(
                    // Only the tab bar above changes the gear type.
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // Automatic cars
                      Center(child: AutomaticTabPage(vehicleType: 1)),

                      // Manual cars
                      Center(child: AutomaticTabPage(vehicleType: 2)),
                    ],
                  ),
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
                SizedBox(
                  height: 1.h,
                ),
                // -------------------------------------------------------
                // CARD 1b - When: the pickup date and time (the next free
                // slot is pre-filled). Tap to change it.
                // -------------------------------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  child: GestureDetector(
                    onTap: _editTime,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.5.w, vertical: 1.6.h),
                      decoration: BoxDecoration(
                          color: tWhite,
                          boxShadow: [tBoxShadow],
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: tPrimaryColor),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              pickupDateTimeOf(tripOptionsProvider) == null
                                  ? 'select_time'.tr
                                  : Twl.dateActual(
                                          tripOptionsProvider.pickupDate) +
                                      ', ' +
                                      tripOptionsProvider.pickupTime,
                              style: GoogleFonts.mulish(
                                  color: tDarkNavyblue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: isTab(context) ? 10.sp : 13.sp),
                            ),
                          ),
                          Icon(Icons.edit, size: 18, color: tPrimaryColor),
                        ],
                      ),
                    ),
                  ),
                ),
                // Pushes the Next button to the bottom of the screen.
                Expanded(child: SizedBox()),
                // -------------------------------------------------------
                // "Next" button - checks the choices, gets the fare from the
                // server and opens the estimate page, where the ride is
                // confirmed.
                // -------------------------------------------------------
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
                      onTap: (startLoading, stopLoading, btnState) async {
                        startLoading();
                        await _next(tripOptionsProvider, readyToContinue);
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
// <<< END: _SelectLocationPageState - the data and logic behind its screen
