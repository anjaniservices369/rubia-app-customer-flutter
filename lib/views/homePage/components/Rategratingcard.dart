// =============================================================================
// WHAT : Rating prompt shown after a ride.
// NOTES: Sends the rating to the server.
// =============================================================================
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/taxiservices/rideservices/riderServices.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../responsive.dart';

// >>> START: RatingCard - screen/widget shell (the visible part is in its State class)
class RatingCard extends StatefulWidget {
  const RatingCard({Key? key, this.rideData}) : super(key: key);
  final rideData;

  @override
  State<RatingCard> createState() => _RatingCardState();
}
// <<< END: RatingCard - screen/widget shell (the visible part is in its State class)

// >>> START: _RatingCardState - the data and logic behind its screen
class _RatingCardState extends State<RatingCard> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
            context,
            BottomNavigation(
              tabIndexId: 0,
            ));
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 15.h, bottom: 3.h, left: 3.w, right: 3.w),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: tWhite,
                      boxShadow: [tBoxShadow]),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/rating.json',
                              height: 25.h,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              'Thank_you_For'.tr,
                              style: GoogleFonts.mulish(
                                  color: tDarkNavyblue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: isTab(context) ? 10.sp : 16.sp),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Center(
                              child: SizedBox(
                                width: isTab(context) ? 40.w : 40.w,
                                child: ButtonWidget(
                                  borderSide: BorderSide(
                                    color: tPrimaryColor,
                                  ),
                                  // borderRadius: BorderRadius.circular(15),
                                  borderRadius: isTab(context) ? 40.0 : 30.0,
                                  color: tPrimaryColor,
                                  child: Text(
                                    "Go Home",
                                    style: GoogleFonts.mulish(
                                      color: tWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 10.sp : 16.sp,
                                    ),
                                  ),
                                  onTap: (startLoading, stopLoading,
                                      btnState) async {
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();

                                    // Twl.navigateTo(context, HomePageView());
                                    // After complete save log and rides collection and remove doc from skipperRequest
                                    RideService().removeDocument(
                                        uid: widget.rideData['userId']
                                            .toString());

                                    // finish(context);
                                    sharedPreferences.remove('pickUpAddress');
                                    sharedPreferences.remove('pickUplat');
                                    sharedPreferences.remove('pickUplng');
                                    sharedPreferences.remove('dropAddress');
                                    sharedPreferences.remove('droplat');
                                    sharedPreferences.remove('droplng');
                                    sharedPreferences.remove('dropPinCode');
                                    Twl.forceNavigateTo(
                                        context,
                                        BottomNavigation(
                                          tabIndexId: 0,
                                        ));
                                    // HomePageView().launch(context, isNewTask: true);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              )
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _RatingCardState - the data and logic behind its screen
