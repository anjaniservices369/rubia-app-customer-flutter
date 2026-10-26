// =============================================================================
// WHAT : Round back-arrow button used in screen headers.
// NOTES: Visual component only.
// =============================================================================
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/imageConstant.dart';
import '../responsive.dart';

// >>> START: BackIconWidget - screen/widget
class BackIconWidget extends StatelessWidget {
  const BackIconWidget({
    Key? key,
  }) : super(key: key);

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: isTab(context) ? 7 : 6,
            horizontal: isTab(context) ? 7 : 7),
        decoration: BoxDecoration(
            boxShadow: [tBoxShadow],
            color: tWhite,
            borderRadius: BorderRadius.circular(7)),
        child: Center(
            child: Image.asset(
          Images.BACK_ICON,
          scale: isTab(context) ? 2.5 : 3,
        )));
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: BackIconWidget - screen/widget
