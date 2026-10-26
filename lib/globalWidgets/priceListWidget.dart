// =============================================================================
// WHAT : One row of a price breakdown (label + amount).
// NOTES: Visual component.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart';
import '../responsive.dart';

// >>> START: priceListWidget - screen/widget
class priceListWidget extends StatelessWidget {
  const priceListWidget({
    Key? key,
    required this.title,
    this.value,
  }) : super(key: key);

  final title;
  final value;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(title,
              style: GoogleFonts.mulish(
                color: tSecondaryColor,
                fontWeight: FontWeight.w400,
                fontSize: isTab(context) ? 7.sp : 12.sp,
              )),
          Spacer(),
          Text(" $value",
              style: GoogleFonts.mulish(
                color: tSecondaryColor,
                fontWeight: FontWeight.w500,
                fontSize: isTab(context) ? 7.sp : 12.sp,
              )),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: priceListWidget - screen/widget
