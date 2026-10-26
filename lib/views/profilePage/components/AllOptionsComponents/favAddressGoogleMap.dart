// =============================================================================
// WHAT : Map picker + title sheet to create a favourite address.
// NOTES: Server: create-favourite-location.
// =============================================================================
// // ignore_for_file: unused_local_variable

import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/views/profilePage/Components/AllOptionsComponents/FavoritesLocation.dart';

import 'package:flutter/material.dart';
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
import '../../../../globalWidgets/textformfieldWidget.dart';
import '../../../../responsive.dart';

import 'FavoritesLocation.dart';

// >>> START: favAddressGoogleMapPage - screen/widget shell (the visible part is in its State class)
class favAddressGoogleMapPage extends StatefulWidget {
  favAddressGoogleMapPage(
      {Key? key,
      this.favLat,
      this.favLng,
      this.favAddress,
      this.favPincode,
      this.favAddressType})
      : super(key: key);
  final favLat;
  final favLng;
  final favAddress;
  final favPincode;
  final favAddressType;
  static final kInitialPosition = LatLng(17.3850, 78.4867);

  @override
  _favAddressGoogleMapPageState createState() =>
      _favAddressGoogleMapPageState();
}
// <<< END: favAddressGoogleMapPage - screen/widget shell (the visible part is in its State class)

