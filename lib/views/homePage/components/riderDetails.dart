// =============================================================================
// WHAT : INACTIVE: whole file is commented out.
// NOTES: Safe to delete.
// =============================================================================

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';

// import '../../../../../constants/constants.dart';
// import '../../../../../constants/imageConstant.dart';
// import '../../../../../globalFuctions/globalFunctions.dart';

// import '../../../../../responsive.dart';
// import '../../../globalWidgets/buttonWidget.dart';
// import '../../../globalWidgets/locationcard.dart';
// import '../../Bookings/components/rideDetailsView/components/rideInfo.dart';
// import '../../bottomNavigation.dart/bottomNavigation.dart';
// import 'paymentSelection.dart';

// class PicUpCard extends StatefulWidget {
//   const PicUpCard({Key? key}) : super(key: key);

//   @override
//   State<PicUpCard> createState() => _PicUpCardState();
// }

// class _PicUpCardState extends State<PicUpCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: WillPopScope(
//           onWillPop: () {
//             return Twl.forceNavigateTo(
//                 context,
//                 BottomNavigation(
//                   tabIndexId: 1,
//                 ));
//           },
//           child: Stack(
//             children: [
//               // GoogleMapPage(),

//               Positioned(
//                   top: 80,
//                   right: 30,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 3.5.w, vertical: 1.2.h),
//                     decoration: BoxDecoration(
//                         color: tPrimaryColor,
//                         boxShadow: [tBoxShadow],
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Row(
//                       children: [
//                         Image.asset(
//                           Images.HELP_ICON,
//                           scale: isTab(context) ? 2.5 : 3.5,
//                           color: tWhite,
//                         ),
//                         SizedBox(
//                           width: 3.w,
//                         ),
//                         Text(
//                           'help'.tr,
//                           style: GoogleFonts.mulish(
//                               color: tWhite,
//                               fontWeight: FontWeight.w700,
//                               fontSize: isTab(context) ? 8.sp : 11.sp),
//                         ),
//                       ],
//                     ),
//                   )),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Stack(

//                     alignment: Alignment.topCenter,
//                     clipBehavior: Clip.none,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           // Twl.forceNavigateTo(context, RideInfo());
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 3.5.w, vertical: 2.h),
//                           decoration: BoxDecoration(
//                               color: tWhite,
//                               boxShadow: [tBoxShadow],
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(30),
//                                   topRight: Radius.circular(30))),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 2.h,
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 3.5.w, vertical: 1.5.h),
//                                 decoration: BoxDecoration(
//                                     color: tWhite,
//                                     boxShadow: [tBoxShadow],
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                        decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(color: tDarkNavyblue,width: 2)
//                                         ),
//                                       child: CircleAvatar(
//                                         backgroundColor: tWhite,
//                                         backgroundImage: AssetImage(Images.IMAAGE),
//                                         radius: isTab(context) ? 20 : 30,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 3.w,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Narasimha Rao',
//                                           style: GoogleFonts.mulish(
//                                               color: tDarkNavyblue,
//                                               fontWeight: FontWeight.w700,
//                                               fontSize: isTab(context)
//                                                   ? 9.sp
//                                                   : 12.sp),
//                                         ),
//                                         SizedBox(
//                                           height: 0.6.h,
//                                         ),
//                                         Text(
//                                           'Driver',
//                                           style: GoogleFonts.mulish(
//                                               color: tDarkOrangeColor,
//                                               fontWeight: FontWeight.w700,
//                                               fontSize:
//                                                   isTab(context) ? 7.sp : 9.sp),
//                                         ),
//                                       ],
//                                     ),
//                                     Spacer(),
//                                     Container(
//                                       padding: EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                           color: tDarkGreen,
//                                           shape: BoxShape.circle),
//                                       child: Icon(
//                                         Icons.call,
//                                         size: isTab(context) ? 15 : 22,
//                                         color: tWhite,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 2.h,
//                               ),
//                               Container(
//                                   decoration: BoxDecoration(
//                                       color: tWhite,
//                                       boxShadow: [tBoxShadow],
//                                       borderRadius: BorderRadius.circular(8)),
//                                   child: LocationCards()),
//                               SizedBox(
//                                 height: 2.h,
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 3.5.w, vertical: 1.5.h),
//                                 decoration: BoxDecoration(
//                                     color: tWhite,
//                                     boxShadow: [tBoxShadow],
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                         padding: EdgeInsets.all(14),
//                                         decoration: BoxDecoration(
//                                             color: tYellow,
//                                             shape: BoxShape.circle),
//                                         child: Image.asset(
//                                           Images.QR_SCANNER,
//                                           scale: isTab(context) ? 2.5 : 3,
//                                         )),
//                                     SizedBox(
//                                       width: 3.w,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'pay_at'.tr,
//                                           style: GoogleFonts.mulish(
//                                               color: tDarkNavyblue,
//                                               fontWeight: FontWeight.w700,
//                                               fontSize: isTab(context)
//                                                   ? 9.sp
//                                                   : 12.sp),
//                                         ),
//                                         SizedBox(
//                                           height: 0.6.h,
//                                         ),
//                                         Text(
//                                           'change_payment'.tr,
//                                           style: GoogleFonts.mulish(
//                                               color: tDarkOrangeColor,
//                                               fontWeight: FontWeight.w700,
//                                               fontSize:
//                                                   isTab(context) ? 7.sp : 9.sp),
//                                         ),
//                                       ],
//                                     ),
//                                     Spacer(),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Twl.forceNavigateTo(
//                                             context, PaymentSelection());
//                                       },
//                                       child: Icon(
//                                         Icons.keyboard_arrow_right,
//                                         size: isTab(context) ? 20 : 30,
//                                         color: tPrimaryColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // cardorderiddetails(),
//                               SizedBox(
//                                 height: 1.8.h,
//                               ),
//                               Padding(
//                                 padding:
//                                     EdgeInsets.only(top: 20, left: 0, right: 0),
//                                 child: GestureDetector(
//                                   onTap: () {},
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: tWhite,
//                                         boxShadow: [tBoxShadow],
//                                         borderRadius:
//                                             BorderRadiusDirectional.circular(
//                                                 8)),
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 6, horizontal: 6),
//                                     child: Row(children: [
//                                       SizedBox(
//                                         width: 4.w,
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.only(top: 10),
//                                         child: Text(
//                                           "Price".tr,
//                                           style: TextStyle(
//                                               fontSize:
//                                                   isTab(context) ? 8.sp : 12.sp,
//                                               fontWeight: FontWeight.w500,
//                                               color: tDarkNavyblue),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 1.5.w,
//                                       ),
//                                       // Text(
//                                       //   currencySymbol + "52",
//                                       //   style: GoogleFonts.mulish(
//                                       //     color: tDarkNavyblue,
//                                       //     fontWeight: FontWeight.w800,
//                                       //     fontSize:
//                                       //         isTab(context) ? 14.sp : 20.sp,
//                                       //   ),
//                                       // ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             currencySymbol + "52",
//                                             style: GoogleFonts.mulish(
//                                               color: tDarkNavyblue,
//                                               fontWeight: FontWeight.w800,
//                                               fontSize: isTab(context)
//                                                   ? 14.sp
//                                                   : 20.sp,
//                                             ),
//                                           ),
//                                           Column(
//                                             children: [
//                                               Icon(
//                                                 Icons.info_outline,
//                                                 size: 15,
//                                                 color: tPrimaryColor,
//                                               ),
//                                               SizedBox(height: 2.h)
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Spacer(),
//                                       SizedBox(
//                                         width: isTab(context) ? 22.w : 33.w,
//                                         height: isTab(context) ? 5.h : 5.5.h,
//                                         child: ButtonWidget(
//                                           borderRadius:
//                                               isTab(context) ? 12.0 : 8.0,
//                                           color: tPrimaryColor,
//                                           child: Text(
//                                             "Pay_now".tr,
//                                             // style: TextStyle(
//                                             //     letterSpacing: 1,
//                                             //     color: tBlack,
//                                             //     fontWeight: FontWeight.w700,
//                                             //
//                                             style: GoogleFonts.mulish(
//                                                 color: tWhite,
//                                                 fontWeight: FontWeight.w700,
//                                                 fontSize: isTab(context)
//                                                     ? 9.sp
//                                                     : 16.sp),
//                                           ),
//                                           onTap: (startLoading, stopLoading,
//                                               btnState) {
//                                             Twl.forceNavigateTo(
//                                                 context, PaymentSelection());
//                                           },
//                                           borderSide: BorderSide(
//                                             color: tPrimaryColor,
//                                           ),
//                                         ),
//                                       )
//                                     ]),
//                                   ),
//                                 ),
//                               )
//                               // Padding(
//                               //   padding: const EdgeInsets.all(8.0),
//                               //   child: Center(
//                               //     child: SizedBox(
//                               //       width: isTab(context) ? 70.w : 85.w,
//                               //       height: isTab(context) ? 6.h : 6.h,
//                               //       child: ButtonWidget(
//                               //           borderSide: BorderSide(
//                               //             color: tPrimaryColor,
//                               //           ),
//                               //           // borderRadius: BorderRadius.circular(15),
//                               //           borderRadius: 15.0,
//                               //           color: tPrimaryColor,
//                               //           textcolor: tDarkNavyblue,
//                               //           child: Text(
//                               //             "Login",
//                               //             style: TextStyle(
//                               //                 letterSpacing: 1,
//                               //                 color: tWhite,
//                               //                 fontWeight: FontWeight.w700,
//                               //                 fontSize:
//                               //                     isTab(context) ? 10.sp : 16.sp),
//                               //           ),
//                               //           onTap: (startLoading, stopLoading,
//                               //               btnState) async {
//                               //             //     print(_usernumbercontroller.text);
//                               //             //        Map<String, String> param = {
//                               //             //     'contact_no': _usernumbercontroller.text,
//                               //             //   };
//                               //             // Twl.navigateTo(
//                               //             //     context,
//                               //             //     Otppage(
//                               //             //         mobileNumber:
//                               //             //             _usernumbercontroller.text,
//                               //             //         // sessionCode: res['details']
//                               //             //         //     ['Details'],
//                               //             //         ));

