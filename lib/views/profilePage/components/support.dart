// =============================================================================
// WHAT : Help and customer support screen.
// NOTES: Contact details.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonIconWidget.dart';
import '../../../responsive.dart';
import '../../bottomNavigation.dart/bottomNavigation.dart';
// import 'components/customerSupport.dart';

// >>> START: Support - screen/widget shell (the visible part is in its State class)
class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}
// <<< END: Support - screen/widget shell (the visible part is in its State class)

// >>> START: _SupportState - the data and logic behind its screen
class _SupportState extends State<Support> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
            context,
            BottomNavigation(
              tabIndexId: 2,
            ));
      },
      child: Scaffold(
        backgroundColor: tWhite,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 7,
          automaticallyImplyLeading: false,
          backgroundColor: tYellow,
          title: Text(
            'support'.tr,
            style: GoogleFonts.mulish(
              color: tDarkNavyblue,
              fontSize: isTab(context) ? 10.sp : 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: GestureDetector(
              onTap: () {
                Twl.forceNavigateTo(
                    context,
                    BottomNavigation(
                      tabIndexId: 2,
                    ));
              },
              child: Padding(
                padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                child: BackIconWidget(),
              )),
        ),
        body: CustomerSupport(),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SupportState - the data and logic behind its screen

// >>> START: CustomerSupport - screen/widget shell (the visible part is in its State class)
class CustomerSupport extends StatefulWidget {
  const CustomerSupport({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}
// <<< END: CustomerSupport - screen/widget shell (the visible part is in its State class)

// >>> START: _CustomerSupportState - the data and logic behind its screen
class _CustomerSupportState extends State<CustomerSupport> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2.h,
        ),
        decoration: BoxDecoration(
            boxShadow: [tBoxShadow],
            color: tWhite,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'customer_support'.tr,
              style: GoogleFonts.mulish(
                color: tDarkNavyblue,
                fontSize: isTab(context) ? 9.sp : 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
            GestureDetector(
              onTap: () async {
                await launchURL(CHAT_LINK);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                decoration: BoxDecoration(
                    boxShadow: [tBoxShadow],
                    color: tWhite,
                    border: Border.all(color: tPrimaryColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: GestureDetector(
                  onTap: () async {
                    await launchURL(CHAT_LINK);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        Images.EMAILSUPPORT,
                        scale: isTab(context) ? 2 : 4,
                      ),
                      SizedBox(
                        width: 0.6.w,
                      ),
                      Text(
                        'chat'.tr,
                        style: GoogleFonts.mulish(
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 12.sp : 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: launchURL - launch url
  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
    }
  }
  // <<< END: launchURL - launch url
}
// <<< END: _CustomerSupportState - the data and logic behind its screen
