// =============================================================================
// WHAT : INACTIVE: whole file is commented out.
// NOTES: Safe to delete.
// =============================================================================

// import 'package:base_project_flutter/api_services/ApiHelper.dart';
// import 'package:base_project_flutter/constants/apiConstants.dart';
// import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../constants/constants.dart';
// import '../../../responsive.dart';


// class InvoiceCardWidget extends StatelessWidget {
//   const InvoiceCardWidget({
//     Key? key,
//     this.rideDetails,
//   }) : super(key: key);
//   final rideDetails;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             // Twl.navigateTo(context, BookRideView());
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: isTab(context) ? 12.w : 9.w, vertical: 3.8.w),
//             decoration: BoxDecoration(
//                 color: tWhite,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [tBoxShadow]),
//             child: Row(
//               children: [
//                 Image.asset(
//                   getStatusIcon(rideDetails['status']),
//                   scale: isTab(context) ? 1 : 2,
//                 ),
//                 SizedBox(
//                   width: 2.w,
//                 ),
//                 Text(
//                   getStatus(rideDetails['status']).toString(),
//                   style: GoogleFonts.mulish(
//                     color: getStatusColor(rideDetails['status']),
//                     fontSize: isTab(context) ? 9.sp : 12.sp,
//                     fontWeight: FontWeight.w600,
//                     // fontFamily:
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // SizedBox(width: 2.w,),
//         Spacer(),
//         GestureDetector(
//           onTap: rideDetails['status'] == STATUS_COMEPLTED_PAID
//               ? () async {
//                   var headers = await ApiHelper().getHeader(context);
//                   print(
//                     apiBaseUrl +
//                         DOWNLOAD_INNVOICE +
//                         headers['auth_code'] +
//                         '&ride_id=' +
//                         rideDetails['id'].toString(),
//                   );
//                   launch(
//                     apiBaseUrl +
//                         DOWNLOAD_INNVOICE +
//                         headers['auth_code'] +
//                         '&ride_id=' +
//                         rideDetails['id'].toString(),
//                   );
//                 }
//               : () async {
//                   Twl.createAlert(context, 'Oops',
//                       'Invoice available after ride completed');
//                 },
//           child: Container(
//             padding: EdgeInsets.symmetric(
//                 vertical: 2.3.w, horizontal: isTab(context) ? 5.w : 3.w),
//             decoration: BoxDecoration(
//                 color: tWhite,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [tBoxShadow]),
//             child: Row(
//               children: [
//                 Container(
//                     padding: EdgeInsets.all(isTab(context) ? 10 : 5),
//                     decoration: BoxDecoration(
//                         color: Colors.black, shape: BoxShape.circle),
//                     child: Icon(
//                       Icons.download,
//                       color: tWhite,
//                       size: isTab(context) ? 40 : 18,
//                     )),
//                 SizedBox(
//                   width: 2.w,
//                 ),
//                 Text(
//                   'Download\nInvoice',
//                   maxLines: 2,
//                   style: GoogleFonts.mulish(
//                     color: tBlack,
//                     fontSize: isTab(context) ? 10.sp : 10.sp,
//                     fontWeight: FontWeight.w700,
//                     // fontFamily:
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
