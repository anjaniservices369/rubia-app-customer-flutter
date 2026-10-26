// =============================================================================
// WHAT : First-run welcome screen with the 'Get Started' button.
// NOTES: Shown only when nobody is logged in. One screen (no stacked sheets).
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/views/logiPage/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';

// >>> START: OnboardingPage - screen/widget shell (the visible part is in its State class)
class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}
// <<< END: OnboardingPage - screen/widget shell (the visible part is in its State class)

// >>> START: _OnboardingPageState - the data and logic behind its screen
class _OnboardingPageState extends State<OnboardingPage> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Twl.willpopAlert(context);
      },
      child: Scaffold(
        backgroundColor: tDarkNavyblue,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 42.h,
                    width: 90.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 24, 24, 28),
                decoration: BoxDecoration(
                  color: tWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _bullet(
                      context,
                      'Navigate with Ease, Select Your Location, Book Your Ride!',
                    ),
                    SizedBox(height: 16),
                    _bullet(
                      context,
                      'Empowering Journeys with the Elite Get the Best Drivers, Elevate Your Ride!',
                    ),
                    SizedBox(height: 16),
                    _bullet(
                      context,
                      'Rev up and Ride, Get Set with Your Car, Let the Journey Begin!',
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Twl.navigateTo(context, LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: isTab(context) ? 7.sp : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: _bullet - one welcome line
  Widget _bullet(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            Icons.fiber_manual_record,
            size: isTab(context) ? 12 : 12,
            color: tDarkNavyblue,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: tDarkOrangeColor,
              height: 1.4,
              fontSize: isTab(context) ? 8.sp : 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  // <<< END: _bullet - one welcome line
}
// <<< END: _OnboardingPageState - the data and logic behind its screen
