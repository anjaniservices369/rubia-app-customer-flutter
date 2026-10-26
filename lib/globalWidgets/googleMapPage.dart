// =============================================================================
// WHAT : INACTIVE: whole file is commented out; googleMapScreen.dart is the
//        live version.
// NOTES: Safe to delete.
// =============================================================================
// // ignore_for_file: unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants/constants.dart';
// import '../globalFuctions/globalFunctions.dart';
// import '../views/homePage/drawer.dart';


// class GoogleMapPage extends StatefulWidget {
//   GoogleMapPage({Key? key}) : super(key: key);
//   static final kInitialPosition = LatLng(17.3850, 78.4867);

//   @override
//   _GoogleMapPageState createState() => _GoogleMapPageState();
// }

// var status = 0;
// var rides;

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
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
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: Darwer(),
//       body: Center(
//           child: Stack(
//         children: [
//           PlacePicker(
//             apiKey: mapKey,
//             // hintText: "Find a place ...",
//             // searchingText: "Please wait ...",
//             // selectText: "Select Location",
//             // outsideOfPickAreaText: "Place not in area",
//             initialPosition: GoogleMapPage.kInitialPosition,
//             useCurrentLocation: true,
//             selectInitialPosition: true,
//             usePinPointingSearch: true,
//             usePlaceDetailSearch: true,
//             onPlacePicked: (result) async {
//               selectedPlace = result;
//               print(selectedPlace!.formattedAddress);
//               print(selectedPlace!.geometry!.location.lat);
//               print(selectedPlace!.geometry!.location.lng);
//               SharedPreferences sharedPreferences =
//                   await SharedPreferences.getInstance();
//               // GetStorage getStorage = GetStorage();
//               sharedPreferences.setString(
//                   "formattedAddress", selectedPlace!.formattedAddress!);
//               sharedPreferences.setDouble(
//                   "lattitude", selectedPlace!.geometry!.location.lat);
//               sharedPreferences.setDouble(
//                   "longitude", selectedPlace!.geometry!.location.lng);
//               formattedAddress =
//                   sharedPreferences.getString('formattedAddress')!;
//               lat = sharedPreferences.getDouble('lattitude')!;
//               lng = sharedPreferences.getDouble('longitude')!;
//               print(selectedPlace!.addressComponents![0].types.length);
//               print(formattedAddress);
//               print(lat);
//               print(lng);
//               // var latLng = {
//               //   'lat': lat,
//               //   'lng': lng,
//               // };
//               // getStorage.write("latLng", latLng);
//               // latLng = getStorage.read('latLng');

//               //  print(latLng);

//               for (var i = 0;
//                   i < selectedPlace!.addressComponents!.length;
//                   i++) {
//                 for (var j = 0;
//                     j < selectedPlace!.addressComponents![i].types.length;
//                     j++) {
//                   // print(selectedPlace!.addressComponents![i].types[j]);
//                   if (selectedPlace!.addressComponents![i].types[j] ==
//                           "postal_code" ||
//                       selectedPlace!.addressComponents![i].types[j] ==
//                           "postal_code_prefix") {
//                     postalCode = selectedPlace!.addressComponents![i].shortName;

//                     sharedPreferences.setString("postalCode", postalCode!);
//                     postalCode = sharedPreferences.getString('postalCode');
//                     print(postalCode);
//                   }

//                   streetName1 = selectedPlace!.addressComponents![1].longName;
//                   streetName2 = selectedPlace!.addressComponents![3].longName;
//                   streetName3 = selectedPlace!.addressComponents![5].longName;
//                   postalCode = selectedPlace!.addressComponents![7].longName;
//                   // streetName = selectedPlace!.addressComponents![3].longName;
//                   // var address = selectedPlace!.addressComponents![i].types.length;
//                   sharedPreferences.setString("streetName1", streetName1);
//                   streetName1 = sharedPreferences.getString('streetName1')!;

//                   sharedPreferences.setString("streetName2", streetName2);
//                   streetName2 = sharedPreferences.getString('streetName2')!;
//                   print("streetName2:-" + streetName2);
//                   sharedPreferences.setString("streetName3", streetName3);
//                   streetName3 = sharedPreferences.getString('streetName3')!;

