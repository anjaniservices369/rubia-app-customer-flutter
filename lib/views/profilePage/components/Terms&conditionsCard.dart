// =============================================================================
// WHAT : Terms and conditions text.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../globalWidgets/legalDocumentPage.dart';
import '../../../responsive.dart';

// >>> START: TermsConditionsCard - screen/widget shell (the visible part is in its State class)
class TermsConditionsCard extends StatefulWidget {
  const TermsConditionsCard({Key? key}) : super(key: key);

  @override
  State<TermsConditionsCard> createState() => _TermsConditionsCardState();
}
// <<< END: TermsConditionsCard - screen/widget shell (the visible part is in its State class)

// >>> START: _TermsConditionsCardState - the data and logic behind its screen
class _TermsConditionsCardState extends State<TermsConditionsCard> {

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.5.w),
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.5.w),
      decoration: BoxDecoration(
          color: tWhite,
          boxShadow: [tBackbtnBoxShadow],
          borderRadius: BorderRadiusDirectional.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                Images.PRIVACT_POLICY,
                scale: isTab(context) ? 3 : 3.5,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => LegalDocumentPage.open(
                          context, LegalDocumentPage.privacy, "Privacy Policy"),
                      child: Text(
                        "Privacy_Policy".tr,
                        style: TextStyle(
                            color: tDarkOrangeColor,
                            fontSize: isTab(context) ? 8.sp : 10.sp),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Image.asset(
                Images.TERMS_CONDITIONS,
                scale: isTab(context) ? 3 : 3.5,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      // onTap: () {
                      //   Twl.forceNavigateTo(context, PqymentMethod());
                      // },
                      onTap: () => LegalDocumentPage.open(
                          context, LegalDocumentPage.terms, "Terms and Conditions"),
                      child: Text(
                        'terms_conditions'.tr,
                        style: TextStyle(
                            color: tDarkOrangeColor,
                            fontSize: isTab(context) ? 8.sp : 10.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Image.asset(
                Images.REFUND_POLICY,
                scale: isTab(context) ? 2.7 : 3.7,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      // onTap: () {
                      //   Twl.forceNavigateTo(context, PaymentSelection());
                      // },
                      onTap: () => LegalDocumentPage.open(
                          context, LegalDocumentPage.refund, "Refund Policy"),
                      child: Text(
                        "Cancellation & Refund Policy".tr,
                        style: TextStyle(
                            color: tDarkOrangeColor,
                            fontSize: isTab(context) ? 8.sp : 10.sp),
                      ),
                    )
                  ],
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
// <<< END: _TermsConditionsCardState - the data and logic behind its screen
