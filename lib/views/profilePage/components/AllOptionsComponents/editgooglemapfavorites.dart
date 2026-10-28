// =============================================================================
// WHAT : Map picker used when editing a favourite address.
// NOTES: Visual + server.
// =============================================================================
// // ignore_for_file: unused_local_variable

import 'package:base_project_flutter/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../api_services/userApi.dart';
import '../../../../globalFuctions/globalFunctions.dart';
import '../../../../globalWidgets/buttonWidget.dart';
import '../../../../globalWidgets/googleMapScreen.dart';
import '../../../../responsive.dart';

import 'editFavoritesLocation.dart';

// >>> START: editfavAddressGoogleMapPage - screen/widget shell (the visible part is in its State class)
class editfavAddressGoogleMapPage extends StatefulWidget {
  editfavAddressGoogleMapPage(
      {Key? key,
      this.favLat,
      this.favLng,
      this.favAddress,
      this.favPincode,
      this.favAddressType,
      this.editfavoriteData})
      : super(key: key);
  final favLat;
  final favLng;
  final favAddress;
  final favPincode;
  final favAddressType;
  final editfavoriteData;
  static final kInitialPosition = LatLng(17.3850, 78.4867);

  @override
  _editfavAddressGoogleMapPageState createState() =>
      _editfavAddressGoogleMapPageState();
}
// <<< END: editfavAddressGoogleMapPage - screen/widget shell (the visible part is in its State class)