//                   print("streetName1:-" + streetName1);
//                   print(streetName2);
//                   print("streetName3:-" + streetName3);
//                   var cityaddress = streetName2;
//                   var fulladdress = streetName1 + streetName2 + streetName3;
//                   print(cityaddress);
//                   // print(fulladdress);
//                   sharedPreferences.setString("AddressLine", fulladdress);
//                   sharedPreferences.setString("cityaddress", cityaddress);
//                   var address = sharedPreferences.getString('AddressLine');

//                   var cityLocation = sharedPreferences.getString('cityaddress');
//                   print(address);
//                   print('postalCode');
//                   print(postalCode);

//                   if (postalCode != null) {
//                     var res;
//                     // = await UserAPI()
//                     //     .checkDelivery(context, postalCode.toString());
//                     if (res['status'] == 'OK' && res != null) {
//                       //Redirect to Home Page
//                       // Twl.navigateTo(context, BottomNavigation());
//                     } else {
//                       //
//                       return showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("Select another Location"),
//                             content: Text(
//                                 'We are not able to deliver to this address'),
//                             actions: <Widget>[
//                               TextButton(
//                                 child: Text('ok'),
//                                 onPressed: () {
//                                   Twl.navigateBack(context);
//                                 },
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                   } else {
//                     //
//                     return showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text("Check Location"),
//                           content: Text('We able to get your Pincode'),
//                           actions: <Widget>[
//                             TextButton(
//                               child: Text('ok'),
//                               onPressed: () {
//                                 Twl.navigateBack(context);
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }

//                   // Twl.navigateTo(context, BottomNavigation());
//                 }
//               }
//             },