//                               //             // // startLoading();
//                               //             // // if (_formKey.currentState!.validate()) {
//                               //             // //   // if (isChecked == true) {
//                               //             // //   Map<String, String> param = {
//                               //             // //     'contact_no': _usernumbercontroller.text,
//                               //             // //   };
//                               //             // //   print(param);
//                               //             // //   var res =
//                               //             // //       await UserAPI().sendOtp(context, param);
//                               //             // //   if (res != null && res['status'] == 'OK') {
//                               //             // //     Twl.navigateTo(
//                               //             // //         context,
//                               //             // //         Otppage(
//                               //             // //           mobileNumber:
//                               //             // //               _usernumbercontroller.text,
//                               //             // //           sessionCode: res['details']
//                               //             // //               ['Details'],
//                               //             // //         ));
//                               //             // //   } else {
//                               //             // //     stopLoading();
//                               //             // //     Twl.createAlert(context, 'Oops',
//                               //             // //         res['error'].toString());
//                               //             // //     stopLoading();
//                               //             // //   }
//                               //             // //   stopLoading();
//                               //             // //   // } else {
//                               //             // //   //   stopLoading();
//                               //             // //   //   // return _showDialog(context);
//                               //             // //   // }
//                               //             // // }
//                               //             // // stopLoading();
//                               //           }),
//                               //     ),
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(

//                         top: isTab(context) ? -75 : -30,
//                         // left: isTab(context)?155:115,
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 3.5.w, vertical: 1.5.h),
//                               decoration: BoxDecoration(
//                                   color: tYellow,
//                                   boxShadow: [tBoxShadow],
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text('OTP : 1234',
//                                       style: GoogleFonts.mulish(
//                                           color: tDarkNavyblue,
//                                           fontWeight: FontWeight.w800,
//                                           fontSize:
//                                               isTab(context) ? 9.sp : 12.sp)),
//                                   SizedBox(
//                                     width: 2.w,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 3.w,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 Twl.forceNavigateTo(context, RideInfo());
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                     color: tPrimaryColor,
//                                     shape: BoxShape.circle),
//                                 child: Icon(
//                                   Icons.info,
//                                   size: isTab(context) ? 25 : 35,
//                                   color: tbrown,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
