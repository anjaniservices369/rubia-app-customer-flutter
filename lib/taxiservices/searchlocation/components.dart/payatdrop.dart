// =============================================================================
// WHAT : INACTIVE: whole file is commented out.
// NOTES: Safe to delete.
// =============================================================================
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// import '../../../../../../../constants/constants.dart';
// import '../../../../../../../responsive.dart';
// import '../../../constants/imageConstant.dart';

// class PayAtDropCardWidget extends StatefulWidget {
//   const PayAtDropCardWidget({
//     Key? key,
//     this.rideData,
//     this.getVechileDetails,
//     this.rideId,
//     this.selectedIndex,
//     this.totalFare,
//   }) : super(key: key);
//   final rideData;
//   final totalFare;

//   final getVechileDetails;
//   final rideId;
//   final selectedIndex;
//   @override
//   State<PayAtDropCardWidget> createState() => _PayAtDropCardWidgetState();
// }

// class _PayAtDropCardWidgetState extends State<PayAtDropCardWidget> {
//   @override
//   Widget build(BuildContext context) {
//     // RideBookingProvidder _data = Provider.of<RideBookingProvidder>(context);
//     return GestureDetector(
//       onTap: () async {
//         // Twl.forceNavigateTo(
//         //     context,
//         //     PaymentMethod(
//         //       getVechileDetails: widget.getVechileDetails,
//         //       rideId: widget.rideId,
//         //       selectedIndex: widget.selectedIndex,
//         //       totalFare:widget.totalFare
//         //     ));
//         // showDialog(
//         //     context: context,
//         //     barrierDismissible: false, // user must tap button!
//         //     builder: (BuildContext context) {
//         //       return CupertinoAlertDialog(
//         //         title: Text(
//         //           "Payment mode",
//         //           style: GoogleFonts.mulish(
//         //               color: tBlack,
//         //               fontWeight: FontWeight.bold,
//         //               fontSize: isTab(context) ? 11.sp : 14.sp),
//         //         ),
//         //         actions: [
//         //           CupertinoDialogAction(
//         //               onPressed: () {
//         // _data.fetchCashMode('cash');
//         // Twl.navigateBack(context);
//         //               },
//         //               child: Text(
//         //                 "Cash",
//         //                 style: GoogleFonts.mulish(
//         //                     color: tBlack,
//         //                     fontWeight: FontWeight.bold,
//         //                     fontSize: isTab(context) ? 9.sp : 12.sp),
//         //               )),
//         //           CupertinoDialogAction(
//         //               onPressed: () {
//         // _data.fetchCashMode('online');
//         //   Twl.navigateBack(context);
//         //               },
//         //               child: Text(
//         //                 "Online",
//         //                 style: GoogleFonts.mulish(
//         //                     color: tBlack,
//         //                     fontWeight: FontWeight.bold,
//         //                     fontSize: isTab(context) ? 9.sp : 12.sp),
//         //               )),
//         //         ],
//         //         content: Text(
//         //           "Change payment mode as",
//         //           style: GoogleFonts.mulish(
//         //               color: tBlack,
//         //               fontWeight: FontWeight.w500,
//         //               fontSize: isTab(context) ? 9.sp : 12.sp),
//         //         ),
//         //       );
//         //     });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             color: tWhite,
//             // boxShadow: [tBoxShadow],
//             borderRadius: BorderRadius.circular(15)),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               widget.rideData == null
//                   ? Container(
//                       decoration: BoxDecoration(
//                           color: tPrimaryColor, shape: BoxShape.circle),
//                       child: Padding(
//                         padding: EdgeInsets.all(isTab(context) ? 16 : 10.0),
//                         child: _data.cashhMode == 'cash'
//                             ? Image.asset(
//                                 Images.CASHICON,
//                                 scale: isTab(context) ? 2.5 : 3.5,
//                               )
//                             : _data.cashhMode == 'online'
//                                 ? Image.asset(
//                                     Images.QRICON,
//                                     scale: isTab(context) ? 2.5 : 3.8,
//                                   )
//                                 : Image.asset(
//                                     Images.WALLETICON,
//                                     scale: isTab(context) ? 2.5 : 3.5,
//                                   ),
//                       ),
//                     )
//                   : Container(
//                       decoration: BoxDecoration(
//                           color: tPrimaryColor, shape: BoxShape.circle),
//                       child: Padding(
//                         padding: EdgeInsets.all(isTab(context) ? 16 : 10.0),
//                         child:
//                             // _data.cashhMode == 'cash'
//                             widget.rideData['payment_method'] == '1'
//                                 ? Image.asset(
//                                     Images.CASHICON,
//                                     scale: isTab(context) ? 2.5 : 3.5,
//                                   )
//                                 :
//                                 // _data.cashhMode == 'online'
//                                 widget.rideData['payment_method'] == '4'
//                                     ? Image.asset(
//                                         Images.QRICON,
//                                         scale: isTab(context) ? 2.5 : 3.8,
//                                       )
//                                     : Image.asset(
//                                         Images.WALLETICON,
//                                         scale: isTab(context) ? 2.5 : 3.5,
//                                       ),
//                       ),
//                     ),
//               SizedBox(
//                 width: 2.w,
//               ),
//               widget.rideData == null
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         //Change payment method here
//                         // widget.onlinePayment != true
//                         _data.cashhMode == 'cash'
//                             ? Text(
//                                 'Cash mode',
//                                 style: GoogleFonts.mulish(
//                                     color: tBlack,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: isTab(context) ? 9.sp : 12.sp),
//                               )
//                             : _data.cashhMode == 'online'
//                                 ? Text(
//                                     'Online mode',
//                                     style: GoogleFonts.mulish(
//                                         color: tBlack,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize:
//                                             isTab(context) ? 9.sp : 12.sp),
//                                   )
//                                 : Text(
//                                     'Wallet pay',
//                                     style: GoogleFonts.mulish(
//                                         color: tBlack,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize:
//                                             isTab(context) ? 9.sp : 12.sp),
//                                   ),
//                         SizedBox(
//                           height: 0.4.h,
//                         ),
//                         Text(
//                           'Change payment Method',
//                           // style: TextStyle(
//                           //     color: tGray,
//                           //     fontWeight: FontWeight.w500,
//                           //     fontSize: isTab(context) ? 7.sp : 9.sp),
//                           style: GoogleFonts.mulish(
//                               color: tGray,
//                               fontWeight: isTab(context)
//                                   ? FontWeight.w500
//                                   : FontWeight.w600,
//                               fontSize: isTab(context) ? 6.sp : 9.sp),
//                         ),
//                       ],
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         //Change payment method here
//                         // widget.onlinePayment != true
//                         // _data.cashhMode == 'cash'
//                         widget.rideData['payment_method'] == '1'
//                             ? Text(
//                                 'Cash mode',
//                                 style: GoogleFonts.mulish(
//                                     color: tBlack,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: isTab(context) ? 9.sp : 12.sp),
//                               )
//                             :
//                             // _data.cashhMode == 'online'
//                             widget.rideData['payment_method'] == '4'
//                                 ? Text(
//                                     'Online mode',
//                                     style: GoogleFonts.mulish(
//                                         color: tBlack,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize:
//                                             isTab(context) ? 9.sp : 12.sp),
//                                   )
//                                 : Text(
//                                     'Wallet pay',
//                                     style: GoogleFonts.mulish(
//                                         color: tBlack,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize:
//                                             isTab(context) ? 9.sp : 12.sp),
//                                   ),
//                         SizedBox(
//                           height: 0.4.h,
//                         ),
//                         Text(
//                           'Change payment Method',
//                           // style: TextStyle(
//                           //     color: tGray,
//                           //     fontWeight: FontWeight.w500,
//                           //     fontSize: isTab(context) ? 7.sp : 9.sp),
//                           style: GoogleFonts.mulish(
//                               color: tGray,
//                               fontWeight: isTab(context)
//                                   ? FontWeight.w500
//                                   : FontWeight.w600,
//                               fontSize: isTab(context) ? 6.sp : 9.sp),
//                         )
//                       ],
//                     ),
//               Spacer(),
//               (Platform.isIOS)
//                   ? Container()
//                   : Icon(
//                       Icons.keyboard_arrow_right,
//                       size: isTab(context) ? 40 : 30,
//                     )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PayAtDropCard extends StatefulWidget {
//   const PayAtDropCard({
//     Key? key,
//     this.rideData,
//     this.getVechileDetails,
//     this.rideId,
//     this.selectedIndex,
//   }) : super(key: key);
//   final rideData;

