// =============================================================================
// WHAT : INACTIVE: whole file is commented out (old map helper).
// NOTES: Safe to delete.
// =============================================================================
// import 'package:base_project_flutter/api_services/userApi.dart';
// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
// import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class GoogleMapPage extends StatefulWidget {
//   GoogleMapPage({Key? key}) : super(key: key);
//   static final kInitialPosition = LatLng(17.3850, 78.4867);

//   @override
//   _GoogleMapPageState createState() => _GoogleMapPageState();
// }

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   PickResult? selectedPlace;
//   late double lat;
//   late double lng;
//   late String formattedAddress;
//   String? postalCode;
//   String? pinCode;
//   late String streetName1;
//   late String streetName2;
//   late String streetName3;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: PlacePicker(
//         apiKey: mapKey,
//         hintText: "Find a place ...",
//         searchingText: "Please wait ...",
//         selectText: "Select Location",
//         outsideOfPickAreaText: "Place not in area",
//         initialPosition: GoogleMapPage.kInitialPosition,
//         useCurrentLocation: true,
//         selectInitialPosition: true,
//         usePinPointingSearch: true,
//         usePlaceDetailSearch: true,
//         onPlacePicked: (result) async {
//           selectedPlace = result;
//           print(selectedPlace!.formattedAddress);
//           print(selectedPlace!.geometry!.location.lat);
//           print(selectedPlace!.geometry!.location.lng);
//           SharedPreferences sharedPreferences =
//               await SharedPreferences.getInstance();
//           // GetStorage getStorage = GetStorage();
//           sharedPreferences.setString(
//               "formattedAddress", selectedPlace!.formattedAddress!);
//           sharedPreferences.setDouble(
//               "lattitude", selectedPlace!.geometry!.location.lat);
//           sharedPreferences.setDouble(
//               "longitude", selectedPlace!.geometry!.location.lng);
//           formattedAddress = sharedPreferences.getString('formattedAddress')!;
//           lat = sharedPreferences.getDouble('lattitude')!;
//           lng = sharedPreferences.getDouble('longitude')!;
//           print(selectedPlace!.addressComponents![0].types.length);
//           print(formattedAddress);
//           print(lat);
//           print(lng);
//           final coordinates = new Coordinates(lat, lng);
//           try {
//             var addresses = await Geocoder.google(mapKey)
//                 .findAddressesFromQuery(selectedPlace!.formattedAddress!);
//             print(addresses);
//             // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             //   content: Text(addresses.first.postalCode.toString()),
//             // ));
//             var first = addresses.first;
//             SharedPreferences sharedPreferences =
//                 await SharedPreferences.getInstance();
//             sharedPreferences.setDouble('lattitude', lat);
//             // var lat = sharedPreferences.getDouble('lattitude');
//             sharedPreferences.setDouble('longitude', lng);
//             // var long = sharedPreferences.getDouble('longitude');
//             sharedPreferences.setString('FeatureName', first.featureName);
//             var featureName = sharedPreferences.getString('FeatureName');
//             sharedPreferences.setString('AddressLine', first.addressLine);
//             var addressLine = sharedPreferences.getString('AddressLine');
//             sharedPreferences.setString('Locality', first.locality);
//             var locality = sharedPreferences.getString('Locality');
//             sharedPreferences.setString('PinCode', first.postalCode);
//             var pinCode = sharedPreferences.getString('PinCode');
//             if (addresses.first.postalCode != null) {
//               var res ;
//               // =
//               //     await UserAPI().checkDelivery(context, pinCode.toString());
//               // print("ress>>>>>>>>>>>>>");
//               // print(res);
//               if (res['status'] == 'OK' && res != null) {
//                 setState(() {
//                   Twl.forceNavigateTo(context, BottomNavigation());
//                 });
//               } else {
//                 //
//                 return showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text("Select another Location"),
//                       content:
//                           Text('We are not able to deliver to this address'),
//                       actions: <Widget>[
//                         InkWell(
//                           child: Text('ok'),
//                           onTap: () {
//                             Twl.navigateBack(context);
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               }
//             } else {
//               //
//               return showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text("Check Location"),
//                     content: Text('We unable to get your Pincode'),
//                     actions: <Widget>[
//                       InkWell(
//                         child: Text('ok'),
//                         onTap: () {
//                           Twl.navigateBack(context);
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             }

//            } catch (e) {
//             throw ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               behavior: SnackBarBehavior.floating,
//               content: Text(
//                   'we are anable to find your pincode. please drag the place picker'),
//             ));
//            }
//         },

//         // forceSearchOnZoomChanged: true,
//         // automaticallyImplyAppBarLeading: false,
//         // autocompleteLanguage: "ko",
//         region: 'in',
//       )),
//     );
//   }
// }
