// =============================================================================
// WHAT : TAXI: shows the ride OTP the customer tells the driver at pickup.
// NOTES: Visual component.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../../../responsive.dart';

// >>> START: OTPCard - screen/widget shell (the visible part is in its State class)
class OTPCard extends StatefulWidget {
  const OTPCard({Key? key, this.rideData}) : super(key: key);
  final rideData;
  @override
  State<OTPCard> createState() => _OTPCardState();
}
// <<< END: OTPCard - screen/widget shell (the visible part is in its State class)

// >>> START: _OTPCardState - the data and logic behind its screen
class _OTPCardState extends State<OTPCard> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                  color: tWhite,
                  boxShadow: [tBoxShadow],
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'OTP',
                        style: GoogleFonts.mulish(
                            color: tBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 8.sp : 12.sp),
                      ),
                    ),
                    SizedBox(
                      width: 1.8.w,
                    ),
                    Text(
                      widget.rideData['otp'].toString(),
                      style: GoogleFonts.mulish(
                          color: tBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: isTab(context) ? 10.sp : 17.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _OTPCardState - the data and logic behind its screen
