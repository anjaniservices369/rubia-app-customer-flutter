// =============================================================================
// WHAT : Small caption shown above a text box.
// NOTES: Visual component only.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../constants/constants.dart';
import '../responsive.dart';

// >>> START: TextFildTital - screen/widget
class TextFildTital extends StatelessWidget {
  const TextFildTital({
    Key? key,
    this.text,
  }) : super(key: key);

  final text;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.mulish(
          fontWeight: FontWeight.w700,
          color: tSecondaryColor,
          fontSize: isTab(context) ? 10.sp : 12.sp),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: TextFildTital - screen/widget
