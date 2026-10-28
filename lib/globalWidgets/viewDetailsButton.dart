// =============================================================================
// WHAT : The "View full details" button at the bottom of every booking card.
// NOTES: Looks like a button; the tap itself is handled by the card around it (the whole card opens the details),
//        unless [onTap] is given.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:base_project_flutter/constants/constants.dart';

// >>> START: ViewDetailsButton - the button at the bottom of a booking card
class ViewDetailsButton extends StatelessWidget {
  const ViewDetailsButton({Key? key, this.onTap, this.label = 'View full details'}) : super(key: key);
  final VoidCallback? onTap;
  final String label;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.3.h),
      decoration: BoxDecoration(
        color: tPrimaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.mulish(color: tWhite, fontWeight: FontWeight.w700, fontSize: 12.sp),
          ),
          SizedBox(width: 2.w),
          Icon(Icons.arrow_forward, size: 18, color: tWhite),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.only(top: 0.5.h),
      child: onTap == null ? button : GestureDetector(onTap: onTap, child: button),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: ViewDetailsButton - the button at the bottom of a booking card