// >>> START: _favAddressGoogleMapPageState - the data and logic behind its screen
class _favAddressGoogleMapPageState extends State<favAddressGoogleMapPage> {
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
    return Scaffold(
      body: Center(
          child: PlacePicker(
        apiKey: mapKey,
        hintText: "Find a place ...",
        searchingText: "Please wait ...",
        selectText: "Save as favorites",
        outsideOfPickAreaText: "Place not in area",
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
          GeoData data = await Geocoder2.getDataFromCoordinates(
              latitude: lat,
              longitude: lng,
              googleMapApiKey: mapKey);

          try {
            var address =  await Geocoder2.getDataFromCoordinates(
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
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor: tWhite,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(30),
                                                            topRight:
                                                                Radius.circular(
                                                                    30))),
                                                context: context,
                                                builder: (_) {
                                                  return SelectAddresstitleBottomSheet(
                                                    favAddress:
                                                        sharedPreferences
                                                            .getString(
                                                                'pickUpAddress')
                                                            .toString(),
                                                    favPincode:
                                                        pinCode.toString(),
                                                    favLat: lat.toString(),
                                                    favLng: lng.toString(),
                                                  );
                                                });
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
                                      child: Text('Save as Favorites',
                                          style: GoogleFonts.mulish(
                                              color: tWhite,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isTab(context)
                                                  ? 9.sp
                                                  : 14.sp)),
                                    ),
                                    onTap: (startLoading, stopLoading,
                                        btnState) async {
                                      //   // Either the permission was already granted before or the user just granted it.

                                      //   //We can now access our contacts here
                                      //   //Contact? contact = await _contactPicker.selectContact();
                                      //   // final PhoneContact contact =
                                      //       'contact_number':
                                      //           number!.replaceAll("[", "").replaceAll("]", ""),
                                      //       'contact_name': name!,
                                      //         .addEmergencyContacts(context, param);
                                      //           context, 'Oops', res['error'].toString());
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          // expand: false,
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder:
                                              (context) =>
                                                  SingleChildScrollView(
                                                    child: Container(
                                                      padding:
                                                          MediaQuery.of(context)
                                                              .viewInsets,
                                                      decoration: BoxDecoration(
                                                          color: tWhite,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    30),
                                                            topRight:
                                                                Radius.circular(
                                                                    30),
                                                          ),
                                                          boxShadow: [
                                                            tBoxShadow
                                                          ]),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20,
                                                                    left: 15),
                                                            child: Text(
                                                              'Select_Title'.tr,
                                                              style: GoogleFonts.mulish(
                                                                  color:
                                                                      tDarkNavyblue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: isTab(
                                                                          context)
                                                                      ? 10.sp
                                                                      : 14.sp),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                          GestureDetector(
                                                            // onTap: () {
                                                            // showModalBottomSheet(
                                                            //     isScrollControlled:
                                                            //         true,
                                                            //     backgroundColor:
                                                            //         tWhite,
                                                            //     shape: RoundedRectangleBorder(
                                                            //         borderRadius: BorderRadius.only(
                                                            //             topLeft: Radius.circular(
                                                            //                 30),
                                                            //             topRight: Radius.circular(
                                                            //                 30))),
                                                            //     context:
                                                            //         context,
                                                            //     builder: (_) {
                                                            //       return SelectAddresstitleBottomSheet(
                                                            //         favAddress: sharedPreferences
                                                            //             .getString(
                                                            //                 'pickUpAddress')
                                                            //             .toString(),
                                                            //         favPincode:
                                                            //             pinCode
                                                            //                 .toString(),
                                                            //         favLat: lat
                                                            //             .toString(),
                                                            //         favLng: lng
                                                            //             .toString(),
                                                            //       );
                                                            // });
                                                            // },
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        3,
                                                                    physics:
                                                                        ScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis
                                                                            .vertical,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          Map<String, String>
                                                                              param =
                                                                              {
                                                                            'latitude':
                                                                                lat.toString(),
                                                                            'longitude':
                                                                                lng.toString(),
                                                                            'address_type': index == 0
                                                                                ? 'Home'
                                                                                : index == 1
                                                                                    ? 'Office'
                                                                                    : index == 2
                                                                                        ? 'Other'
                                                                                        : '',
                                                                            'address':
                                                                                sharedPreferences.getString('pickUpAddress').toString(),
                                                                            'pincode':
                                                                                pinCode.toString(),
                                                                            'status':
                                                                                '1',
                                                                          };
                                                                          var res = await UserAPI().createFavLocation(
                                                                              context,
                                                                              param);
                                                                          if (res['status'] != null &&
                                                                              res['status'] == 'OK') {
                                                                            Twl.forceNavigateTo(context,
                                                                                FavouriteLocation());
                                                                            stopLoading();
                                                                          } else {
                                                                            stopLoading();
                                                                            Twl.createAlert(
                                                                                context,
                                                                                'Oops',
                                                                                res['error'].toString());
                                                                            stopLoading();
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
                                                                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: isTab(context) ? 2.h : 3.h),
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: tWhite, boxShadow: [tBackbtnBoxShadow]),
                                                                            child: Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Container(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(isTab(context) ? 10 : 8.0),
                                                                                        child: Image.asset(
                                                                                          index == 0
                                                                                              ? 'assets/icons/house.png'
                                                                                              : index == 1
                                                                                                  ? 'assets/icons/buildinglocation.png'
                                                                                                  : index == 2
                                                                                                      ? 'assets/icons/likemore.png'
                                                                                                      : '',
                                                                                          scale: isTab(context) ? 2.8 : 4.5,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 2.w,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                index == 0
                                                                                                    ? 'Home'
                                                                                                    : index == 1
                                                                                                        ? 'Office'
                                                                                                        : index == 2
                                                                                                            ? 'Other'
                                                                                                            : '',
                                                                                                style: GoogleFonts.mulish(color: tDarkNavyblue, fontWeight: FontWeight.w700, fontSize: isTab(context) ? 10.sp : 12.sp),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            formattedAddress,
                                                                                            // '102 Spline Arcade, Aayyappa Soci..',
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: GoogleFonts.mulish(color: tDarkOrangeColor, fontWeight: FontWeight.w400, fontSize: isTab(context) ? 8.sp : 11.sp),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        // Text(
                                                                                        //   index == 0
                                                                                        //       ? 'Replace'.tr
                                                                                        //       : index == 1
                                                                                        //           ? 'Replace'.tr
                                                                                        //           : index == 2
                                                                                        //               ? ''
                                                                                        //               : '',
                                                                                        //   maxLines: 1,
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      );
                                                                    }),
                                                          ),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                          Center(
                                                            child: SizedBox(
                                                              width:
                                                                  isTab(context)
                                                                      ? 50.w
                                                                      : 60.w,
                                                              height:
                                                                  isTab(context)
                                                                      ? 6.h
                                                                      : 7.h,
                                                              child:
                                                                  ButtonWidget(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            tPrimaryColor,
                                                                      ),
                                                                      // borderRadius: BorderRadius.circular(15),
                                                                      borderRadius:
                                                                          15.0,
                                                                      color:
                                                                          tPrimaryColor,
                                                                      textcolor:
                                                                          tWhite,
                                                                      child:
                                                                          Text(
                                                                        "Add name"
                                                                            .tr,
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            color:
                                                                                tWhite,
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            fontSize: isTab(context)
                                                                                ? 10.sp
                                                                                : 16.sp),
                                                                      ),
                                                                      onTap: (startLoading,
                                                                          stopLoading,
                                                                          btnState) async {
                                                                        showModalBottomSheet(
                                                                            isScrollControlled:
                                                                                true,
                                                                            backgroundColor:
                                                                                tWhite,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                                                                            context: context,
                                                                            builder: (_) {
                                                                              return SelectAddresstitleBottomSheet(favAddress: sharedPreferences.getString('pickUpAddress').toString(), favPincode: pinCode.toString(), favLat: lat.toString(), favLng: lng.toString());
                                                                            });

                                                                        //   'fav_id': '',

                                                                        // onTap: (startLoading, stopLoading, btnState) async {
                                                                        //   Map<String,
                                                                        //           String>
                                                                        //       param =
                                                                        //     //   'fav_id': '',
                                                                        //   };
                                                                        //   // showModalBottomSheet(
                                                                        //   //     isScrollControlled:
                                                                        //   //         true,
                                                                        //   //     // expand: false,
                                                                        //   //     context:
                                                                        //   //         context,
                                                                        //   //     backgroundColor:
                                                                        //   //         Colors
                                                                        //   //             .transparent,
                                                                        //   //     builder:
                                                                        //   //         (context) =>
                                                                        //   //             SingleChildScrollView(child: SelectAddresstitleBottomSheet()));
                                                                      }),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                    title: Text("Check Location"),
                    content: Text('We unable to get your Pincode'),
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
                  'we are unable to find your pincode. please drag the place picker'),
            ));
          }
        },
        region: 'in',
      )),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _favAddressGoogleMapPageState - the data and logic behind its screen

