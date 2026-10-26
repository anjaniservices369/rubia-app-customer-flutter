// =============================================================================
// WHAT : Promotional offer card.
// NOTES: Visual component.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../responsive.dart';

// >>> START: SpecialCard1 - screen/widget shell (the visible part is in its State class)
class SpecialCard1 extends StatefulWidget {
  const SpecialCard1({Key? key}) : super(key: key);

  @override
  State<SpecialCard1> createState() => _SpecialCard1State();
}
// <<< END: SpecialCard1 - screen/widget shell (the visible part is in its State class)

// >>> START: _SpecialCard1State - the data and logic behind its screen
class _SpecialCard1State extends State<SpecialCard1> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Claim_your_Special'.tr,
            style: TextStyle(
                fontSize: isDesktop(context)
                    ? 3.sp
                    : isTab(context)
                        ? 8.sp
                        : 14.sp,
                fontWeight: FontWeight.w700,
                color: tDarkNavyblue),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Container(
            height: MediaQuery.of(context).size.height / 5,
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  // var coupon =
                  //     snapshot.data!.details[index];

                  return Image.asset(Images.CARD1);
                }),
          ),
        )
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SpecialCard1State - the data and logic behind its screen
