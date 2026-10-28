// =============================================================================
// WHAT : Distance and duration card.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/Bookings/components/rideDetailsView/components/completetedbill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/constants.dart';

// >>> START: DistanceAndDurationCardWidget - screen/widget
class DistanceAndDurationCardWidget extends StatelessWidget {
  const DistanceAndDurationCardWidget({
    Key? key,
    this.rideDetails,
  }) : super(key: key);
  final rideDetails;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    double? usageHours = double.tryParse(rideDetails['usage_hours'] ?? '');

    String usageText;

    if (usageHours != null) {
      if (usageHours >= 1) {
        int wholeHours = usageHours.toInt();
        int wholeMinutes = ((usageHours - wholeHours) * 60).toInt();
        if (wholeMinutes > 0) {
          usageText = '$wholeHours hrs $wholeMinutes mins ';
        } else {
          usageText = '$wholeHours hrs';
        }
      } else {
        int usageMinutes = (usageHours * 60).toInt();
        usageText = '$usageMinutes mins ';
      }
    } else {
      usageText = ''; // Handle the case where 'usage_hours' is null
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [tBoxShadow]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      rideDetails['total_distance'].toString(),
                      style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontSize: isTab(context) ? 9.sp : 11.sp,
                        fontWeight: FontWeight.w800,
                        // fontFamily:
                      ),
                    ),
                    Text(
                      ' km',
                      style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontSize: isTab(context) ? 8.sp : 11.sp,
                        fontWeight: FontWeight.w800,
                        // fontFamily:
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'distance'.tr,
                  style: GoogleFonts.mulish(
                    color: tDarkOrangeColor,
                    fontSize: isTab(context) ? 7.sp : 10.sp,
                    fontWeight: FontWeight.w600,
                    // fontFamily:
                  ),
                ),

                // Row(
                //   children: [
                //     rideDetails['final_time'] == null
                //         ? Text(
                //             '0',
                //             style: GoogleFonts.mulish(
                //               color: tWhite,
                //               fontSize: isTab(context) ? 12.sp : 16.sp,
                //               fontWeight: FontWeight.w900,
                //               // fontFamily:
                //             ),
                //           )
                //         : Text(
                //             rideDetails['final_time'].toString(),
                //             style: GoogleFonts.mulish(
                //               color: tWhite,
                //               fontSize: isTab(context) ? 12.sp : 16.sp,
                //               fontWeight: FontWeight.w900,
                //               // fontFamily:
                //             ),
                //           ),
                //     Text(
                //       'mins'.tr,
                //       textAlign: TextAlign.end,
                //       style: GoogleFonts.mulish(
                //         color: tWhite,
                //         fontSize: isTab(context) ? 9.sp : 13.sp,
                //         fontWeight: FontWeight.w700,
                //         // fontFamily:
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            Container(
              height: 8.h,
              width: 0.3.w,
              color: tlightDivider,
            ),
            Column(
              children: [
                rideDetails['usage_hours'] == null
                    ? Container()
                    : Row(
                        children: [
                          Text(
                            usageText,
                            style: GoogleFonts.mulish(
                              color: tDarkNavyblue,
                              fontSize: isTab(context) ? 9.sp : 11.sp,
                              fontWeight: FontWeight.w800,
                              // fontFamily:
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'duration'.tr,
                  style: GoogleFonts.mulish(
                    color: tDarkOrangeColor,
                    fontSize: isTab(context) ? 7.sp : 10.sp,
                    fontWeight: FontWeight.w600,
                    // fontFamily:
                  ),
                ),
                Row(
                  children: [],
                ),
              ],
            ),
            Container(
              height: 8.h,
              width: 0.3.w,
              color: tlightDivider,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  // expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30.0),
                      child: Container(
                          height: 90.h,
                          // height: MediaQuery.of(context).size.height / 1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: CompletedBill(rideDetails: rideDetails))),
                );
              },
              child: Column(
                children: [
                  Text(
                    currencySymbol +
                        ((rideDetails['price_detail']['estimatePrice'] + (rideDetails['cancellation_charges'] ?? 0)).toString()),
                    style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontSize: isTab(context) ? 9.sp : 11.sp,
                      fontWeight: FontWeight.w800,
                      // fontFamily:
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'total_price'.tr,
                        style: GoogleFonts.mulish(
                          color: tDarkOrangeColor,
                          fontSize: isTab(context) ? 7.sp : 10.sp,
                          fontWeight: FontWeight.w600,
                          // fontFamily:
                        ),
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 15,
                            color: tDate,
                          ),
                          SizedBox(height: 0.5.h)
                        ],
                      ),
                    ],
                  ),

                  // Icon(Icons.info,size: isTab(context)?15:18,),

                  // Row(
                  //   children: [
                  //     rideDetails['final_distance'] == null
                  //         ? Text(
                  //             '0',
                  //             style: GoogleFonts.mulish(
                  //               color: tWhite,
                  //               fontSize: isTab(context) ? 12.sp : 16.sp,
                  //               fontWeight: FontWeight.w900,
                  //               // fontFamily:
                  //             ),
                  //           )
                  //         : Text(
                  //             rideDetails['final_distance'].toString(),
                  //             style: GoogleFonts.mulish(
                  //               color: tWhite,
                  //               fontSize: isTab(context) ? 12.sp : 16.sp,
                  //               fontWeight: FontWeight.w900,
                  //               // fontFamily:
                  //             ),
                  //           ),
                  //     Text(
                  //       'km'.tr,
                  //       textAlign: TextAlign.end,
                  //       style: GoogleFonts.mulish(
                  //         color: tWhite,
                  //         fontSize: isTab(context) ? 9.sp : 13.sp,
                  //         fontWeight: FontWeight.w700,
                  //         // fontFamily:
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: DistanceAndDurationCardWidget - screen/widget
