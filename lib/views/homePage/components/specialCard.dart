// =============================================================================
// WHAT : Promotional card.
// NOTES: Visual component.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../responsive.dart';

// >>> START: SpecialCard - screen/widget shell (the visible part is in its State class)
class SpecialCard extends StatefulWidget {
  const SpecialCard({Key? key}) : super(key: key);

  @override
  State<SpecialCard> createState() => _SpecialCardState();
}
// <<< END: SpecialCard - screen/widget shell (the visible part is in its State class)

// >>> START: _SpecialCardState - the data and logic behind its screen
class _SpecialCardState extends State<SpecialCard> {
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
          padding: EdgeInsets.only(left:12),
          child: Container(
            height: MediaQuery.of(context).size.height/5,
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  // var coupon =
                  //     snapshot.data!.details[index];

                  return Image.asset(Images.CARD);
                }),
          ),
        )
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SpecialCardState - the data and logic behind its screen
