// =============================================================================
// WHAT : TAXI: screen to search and choose pickup and drop for a taxi.
// NOTES: Taxi service.
// =============================================================================
import 'dart:async';
import 'dart:math';
import 'package:base_project_flutter/taxiservices/availableRides.dart';
import 'package:base_project_flutter/taxiservices/rideDetails.dart';
import 'package:base_project_flutter/taxiservices/searchingDriver.dart';

import 'package:base_project_flutter/taxiservices/searchlocation/chooselocation.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/buttonIconWidget.dart';
import '../../providers/riderProvider.dart';
import '../../responsive.dart';

// >>> START: SearchLocation - screen/widget shell (the visible part is in its State class)
class SearchLocation extends StatefulWidget {
  const SearchLocation({Key? key, this.rideData}) : super(key: key);
  final rideData;

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}
// <<< END: SearchLocation - screen/widget shell (the visible part is in its State class)

// >>> START: _SearchLocationState - the data and logic behind its screen
class _SearchLocationState extends State<SearchLocation> {
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override

  void initState() {
    super.initState();

    // Access your provider instance
    final tripOptionsProvider =
        Provider.of<TripOptionsProvider>(context, listen: false);

    // // Call your provider method to fetch data
    // tripOptionsProvider.getVehicles(context);
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    if (tripOptionsProvider.pickupAddress == null ||
        tripOptionsProvider.pickupAddress.isEmpty) {
      tripOptionsProvider.getCurrentLocation(context);
    }
    final polylineCoordinates = tripOptionsProvider.polylineCoordinates;
    PanelController panelController = PanelController();
    final controller = Completer<GoogleMapController>();
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () {
          tripOptionsProvider.resetValues();
          return Twl.forceNavigateTo(
              context,
              BottomNavigation(
                tabIndexId: 0,
              ));
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 7,
            backgroundColor: tWhite,
            leading: GestureDetector(
              onTap: () {
                tripOptionsProvider.resetValues();
                Twl.navigateTo(
                    context,
                    BottomNavigation(
                      tabIndexId: 0,
                    ));
              },
              child: Padding(
                padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                child: BackIconWidget(),
              ),
            ),
            centerTitle: true,
            title: Builder(
              builder: (context) {
                final tripOptionsProvider =
                    Provider.of<TripOptionsProvider>(context);
                String appBarName = '';

                switch (tripOptionsProvider.serviceType) {
                  case 'DRIVER':
                    appBarName = 'Driver Service';
                    break;
                  case 'TAXI':
                    appBarName = 'Taxi Service';
                    break;
                  case 'AUTO':
                    appBarName = 'Auto Service';
                    break;
                  case 'BIKE':
                    appBarName = 'Bike Service';
                    break;
                  case 'OTHERS':
                    appBarName = 'Other Services';
                    break;
                }

                return Text(
                  appBarName,
                  style: GoogleFonts.mulish(
                    color: tDarkNavyblue,
                    fontWeight: FontWeight.w800,
                    fontSize: isTab(context) ? 10.sp : 17.sp,
                  ),
                );
              },
            ),
          ),
          body: Stack(
            children: [
              Consumer<TripOptionsProvider>(
                builder: (context, tripOptionsProvider, _) {
                  if (tripOptionsProvider.pickupLatitude.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
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
                  Set<Marker> markers = {};
                  if (widget.rideData == null) {
                    // If there's no rideData, display the pickup marker only
                    markers.add(
                      Marker(
                        markerId: MarkerId('pickupMarker'),
                        position: LatLng(
                          double.parse(tripOptionsProvider.pickupLatitude),
                          double.parse(tripOptionsProvider.pickupLongitude),
                        ),
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                    );
                  } else {
                    // If there's rideData, display relevant markers based on ride status
                    if (widget.rideData['status'] ==
                        TAXI_STATUS_NEW_REQUEST) {
                      // If the ride status is NEW_REQUEST, show the pickup marker only

                      markers.add(
                        Marker(
                          markerId: MarkerId('pickupMarker'),
                          position: LatLng(
                            double.parse(tripOptionsProvider.pickupLatitude),
                            double.parse(tripOptionsProvider.pickupLongitude),
                          ),
                          icon: BitmapDescriptor.defaultMarker,
                        ),
                      );
                    } else if (widget.rideData['status'] ==
                        TAXI_STATUS_NEW_REQUEST) {
                      // Add other markers as needed for different ride statuses (if applicable)
                      // For example, you might want to show markers for the drop-off location, driver location, etc.
                      // markers.add(...);
                    }
                  }
                  return GoogleMap(
                    initialCameraPosition: initialCameraPosition,
                    markers: markers,
                    polylines: {
                      if (widget.rideData == null)
                        Polyline(
                          polylineId: PolylineId('route'),
                          points: tripOptionsProvider.polylineCoordinates,
                          color: Colors.orange,
                          width: 5,
                        ),
                    },
                  );
                },
              ),
              widget.rideData == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        // if (TAXI_STATUS_RIDE_BOOKED == 2)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: tWhite,
                                  boxShadow: [tBoxShadow],
                                  borderRadius: BorderRadius.circular(8)),
                              child: ChooseLocation(
                                pickupAddress:
                                    '${tripOptionsProvider.pickupAddress}',
                                dropAddress:
                                    '${tripOptionsProvider.dropAddress}',
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if ((tripOptionsProvider.pickupAddress != null &&
                            tripOptionsProvider.dropAddress != null &&
                            tripOptionsProvider.pickupAddress.isNotEmpty &&
                            tripOptionsProvider.dropAddress.isNotEmpty))
                          Expanded(
                            child: SlidingUpPanel(
                                controller: panelController,
                                minHeight: 45.h, // Minimum height of the panel
                                maxHeight: 45.h, // Maximum height of the panel
                                isDraggable: false,
                                panelBuilder: () => AvailableRides()),
                          )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w, vertical: 1.h),
                          decoration: BoxDecoration(
                              color: tWhite,
                              boxShadow: [tBoxShadow],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: widget.rideData['status'] ==
                                  TAXI_STATUS_NEW_REQUEST
                              ? SearchingDriverPage()
                              : Riderdetails(rideData: widget.rideData),
                        ),
                        //accepted ride  page
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
// <<< END: _SearchLocationState - the data and logic behind its screen