//             // forceSearchOnZoomChanged: true,
//             // automaticallyImplyAppBarLeading: false,
//             // autocompleteLanguage: "ko",
//             region: 'in',
//           ),
//           // Column(
//           //   crossAxisAlignment: CrossAxisAlignment.end,
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //   children: [
//           //     status == 0
//           //         ? GestureDetector(
//           //             onTap: () {
//           //               setState(() {
//           //                 status = 1;
//           //               });
//           //             },
//           //             child: SearchLocationPage(),
//           //           )
//           //         : status == 1
//           //             ? GestureDetector(
//           //                 child: Align(
//           //                     alignment: Alignment.bottomCenter,
//           //                     child: Padding(
//           //                         padding: EdgeInsets.symmetric(horizontal: 0),
//           //                         child: Container(
//           //                           decoration: BoxDecoration(
//           //                             boxShadow: [tBoxShadow],
//           //                             color: tWhite,
//           //                             borderRadius: BorderRadius.only(
//           //                                 topLeft: Radius.circular(30),
//           //                                 topRight: Radius.circular(30)),
//           //                           ),
//           //                           // height: 45.h,
//           //                           child: Padding(
//           //                             padding: EdgeInsets.symmetric(
//           //                                 horizontal: 15, vertical: 10),
//           //                             child: Column(
//           //                               children: [
//           //                                 Container(
//           //                                   decoration: BoxDecoration(
//           //                                       borderRadius: BorderRadius.all(
//           //                                           Radius.circular(30)),
//           //                                       boxShadow: [tBoxShadow],
//           //                                       color: tBlack),
//           //                                 ),
//           //                                 Container(
//           //                                   width: 15.w,
//           //                                   height: 0.7.h,
//           //                                   decoration: BoxDecoration(
//           //                                       borderRadius:
//           //                                           BorderRadius.circular(12),
//           //                                       color: tPrimaryColor),
//           //                                 ),
//           //                                 SizedBox(
//           //                                   height: 5.h,
//           //                                 ),
//           //                                 Row(
//           //                                   children: [
//           //                                     Text('Available Rides',
//           //                                         style: TextStyle(
//           //                                             color: tBlack,
//           //                                             fontSize: isTab(context)
//           //                                                 ? 13.sp
//           //                                                 : 16.sp,
//           //                                             fontWeight:
//           //                                                 FontWeight.w600)),
//           //                                   ],
//           //                                 ),
//           //                                 SizedBox(
//           //                                   height: 3.h,
//           //                                 ),
//           //                                 GestureDetector(
//           //                                   onTap: () {
//           //                                     setState(() {
//           //                                       rides = 0;
//           //                                     });
//           //                                   },
//           //                                   child: Container(
//           //                                     decoration: BoxDecoration(
//           //                                         boxShadow: [tBoxShadow],
//           //                                         color: rides == 0
//           //                                             ? tPrimaryColor
//           //                                             : tWhite,
//           //                                         borderRadius:
//           //                                             BorderRadius.all(
//           //                                                 Radius.circular(10))),
//           //                                     child: Padding(
//           //                                       padding: EdgeInsets.symmetric(
//           //                                           vertical: 1.h,
//           //                                           horizontal: 1.h),
//           //                                       child: Row(
//           //                                         children: [
//           //                                           Column(
//           //                                             children: [
//           //                                               Container(
//           //                                                 decoration: BoxDecoration(
//           //                                                     color: rides == 0
//           //                                                         ? tPrimaryColor
//           //                                                         : tbackground,
//           //                                                     borderRadius: BorderRadius
//           //                                                         .all(Radius
//           //                                                             .circular(
//           //                                                                 12)),
//           //                                                     border: Border.all(
//           //                                                         color: rides ==
//           //                                                                 0
//           //                                                             ? tBlack
//           //                                                             : tPrimaryColor,
//           //                                                         width: 1)),
//           //                                                 child: Padding(
//           //                                                     padding:
//           //                                                         EdgeInsets
//           //                                                             .all(8.0),
//           //                                                     child:
//           //                                                         Image.asset(
//           //                                                       Images.AUTOICON,
//           //                                                       scale: isTab(
//           //                                                               context)
//           //                                                           ? 2
//           //                                                           : 3,
//           //                                                     )),
//           //                                               )
//           //                                             ],
//           //                                           ),
//           //                                           SizedBox(
//           //                                             width: 6.w,
//           //                                           ),
//           //                                           Column(
//           //                                             crossAxisAlignment:
//           //                                                 CrossAxisAlignment
//           //                                                     .start,
//           //                                             children: [
//           //                                               Text('Auto',
//           //                                                   style: TextStyle(
//           //                                                       color: tBlack,
//           //                                                       fontSize: isTab(
//           //                                                               context)
//           //                                                           ? 12.sp
//           //                                                           : 15.sp,
//           //                                                       fontWeight:
//           //                                                           FontWeight
//           //                                                               .w600)),
//           //                                               Text('3+1 Person',
//           //                                                   style: TextStyle(
//           //                                                       color:
//           //                                                           rides == 0
//           //                                                               ? tBlack
//           //                                                               : tGray,
//           //                                                       fontSize: isTab(
//           //                                                               context)
//           //                                                           ? 9.sp
//           //                                                           : 12.sp,
//           //                                                       fontWeight:
//           //                                                           FontWeight
//           //                                                               .w500)),
//           //                                             ],
//           //                                           ),
//           //                                           Spacer(),
//           //                                           Column(
//           //                                             children: [
//           //                                               Row(
//           //                                                 crossAxisAlignment:
//           //                                                     CrossAxisAlignment
//           //                                                         .end,
//           //                                                 // mainAxisAlignment: MainAxisAlignment.end,
//           //                                                 children: [
//           //                                                   Text(
//           //                                                     '₹120',
//           //                                                     style: TextStyle(
//           //                                                         decoration:
//           //                                                             TextDecoration
//           //                                                                 .lineThrough),
//           //                                                   ),
//           //                                                   SizedBox(
//           //                                                     width: 1.w,
//           //                                                   ),
//           //                                                   Text(
//           //                                                     '₹100',
//           //                                                     style: TextStyle(
//           //                                                         color: tBlack,
//           //                                                         fontSize: isTab(
//           //                                                                 context)
//           //                                                             ? 11.sp
//           //                                                             : 14.sp,
//           //                                                         fontWeight:
//           //                                                             FontWeight
//           //                                                                 .w600),
//           //                                                   )
//           //                                                 ],
//           //                                               )
//           //                                             ],
//           //                                           )
//           //                                         ],
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                                 SizedBox(
//           //                                   height: 3.h,
//           //                                 ),
//           //                                 GestureDetector(
//           //                                   onTap: () {
//           //                                     setState(() {
//           //                                       rides = 1;
//           //                                     });
//           //                                   },
//           //                                   child: Container(
//           //                                     decoration: BoxDecoration(
//           //                                         boxShadow: [tBoxShadow],
//           //                                         color: rides == 1
//           //                                             ? tPrimaryColor
//           //                                             : tWhite,
//           //                                         borderRadius:
//           //                                             BorderRadius.all(
//           //                                                 Radius.circular(10))),
//           //                                     child: Padding(
//           //                                       padding: EdgeInsets.symmetric(
//           //                                           vertical: 1.h,
//           //                                           horizontal: 1.h),
//           //                                       child: Row(
//           //                                         children: [
//           //                                           Column(
//           //                                             children: [
//           //                                               Container(
//           //                                                 decoration: BoxDecoration(
//           //                                                     color: rides == 1
//           //                                                         ? tPrimaryColor
//           //                                                         : tbackground,
//           //                                                     borderRadius: BorderRadius
//           //                                                         .all(Radius
//           //                                                             .circular(
//           //                                                                 12)),
//           //                                                     border: Border.all(
//           //                                                         color: rides ==
//           //                                                                 1
//           //                                                             ? tBlack
//           //                                                             : tPrimaryColor,
//           //                                                         width: 1)),
//           //                                                 child: Padding(
//           //                                                     padding:
//           //                                                         EdgeInsets
//           //                                                             .all(8.0),
//           //                                                     child:
//           //                                                         Image.asset(
//           //                                                       Images.BIKEICON,
//           //                                                       scale: isTab(
//           //                                                               context)
//           //                                                           ? 2
//           //                                                           : 3,
//           //                                                     )),
//           //                                               )
//           //                                             ],
//           //                                           ),
//           //                                           SizedBox(
//           //                                             width: 6.w,
//           //                                           ),
//           //                                           Column(
//           //                                             crossAxisAlignment:
//           //                                                 CrossAxisAlignment
//           //                                                     .start,
//           //                                             children: [
//           //                                               Text('Bike',
//           //                                                   style: TextStyle(
//           //                                                       color: tBlack,
//           //                                                       fontSize: isTab(
//           //                                                               context)
//           //                                                           ? 12.sp
//           //                                                           : 15.sp,
//           //                                                       fontWeight:
//           //                                                           FontWeight
//           //                                                               .w600)),
//           //                                               Row(
//           //                                                 children: [
//           //                                                   Text('1 Person',
//           //                                                       style: TextStyle(
//           //                                                           color: rides ==
//           //                                                                   1
//           //                                                               ? tBlack
//           //                                                               : tGray,
//           //                                                           fontSize: isTab(
//           //                                                                   context)
//           //                                                               ? 9.sp
//           //                                                               : 12.sp,
//           //                                                           fontWeight:
//           //                                                               FontWeight
//           //                                                                   .w500)),
//           //                                                   SizedBox(
//           //                                                     width: 7.w,
//           //                                                   ),
//           //                                                   Image.asset(
//           //                                                     Images.CLOCKTIMER,
//           //                                                     scale:
//           //                                                         isTab(context)
//           //                                                             ? 3.5
//           //                                                             : 6,
//           //                                                     color: tGray,
//           //                                                   ),
//           //                                                   SizedBox(
//           //                                                     width: 1.w,
//           //                                                   ),
//           //                                                   Text('6 mins',
//           //                                                       style: TextStyle(
//           //                                                           color: rides ==
//           //                                                                   1
//           //                                                               ? tBlack
//           //                                                               : tGray,
//           //                                                           fontSize: isTab(
//           //                                                                   context)
//           //                                                               ? 9.sp
//           //                                                               : 12.sp,
//           //                                                           fontWeight:
//           //                                                               FontWeight
//           //                                                                   .w500)),
//           //                                                 ],
//           //                                               ),
//           //                                             ],
//           //                                           ),
//           //                                           Spacer(),
//           //                                           Column(
//           //                                             children: [
//           //                                               Text(
//           //                                                 '₹30',
//           //                                                 style: TextStyle(
//           //                                                     color: tBlack,
//           //                                                     fontSize:
//           //                                                         isTab(context)
//           //                                                             ? 10.sp
//           //                                                             : 13.sp,
//           //                                                     fontWeight:
//           //                                                         FontWeight
//           //                                                             .w600),
//           //                                               )
//           //                                             ],
//           //                                           )
//           //                                         ],
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                                 Padding(
//           //                                   padding: EdgeInsets.symmetric(
//           //                                       horizontal: 3.w, vertical: 3.h),
//           //                                   // child: Center(
//           //                                   //   child: ArgonButton(
//           //                                   //     onTap: (startLoading,
//           //                                   //         stopLoading, btnState) {
//           //                                   //       setState(() {
//           //                                   //         status = 2;
//           //                                   //       });
//           //                                   //     },
//           //                                   //     height:
//           //                                   //         isTab(context) ? 9.h : 7.h,
//           //                                   //     width: 80.w,
//           //                                   //     color: tBlack,
//           //                                   //     borderRadius: 50,
//           //                                   //     child: Text(
//           //                                   //       'Book Ride',
//           //                                   //       style: TextStyle(
//           //                                   //           color: tWhite,
//           //                                   //           fontWeight:
//           //                                   //               FontWeight.w600,
//           //                                   //           fontSize: isTab(context)
//           //                                   //               ? 10.sp
//           //                                   //               : 14.sp),
//           //                                   //     ),
//           //                                   //   ),
//           //                                   // ),
//           //                                 ),
//           //                               ],
//           //                             ),
//           //                           ),
//           //                         ))),
//           //               )
//           //             : status == 2
//           //                 ? GestureDetector(
//           //                     onTap: () {
//           //                       setState(() {
//           //                         status = 3;
//           //                       });
//           //                     },
//           //                     // child: searchingRiderWidget(),
//           //                   )
//           //                 : status == 3
//           //                     ? GestureDetector(
//           //                         onTap: () {
//           //                           setState(() {
//           //                             status = 4;
//           //                           });
//           //                         },
//           //                         // child:rideArrivedCardWidget()
//           //                       )
//           //                     : status == 4
//           //                         ? GestureDetector(
//           //                             onTap: () {
//           //                               setState(() {
//           //                                 status = 0;
//           //                               });
//           //                             },
//           //                             child: RateYourExperienceCardWidget(),
//           //                           )
//           //                         : Container()
//           //   ],
//           // ),
//           // Positioned(
//           //     top: 50,
//           //     left: 20,
//           //     child: status == 0
//           //         ? GestureDetector(
//           //             onTap: () {
//           //               MaterialLocalizations.of(context).openAppDrawerTooltip;
//           //               _scaffoldKey.currentState!.openDrawer();
//           //             },
//           //             child: Container(
//           //                 padding:
//           //                     EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           //                 decoration: BoxDecoration(
//           //                     boxShadow: [tBoxShadow],
//           //                     color: tWhite,
//           //                     borderRadius: BorderRadius.circular(8)),
//           //                 child: Image.asset(
//           //                   Images.DRAWERICON,
//           //                   scale: isTab(context) ? 2 : 3,
//           //                 )),
//           //           )
//           //         : status == 1
//           //             ? GestureDetector(
//           //                 onTap: () {
//           //                   setState(() {
//           //                     status = 0;
//           //                   });
//           //                 },
//           //                 child: BackIconWidget(),
//           //               )
//           //             : status == 2
//           //                 ? GestureDetector(
//           //                     onTap: () {
//           //                       setState(() {
//           //                         status = 1;
//           //                       });
//           //                     },
//           //                     child: BackIconWidget(),
//           //                   )
//           //                 : status == 3
//           //                     ? GestureDetector(
//           //                         onTap: () {
//           //                           setState(() {
//           //                             status = 2;
//           //                           });
//           //                         },
//           //                         child: BackIconWidget(),
//           //                       )
//           //                     : status == 4
//           //                         ? GestureDetector(
//           //                             onTap: () {
//           //                               setState(() {
//           //                                 status = 3;
//           //                               });
//           //                             },
//           //                             child: BackIconWidget(),
//           //                           )
//           //                         : Container()),
//           // Positioned(
//           //     top: 50,
//           //     right: 20,
//           //     child: GestureDetector(
//           //       onTap: () {
//           //         MaterialLocalizations.of(context).openAppDrawerTooltip;
//           //         _scaffoldKey.currentState!.openDrawer();
//           //       },
//           //       child: Stack(
//           //         // ignore: deprecated_member_use
//           //         overflow: Overflow.visible,
//           //         children: [
//           //           GestureDetector(
//           //             onTap: () {},
//           //             child: Container(
//           //                 padding:
//           //                     EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           //                 decoration: BoxDecoration(
//           //                     boxShadow: [tBoxShadow],
//           //                     color: tWhite,
//           //                     borderRadius: BorderRadius.circular(8)),
//           //                 child: Image.asset(
//           //                   Images.NOTIFICATIONICON,
//           //                   scale: isTab(context) ? 2 : 3,
//           //                 )),
//           //           ),
//           //           Positioned(
//           //               right: -2,
//           //               top: -3,
//           //               child: Container(
//           //                 padding: EdgeInsets.all(4),
//           //                 decoration: BoxDecoration(
//           //                     shape: BoxShape.circle, color: tRed),
//           //               ))
//           //         ],
//           //       ),
//           //     )),
//         ],
//       )),
//     );
//   }
// }
