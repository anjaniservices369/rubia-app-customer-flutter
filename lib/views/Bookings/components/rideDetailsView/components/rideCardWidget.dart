// =============================================================================
// WHAT : Ride summary card.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/constants.dart';
import '../../../../../responsive.dart';
import '../../bookingCardWidget.dart';

// >>> START: RideCardWidget - screen/widget
class RideCardWidget extends StatelessWidget {
  const RideCardWidget({
    Key? key,
    this.rideDetails,
  }) : super(key: key);
  final rideDetails;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: tWhite,
          boxShadow: [tBoxShadow],
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rideDetails['reference_id'].toString(),
                      style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontWeight: FontWeight.w600,
                        fontSize: isTab(context) ? 9.sp : 11.sp,
                      ),
                    ),
                    Spacer(),
                    Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: tgreen),
                        child: Icon(
                          Icons.check,
                          color: tWhite,
                          size: isTab(context) ? 10 : 15,
                        )),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      getStatus(rideDetails['status']),
                      style: GoogleFonts.mulish(
                        color: tgreen,
                        fontWeight: FontWeight.w600,
                        fontSize: isTab(context) ? 9.sp : 11.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                    child: Text(
                  Twl.dateActualFormate(rideDetails['pickup_date']).toString() +
                      ', ' +
                      rideDetails['pickup_time'].toString(),
                  // '20th Dec 2022,'+'09:30 AM',
                  // rideDetails['id'].toString(),
                  style: GoogleFonts.mulish(
                    color: tDarkOrangeColor,
                    fontSize: isTab(context) ? 8.sp : 14.sp,
                    fontWeight: FontWeight.w600,
                    // fontFamily:
                  ),
                )),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTripTypeText(rideDetails['trip_type']),
                      style: GoogleFonts.mulish(
                        color: tDarkOrangeColor,
                        fontSize: isTab(context) ? 8.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        // fontFamily:
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      getRiderTypeText(rideDetails['rider_type']),
                      style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontSize: isTab(context) ? 8.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        // fontFamily:
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 0.9,
            color: tDividerColor,
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          Images.CAR,
                          scale: isTab(context) ? 2 : 3.5,
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          rideDetails['car_model'],
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          style: GoogleFonts.mulish(
                            color: tDarkNavyblue,
                            fontSize: isTab(context) ? 8.sp : 11.sp,
                            fontWeight: FontWeight.w600,
                            // fontFamily:
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          rideDetails['car_type'].toString() == '1'
                              ? '(Automatic)'
                              : '(Manual)',
                          style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: isTab(context) ? 9.sp : 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    rideDetails['car_number'] == null
                        ? Container()
                        : Text(
                            rideDetails['car_number'],
                            style: GoogleFonts.mulish(
                              color: tDarkNavyblue,
                              fontSize: isTab(context) ? 8.sp : 11.sp,
                              fontWeight: FontWeight.w600,
                              // fontFamily:
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: RideCardWidget - screen/widget