//   final getVechileDetails;
//   final rideId;
//   final selectedIndex;
//   @override
//   State<PayAtDropCard> createState() => _PayAtDropCardState();
// }

// class _PayAtDropCardState extends State<PayAtDropCard> {
//   @override
//   Widget build(BuildContext context) {
//     // RideBookingProvidder _data = Provider.of<RideBookingProvidder>(context);
//     return Container(
//       decoration: BoxDecoration(
//           color: tWhite,
//           // boxShadow: [tBoxShadow],
//           borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               decoration:
//                   BoxDecoration(color: tPrimaryColor, shape: BoxShape.circle),
//               child: Padding(
//                 padding: EdgeInsets.all(isTab(context) ? 16 : 10.0),
//                 child: _data.cashhMode == 'cash'
//                     ? Image.asset(
//                         Images.CASHICON,
//                         scale: isTab(context) ? 2.5 : 3.5,
//                       )
//                     : _data.cashhMode == 'online'
//                         ? Image.asset(
//                             Images.QRICON,
//                             scale: isTab(context) ? 2.5 : 3.8,
//                           )
//                         : Image.asset(
//                             Images.WALLETICON,
//                             scale: isTab(context) ? 2.5 : 3.5,
//                           ),
//               ),
//             ),
//             SizedBox(
//               width: 2.w,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //Change payment method here
//                 // widget.onlinePayment != true
//                 _data.cashhMode == 'cash'
//                     ? Text(
//                         'Cash mode',
//                         style: GoogleFonts.mulish(
//                             color: tBlack,
//                             fontWeight: FontWeight.w600,
//                             fontSize: isTab(context) ? 9.sp : 12.sp),
//                       )
//                     : _data.cashhMode == 'online'
//                         ? Text(
//                             'Online mode',
//                             style: GoogleFonts.mulish(
//                                 color: tBlack,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: isTab(context) ? 9.sp : 12.sp),
//                           )
//                         : Text(
//                             'Wallet pay',
//                             style: GoogleFonts.mulish(
//                                 color: tBlack,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: isTab(context) ? 9.sp : 12.sp),
//                           ),
//                 SizedBox(
//                   height: 0.4.h,
//                 ),
//                 Text(
//                   'Change payment Method',
//                   // style: TextStyle(
//                   //     color: tGray,
//                   //     fontWeight: FontWeight.w500,
//                   //     fontSize: isTab(context) ? 7.sp : 9.sp),
//                   style: GoogleFonts.mulish(
//                       color: tGray,
//                       fontWeight:
//                           isTab(context) ? FontWeight.w500 : FontWeight.w600,
//                       fontSize: isTab(context) ? 6.sp : 9.sp),
//                 ),
//               ],
//             ),
//             Spacer(),
//             Icon(
//               Icons.keyboard_arrow_right,
//               size: isTab(context) ? 40 : 30,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
