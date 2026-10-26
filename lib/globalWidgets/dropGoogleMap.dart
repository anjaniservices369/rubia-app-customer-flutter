// =============================================================================
// WHAT : Map screen where the customer picks the DROP-OFF point; it checks the
//        point is inside the service area (check-boundary).
// NOTES: Result is stored in TripOptionsProvider.
// =============================================================================
// // ignore_for_file: unused_local_variable

import 'package:base_project_flutter/api_services/userApi.dart';

import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/googleMapScreen.dart';

import 'package:base_project_flutter/taxiservices/searchlocation/searchlocation.dart';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../providers/riderProvider.dart';
import '../views/RideBooking/selectLocationPage.dart';

// >>> START: DropGoogleMap - screen/widget shell (the visible part is in its State class)
class DropGoogleMap extends StatefulWidget {
  DropGoogleMap({Key? key, this.status}) : super(key: key);
  final status;

  static final kInitialPosition = LatLng(17.3850, 78.4867);

  @override
  _DropGoogleMapState createState() => _DropGoogleMapState();
}
// <<< END: DropGoogleMap - screen/widget shell (the visible part is in its State class)

// >>> START: _DropGoogleMapState - the data and logic behind its screen
class _DropGoogleMapState extends State<DropGoogleMap> {
  PickResult? selectedPlace;
  late double lat;
  late double lng;
  late String formattedAddress;
  String? postalCode;
  String? pinCode;
  late String streetName1;
  late String streetName2;
  late String streetName3;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return Scaffold(
      body: Center(
          child: PlacePicker(
        apiKey: mapKey,
        hintText: 'find_a_place'.tr,
        searchingText: 'please wait'.tr,
        selectText: 'select_location'.tr,
        outsideOfPickAreaText: 'place_not_in_area'.tr,
        initialPosition: GoogleMapPage.kInitialPosition,
        useCurrentLocation: true,
        selectInitialPosition: true,
        usePinPointingSearch: true,
        usePlaceDetailSearch: true,
        onPlacePicked: (result) async {
          selectedPlace = result;

          // The place-picker plugin occasionally returns a reverse-geocoded
          // result for a different, far-away point than the one the pin is
          // actually on (a stale async response winning a race - seen once
          // as a Hanoi, Vietnam address for a pin sitting in Hyderabad).
          // Coordinates stay far more trustworthy than the address string in
          // that case, so refuse anything outside the country this service
          // operates in instead of silently sending bogus coordinates on.
          if (!isWithinIndia(selectedPlace!.geometry!.location.lat,
              selectedPlace!.geometry!.location.lng)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                  'we_are_unable_to_find_your_pin_code_please_drag_the_place_picker'
                      .tr),
            ));
            return;
          }

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          sharedPreferences.setString(
              "dropformattedAddress", selectedPlace!.formattedAddress!);
          sharedPreferences.setDouble(
              "droplat", selectedPlace!.geometry!.location.lat);
          sharedPreferences.setDouble(
              "droplng", selectedPlace!.geometry!.location.lng);
          formattedAddress =
              sharedPreferences.getString('dropformattedAddress')!;
          lat = sharedPreferences.getDouble('droplat')!;
          lng = sharedPreferences.getDouble('droplng')!;

          Map<String, String> param = {
            'lat': lat.toString(),
            'lng': lng.toString(),
          };
          if (tripOptionsProvider.tripType != TRIP_TYPE_OUTSTATION &&
              tripOptionsProvider.serviceType == 'DRIVER') {
            try {
              var res = await UserAPI().checkBoundary(context, param);
              if (res['status'] == "OK") {
                if (tripOptionsProvider.tripType == TRIP_TYPE_INTERCITY) {
                  if (tripOptionsProvider.selectedCityId ==
                          res['selected_city_id'] &&
                      tripOptionsProvider.selectedCityId != 0) {
                    tripOptionsProvider.setDropLocation(
                      selectedPlace!.geometry!.location.lat.toString(),
                      selectedPlace!.geometry!.location.lng.toString(),
                      selectedPlace!.formattedAddress!,
                    );

                    tripOptionsProvider.setCityId(res['selected_city_id']);
                    tripOptionsProvider.setDropCityId(res['selected_city_id']);
                    tripOptionsProvider.serviceType == 'DRIVER'
                        ? Twl.forceNavigateTo(context, SelectLocationPage())
                        : Twl.forceNavigateTo(context, SearchLocation());
                  } else {
                    Twl.createAlert(context, "Sorry",
                        "Pickup and Drop location should be same city");
                  }
                } else {}
              } else {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('check_location'.tr),
                      content: Text(res['error'].toString()),
                      actions: <Widget>[
                        TextButton(
                          child: Text('ok'),
                          onPressed: () {
                            Twl.navigateBack(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            } catch (e) {
              throw ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                    'we_are_unable_to_find_your_pin_code_please_drag_the_place_picker'
                        .tr),
              ));
            }
          } else {
            var res = await UserAPI().checkBoundary(context, param);
            if (res['status'] == "OK") {
              if (tripOptionsProvider.tripType == TRIP_TYPE_OUTSTATION &&
                  tripOptionsProvider.selectedCityId ==
                      res['selected_city_id']) {
                Twl.createAlert(context, "Sorry",
                    "Pickup and Drop location should be in different cities for Outstation trips");
              } else {
                tripOptionsProvider.setDropLocation(
                  selectedPlace!.geometry!.location.lat.toString(),
                  selectedPlace!.geometry!.location.lng.toString(),
                  selectedPlace!.formattedAddress!,
                );

                tripOptionsProvider.serviceType == 'DRIVER'
                    ? Twl.forceNavigateTo(context, SelectLocationPage())
                    : Twl.forceNavigateTo(context, SearchLocation());
              }
            } else {
              tripOptionsProvider.setDropLocation(
                selectedPlace!.geometry!.location.lat.toString(),
                selectedPlace!.geometry!.location.lng.toString(),
                selectedPlace!.formattedAddress!,
              );

              tripOptionsProvider.serviceType == 'DRIVER'
                  ? Twl.forceNavigateTo(context, SelectLocationPage())
                  : Twl.forceNavigateTo(context, SearchLocation());
            }
          }
        },
        region: 'in',
      )),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _DropGoogleMapState - the data and logic behind its screen