// >>> START: SelectAddresstitleBottomSheet - screen/widget shell (the visible part is in its State class)
class SelectAddresstitleBottomSheet extends StatefulWidget {
  const SelectAddresstitleBottomSheet({
    Key? key,
    this.favLat,
    this.favLng,
    this.favAddress,
    this.favPincode,
  }) : super(key: key);
  final favLat;
  final favLng;
  final favAddress;
  final favPincode;
  @override
  State<SelectAddresstitleBottomSheet> createState() =>
      _SelectAddresstitleBottomSheetState();
}
// <<< END: SelectAddresstitleBottomSheet - screen/widget shell (the visible part is in its State class)

// >>> START: _SelectAddresstitleBottomSheetState - the data and logic behind its screen
class _SelectAddresstitleBottomSheetState
    extends State<SelectAddresstitleBottomSheet> {
  final TextEditingController _titleController = TextEditingController();

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
          color: tWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [tBoxShadow]),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Text(
                'Please_choose_a_title_for_selected_address'.tr,
                style: GoogleFonts.mulish(
                    color: tDarkNavyblue,
                    fontWeight: FontWeight.w700,
                    fontSize: isTab(context) ? 10.sp : 14.sp),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Text(
                'Title'.tr,
                textAlign: TextAlign.start,
                style: GoogleFonts.mulish(
                    color: tGray,
                    fontWeight: FontWeight.w700,
                    fontSize: isTab(context) ? 9.sp : 12.sp),
              ),
              SizedBox(
                height: 0.8.h,
              ),
              TextFormFieldWidgets(
                  hinttext: 'enter_title'.tr, controller: _titleController),
              SizedBox(
                height: 4.h,
              ),
              Center(
                child: SizedBox(
                  width: isTab(context) ? 50.w : 60.w,
                  height: isTab(context) ? 6.h : 7.h,
                  child: ButtonWidget(
                      borderSide: BorderSide(
                        color: tPrimaryColor,
                      ),
                      // borderRadius: BorderRadius.circular(15),
                      borderRadius: 15.0,
                      color: tPrimaryColor,
                      textcolor: tWhite,
                      child: Text(
                        "Save".tr,
                        style: TextStyle(
                            letterSpacing: 1,
                            color: tWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: isTab(context) ? 10.sp : 16.sp),
                      ),
                      // onTap: (startLoading, stopLoading, btnState) async {
                      //   Twl.forceNavigateTo(context, FavouriteLocation());
                      // },
                      onTap: (startLoading, stopLoading, btnState) async {
                        startLoading();
                        Map<String, String> param = {
                          'latitude': widget.favLat,
                          'longitude': widget.favLng,
                          'address_type': _titleController.text,
                          'address': widget.favAddress,
                          'pincode': widget.favPincode,
                          'status': '1',
                        };
                        var res =
                            await UserAPI().createFavLocation(context, param);
                        if (res['status'] != null && res['status'] == 'OK') {
                          Twl.forceNavigateTo(context, FavouriteLocation());
                          stopLoading();
                        } else {
                          stopLoading();
                          Twl.createAlert(
                              context, 'Oops', res['error'].toString());
                          stopLoading();
                        }
                        stopLoading();
                      }


                      ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SelectAddresstitleBottomSheetState - the data and logic behind its screen