// >>> START: _editfavAddressGoogleMapPageState - the data and logic behind its screen
class _editfavAddressGoogleMapPageState
    extends State<editfavAddressGoogleMapPage> {
  PickResult? selectedPlace;
  late double lat;
  late double lng;
  late String formattedAddress;
  String? postalCode;
  String? pinCode;
  late String streetName1;
  late String streetName2;
  late String streetName3;
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFavLocation();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  var favLocationDetails;
  var resNOK;
  // >>> START: fetchFavLocation - fetches fav location
  fetchFavLocation() async {
    var response = await UserAPI().favoriteList(
      context,
    );
    if (response != null && response['status'] == 'OK') {
      setState(() {
        favLocationDetails = response['details'];
      });
    } else {
      resNOK = response['status'];
    }
  }
  // <<< END: fetchFavLocation - fetches fav location

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // A full-screen light map: dark status bar icons, so the clock and battery can be read (they were white on the map).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
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
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString(
              "formattedAddress", selectedPlace!.formattedAddress!);
          sharedPreferences.setDouble(
              "lattitude", selectedPlace!.geometry!.location.lat);
          sharedPreferences.setDouble(
              "longitude", selectedPlace!.geometry!.location.lng);
          formattedAddress = sharedPreferences.getString('formattedAddress')!;
          lat = sharedPreferences.getDouble('lattitude')!;
          lng = sharedPreferences.getDouble('longitude')!;
          final coordinates  = await Geocoder2.getDataFromCoordinates(
              latitude: lat,
              longitude: lng,
              googleMapApiKey: mapKey);

          try {
            var address =   await Geocoder2.getDataFromCoordinates(
                latitude: lat,
                longitude: lng,
                googleMapApiKey: mapKey);

            var first = address;
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setDouble('pickUplat', lat);
            sharedPreferences.setDouble('pickUplng', lng);
            sharedPreferences.setString('pickUpAddress', formattedAddress);
            sharedPreferences.setString('FeatureName', first.city);
            var featureName = sharedPreferences.getString('FeatureName');
            sharedPreferences.setString('AddressLine', first.address);
            var addressLine = sharedPreferences.getString('AddressLine');
            sharedPreferences.setString('Locality', first.streetNumber);
            var locality = sharedPreferences.getString('Locality');
            sharedPreferences.setString('pickUpPinCode', first.postalCode);
            var pinCode = sharedPreferences.getString('pickUpPinCode');
            if (address.postalCode != null) {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  context: context,
                  builder: (context) => Container(
                        decoration: BoxDecoration(
                            color: tWhite,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        // height: MediaQuery.of(context).size.height / 2,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              favLocationDetails == null
                                  ? Container()
                                  : ListView.builder(
                                      itemCount: 1,
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var favLocationDetail =
                                            favLocationDetails[index];
                                        return GestureDetector(
                                          onTap: () {
                                            // showModalBottomSheet(
                                            //     isScrollControlled: true,
                                            //     backgroundColor: tWhite,
                                            //     shape: RoundedRectangleBorder(
                                            //         borderRadius:
                                            //             BorderRadius.only(
                                            //                 topLeft: Radius
                                            //                     .circular(30),
                                            //                 topRight:
                                            //                     Radius.circular(
                                            //                         30))),
                                            //         favAddress:
                                            //             sharedPreferences
                                            //                 .getString(
                                            //                     'pickUpAddress')
                                            //                 .toString(),
                                            //         favPincode:
                                            //             pinCode.toString(),
                                            //         favLat: lat.toString(),
                                            //         favLng: lng.toString(),
                                            //       );
                                            //     });
                                          },
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4.w,
                                                  vertical: 0.6.h),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w,
                                                  vertical: isTab(context)
                                                      ? 2.h
                                                      : 3.h),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: tReferColor,
                                                  boxShadow: [
                                                    tBackbtnBoxShadow
                                                  ]),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: tWhite),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  isTab(context)
                                                                      ? 10
                                                                      : 8.0),
                                                          child: Icon(
                                                            Icons.location_on,
                                                            color:
                                                                tDarkNavyblue,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                // Text(
                                                                //   // 'Other'.tr,
                                                                //   favLocationDetail[
                                                                //       'address_type'],
                                                                //   style: GoogleFonts.mulish(
                                                                //       color:
                                                                //           tSecondaryColor,
                                                                //       fontWeight:
                                                                //           FontWeight
                                                                //               .w700,
                                                                //       fontSize: isTab(
                                                                //               context)
                                                                //           ? 10.sp
                                                                //           : 12.sp),
                                                                // ),
                                                              ],
                                                            ),
                                                            Text(
                                                              formattedAddress,
                                                              // favLocationDetail[
                                                              //     'address'],
                                                              // '102 Spline Arcade, Aayyappa Soci..',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.mulish(
                                                                  color:
                                                                      tSecondaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: isTab(
                                                                          context)
                                                                      ? 8.sp
                                                                      : 11.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.mulish(
                                                                color:
                                                                    tSecondaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: isTab(
                                                                        context)
                                                                    ? 8.sp
                                                                    : 10.sp),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        );
                                      }),
                              SizedBox(
                                height: 2.h,
                              ),
                              Center(
                                child: SizedBox(
                                  width: isTab(context) ? 30.w : 50.w,
                                  height: isTab(context) ? 6.h : 7.h,
                                  child: ButtonWidget(
                                    borderSide:
                                        BorderSide(color: tPrimaryColor),
                                    color: tPrimaryColor,
                                    borderRadius: isTab(context) ? 10.0 : 8.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('save_as_favorite'.tr,
                                          style: GoogleFonts.mulish(
                                              color: tWhite,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isTab(context)
                                                  ? 9.sp
                                                  : 14.sp)),
                                    ),
                                    onTap: (startLoading, stopLoading,
                                        btnState) async {
                                      Twl.forceNavigateTo(
                                          context,
                                          EditFavouritesLocation(
                                            editfavoriteData: formattedAddress,
                                            editmapdata: favLocationDetails[0],
                                          ));
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          ),
                        ),
                      ));
            } else {
              //
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('check_location'.tr),
                    content: Text('We_unable_to_get_your_Pincode'.tr),
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
        },
        region: 'in',
      )),
    ));
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _editfavAddressGoogleMapPageState - the data and logic behind its screen
