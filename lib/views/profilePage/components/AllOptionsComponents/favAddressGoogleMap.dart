// =============================================================================
// WHAT : Map picker + title sheet to create a favourite address.
// NOTES: Server: create-favourite-location.
// =============================================================================
// // ignore_for_file: unused_local_variable

import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/views/profilePage/Components/AllOptionsComponents/FavoritesLocation.dart';

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
    // A full-screen light map: dark status bar icons, so the clock and battery can be read (they were white on the map).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
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
                  isScrollControlled: true,
                  backgroundColor: tWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  context: context,
                  // straight to "Select Title" (Home / Office / Other); the extra sheet that held only one button is gone
                  builder: (_) => SelectAddresstitleBottomSheet(
                        favAddress: sharedPreferences.getString('pickUpAddress').toString(),
                        favPincode: pinCode.toString(),
                        favLat: lat.toString(),
                        favLng: lng.toString(),
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
    ));
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
              SizedBox(height: 1.2.h),
              // one tap for the usual titles; any other title can still be typed
              Wrap(
                spacing: 8,
                children: [
                  for (final t in const ['Home', 'Office', 'Other'])
                    ActionChip(
                      label: Text(t, style: GoogleFonts.mulish(color: tDarkNavyblue, fontWeight: FontWeight.w700)),
                      backgroundColor: tPrimaryColor.withOpacity(0.12),
                      onPressed: () => setState(() => _titleController.text = t),
                    ),
                ],
              ),
              SizedBox(
                height: 3.h,
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
                        if (_titleController.text.trim().isEmpty) {
                          // a blank title used to be saved as an unnamed favourite
                          Twl.createAlert(context, 'Title', 'Please enter a title, for example Home or Office.');
                          return;
                        }
                        startLoading();
                        Map<String, String> param = {
                          'latitude': widget.favLat,
                          'longitude': widget.favLng,
                          'address_type': _titleController.text.trim(),
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
