// =============================================================================
// WHAT : Payment success screen.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/homePage/components/rateYourExperienceCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/imageConstant.dart';

// >>> START: PaymentDonePage - screen/widget
class PaymentDonePage extends StatelessWidget {
  const PaymentDonePage({Key? key}) : super(key: key);

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    // expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: RateYourExperienceCardWidget()),
                  );
                },
                child: Image.asset(
                  Images.CONFIRM,
                  scale: isTab(context) ? 2 : 3,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                '₹310',
                style: GoogleFonts.mulish(
                  color: tDarkNavyblue,
                  fontWeight: FontWeight.w700,
                  fontSize: isTab(context) ? 15.sp : 18.sp,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Payment Done',
                style: GoogleFonts.mulish(
                  color: tPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: isTab(context) ? 13.sp : 16.sp,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Your payment is successfully completed',
                style: GoogleFonts.mulish(
                  color: tDarkNavyblue,
                  fontWeight: FontWeight.w600,
                  fontSize: isTab(context) ? 8.sp : 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: PaymentDonePage - screen/widget
