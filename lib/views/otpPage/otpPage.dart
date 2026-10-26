// =============================================================================
// WHAT : OTP screen: enter (or auto-read) the 4-digit code from the SMS and
//        sign in.
// NOTES: Auto-submits when the SMS is read. After sign-in loads the profile and
//        opens the app.
// =============================================================================
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/api_services/otpSmsReader.dart';
import 'package:base_project_flutter/api_services/pushService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/buttonWidget.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';

// >>> START: Otppage - OTP screen: enter or auto-read the SMS code
class Otppage extends StatefulWidget {
  Otppage({
    Key? key,
    this.sessionCode,
    this.mobileNumber,
  }) : super(key: key);

  final sessionCode;
  final mobileNumber;


  @override
  State<Otppage> createState() => _OtppageState();
}
// <<< END: Otppage - OTP screen: enter or auto-read the SMS code

// >>> START: _OtppageState - the data and logic behind its screen
class _OtppageState extends State<Otppage> {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hasError = false;
  var deviceToken;
  late String _sessionCode;
  final OtpSmsReader _smsReader = OtpSmsReader();

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    _sessionCode = widget.sessionCode.toString();
    // 1. Read this phone's notification id for the login request.
    fecthDeviceToken();
    // 2. Listen for the OTP SMS: fill the boxes when it arrives.
    _smsReader.start(onCode: (code) async {
      // The screen may have been closed in the meantime.
      if (!mounted) return;
      // 3. Put the code in the 4 boxes.
      setState(() => _otpCodeController.text = code);
      // 4. Let the boxes show the code for a moment, then sign in by itself.
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      _verifyOtp(() {}, () {});
    });
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _smsReader.stop();
    _otpCodeController.dispose();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: fecthDeviceToken - reads this phone's notification id for the server
  fecthDeviceToken() {
    // OneSignal subscription id; may still be null right after install, in
    // which case PushService sends it later through the `check` endpoint.
    // The server rejects a blank device_token, so login must still work while
    // push is not ready: send a placeholder and let PushService update it later.
    deviceToken = PushService.subscriptionId ?? 'push-unavailable';
  }
  // <<< END: fecthDeviceToken - reads this phone's notification id for the server

  // >>> START: _errorText - chooses the message to show when verification fails
  /// Message for a failed verify/send reply (the reply can be null or not JSON).
  String _errorText(dynamic res) {
    if (res is Map && res['error'] != null) return res['error'].toString();
    return 'Could not verify the code. Please check your connection and retry.';
  }
  // <<< END: _errorText - chooses the message to show when verification fails


  bool _busy = false;

  // >>> START: _verifyOtp - sends the entered OTP to the server, saves the login and opens the app
  /// Verifies the OTP with the server and signs the user in. Called by the Next
  /// button and by the SMS auto-submit.
  Future<void> _verifyOtp(Function startLoading, Function stopLoading) async {
    // 0. Ignore a second tap / auto-submit while one verification is running.
    if (_busy) return;
    setState(() => _busy = true);
    try {
      // 1. Show the spinner on the Next button.
      startLoading();
      // 2. The form checks the customer typed all 4 digits.
      if (_formKey.currentState!.validate()) {
        startLoading();
        // 3. Make sure we have this phone's notification id (or a placeholder).
        fecthDeviceToken();
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        // 4. What the server needs to verify the login:
        //    the mobile number, the id of the SMS session, the code, the phone's
        //    notification id and the device type (1 = Android).
        Map<String, String> params = {
          "contact_no": widget.mobileNumber.toString(),
          "session_code": _sessionCode,
          "otp_code": _otpCodeController.text,
          "device_token": deviceToken.toString(),
          "device_type": "1"
        };
        // 5. Send it to the server.
        var res = await UserAPI().verifyOtp(context, params);
        if (res != null && res['status'] == 'OK') {
          // 6. Code accepted: save the login key and tell the server this
          //    phone's notification id.
          sharedPreferences.setString("authCode", res['auth_code']);
          PushService.syncToken();
          // 7. Load the customer's profile with the new login key.
          var check = await UserAPI().checkApi(res['auth_code']);
          if (check != null && check['status'] == 'OK') {
            // 8. Remember the basics on the phone for the other screens.
            sharedPreferences.setString(
                "contact_no", check['detail']['contact_no'].toString());
            sharedPreferences.setString(
                "userId", check['detail']['id'].toString());
            sharedPreferences.setInt('USER_ID', check['detail']['id']);
            sharedPreferences.setString(
                "username", check['detail']['username'].toString());
            sharedPreferences.setString('userRole', check['detail']['user_role']);
            if (check['detail']['email'] != null) {
              sharedPreferences.setString(
                  "email", check['detail']['email'].toString());
            }
            if (check['detail']['gender'] != null) {
              sharedPreferences.setString(
                  "gender", check['detail']['gender'].toString());
            }
            if (check['detail']['profile_image'] != null) {
              sharedPreferences.setString(
                  "profile_image", check['detail']['profile_image'].toString());
            }
            if (check['detail']['date_of_birth'] != null) {
              sharedPreferences.setString(
                  "date_of_birth", check['detail']['date_of_birth'].toString());
            }
            // 9. Where to go next: always straight to the app, replacing
            //    login/OTP underneath so "back" from Home never returns to them.
            //    A brand-new customer (no email yet) completes their profile
            //    as a chain of bottom sheets opened on top of Home, instead of
            //    a separate full-screen stop.
            Twl.forceNavigateTo(
                context,
                BottomNavigation(
                  tabIndexId: 0,
                  showRegistrationSheet: check['detail']['email'] == null,
                ));
            setState(() {
              stopLoading();
            });
          } else {
            // The profile could not be loaded: show the reason.
            stopLoading();
            return Twl.createAlert(context, 'Oops', _errorText(res));
          }
          stopLoading();
        } else {
          // Wrong or expired code (or no connection): show the reason.
          stopLoading();
          return Twl.createAlert(context, 'Oops', _errorText(res));
        }
        stopLoading();
      } else {
        // The form is incomplete: just stop the spinner.
        stopLoading();
      }
    } finally {
      // Always allow another attempt afterwards.
      if (mounted) setState(() => _busy = false);
    }
  }
  // <<< END: _verifyOtp - sends the entered OTP to the server, saves the login and opens the app

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tDarkNavyblue,
        body: PopScope(
          canPop: true,
          child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Image.asset(
                            Images.LOGO,
                            scale: 4,
                            // height: isTab(context) ? 17.h : 13.h,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: [tBoxShadow],
                          color: tWhite,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 1.5.h,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Twl.navigateBack(context);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: isTab(context) ? 6 : 4,
                                            horizontal: isTab(context) ? 6 : 4),
                                        decoration: BoxDecoration(
                                            boxShadow: [tBoxShadow],
                                            color: tWhite,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Center(
                                            child: Image.asset(
                                          Images.BACK_ICON,
                                          scale: isTab(context) ? 2.5 : 3.4,
                                        )))),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  'otp_verification'.tr,
                                  style: GoogleFonts.mulish(
                                    color: tDarkNavyblue,
                                    fontWeight: FontWeight.w800,
                                    fontSize: isTab(context) ? 15.sp : 20.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.5.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'enter_otp'.tr,
                                    style: TextStyle(
                                      color: tDarkOrangeColor,
                                      fontSize: isTab(context) ? 10.sp : 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              widget.mobileNumber?.toString() ?? '',
                              style: TextStyle(
                                color: tDarkNavyblue,
                                fontWeight: FontWeight.w700,
                                fontSize: isTab(context) ? 10.sp : 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTab(context) ? 100 : 25,
                              ),
                              child: PinCodeTextField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                //backgroundColor: Colors.white,
                                appContext: context,
                                textStyle: TextStyle(
                                  color: tDarkNavyblue,
                                  fontSize: isTab(context) ? 9.sp : 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                pastedTextStyle: TextStyle(
                                  color: tDarkNavyblue,
                                  fontWeight: FontWeight.bold,
                                ),

                                length: 4,
                                obscureText: false,
                                obscuringCharacter: '*',

                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,
                                validator: (v) {
                                  if (v == null || v.length != 4) {
                                    return 'otp_length_not_match'.tr;
                                  }
                                  return null;
                                },
                                pinTheme: PinTheme(
                                  borderWidth: 1,
                                  shape: PinCodeFieldShape.box,
                                  activeColor: Colors.transparent,
                                  selectedColor: Colors.transparent,
                                  selectedFillColor: tBackground,
                                  inactiveFillColor: tBackground,
                                  inactiveColor: tDarkNavyblue,
                                  borderRadius: BorderRadius.circular(12),
                                  fieldHeight: isTab(context) ? 10.w : 15.w,
                                  fieldWidth: isTab(context) ? 10.w : 15.w,
                                  activeFillColor:
                                      hasError ? Colors.white : tBackground,
                                ),
                                cursorColor: Colors.black,
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,
                                //errorAnimationController: errorController,
                                controller: _otpCodeController,
                                keyboardType: TextInputType.number,
                                // boxShadows: [tBoxShadow],
                                onCompleted: (v) {
                                  _verifyOtp(() {}, () {});
                                },
                                onChanged: (value) {},
                                beforeTextPaste: (text) {
                                  return true;
                                },
                              ),
                            ),

                            SizedBox(
                              height: 1.7.h,
                            ),
                            if (_busy)
                              Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 3, color: tPrimaryColor),
                                ),
                              ),
                            //       ResendCodeButton(
                            //         onTap: () async {
                            //           if (_resendTimer == 0) {
                            //             Map<String, String> param = {
                            //               'contact_no':
                            //                   widget.mobileNumber.toString(),
                            //             };
                            //             var res = await UserAPI().sendOtp(
                            //               context,
                            //               param,
                            //             );
                            //             print(res);
                            //             if (res != null &&
                            //                 res['status'] == 'OK') {
                            //               Twl.navigateTo(
                            //                   context,
                            //                   Otppage(
                            //                     mobileNumber: widget
                            //                         .mobileNumber
                            //                         .toString(),
                            //                     sessionCode: res['details']
                            //                         ['Details'],
                            //                   ));
                            //             }
                            //           }
                            //           // Handle resend code functionality here
                            //           _startResendTimer();
                            //         },
                            //         initialTimer: _resendTimer,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ArgonTimerButton(
                                    elevation: 0,
                                    initialTimer: 30,
                                    height: isTab(context) ? 50 : 50,
                                    width: isTab(context) ? (70) : 70.w,
                                    borderRadius: isTab(context) ? 90 : 10,
                                    color: tWhite,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Don\'t receive the code?',
                                          textAlign: TextAlign.center,
                                          // maxLines: 1,
                                          style: GoogleFonts.mulish(
                                            color: tBlack,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                isTab(context) ? 8.sp : 10.sp,
                                          ),
                                        ),
                                        Text(
                                          ' Resend (30s)',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.mulish(
                                            color: tYellow,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                isTab(context) ? 8.sp : 10.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    loader: (timeLeft) {
                                      return Text(
                                        "$timeLeft",
                                        style: GoogleFonts.mulish(
                                          color: tBlack,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              isTab(context) ? 8.sp : 12.sp,
                                        ),
                                      );
                                    },
                                    onTap: (startTimer, btnState) async {
                                      if (btnState == ArgonButtonState.idle) {
                                        startTimer(30);
                                        Map<String, String> param = {
                                          'contact_no':
                                              widget.mobileNumber.toString(),
                                        };
                                        var res = await UserAPI().sendOtp(
                                          context,
                                          param,
                                        );
                                        if (!mounted) return;
                                        if (res != null &&
                                            res['status'] == 'OK') {
                                          setState(() {
                                            _sessionCode = res['details']
                                                    ['Details']
                                                .toString();
                                            _otpCodeController.clear();
                                          });
                                        } else {
                                          Twl.createAlert(
                                            context,
                                            'Oops',
                                            _errorText(res),
                                          );
                                        }
                                      }
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: tDefaultPadding * 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                  width: isTab(context) ? 50.w : 60.w,
                                  height: isTab(context) ? 6.h : 7.h,
                                  child: ButtonWidget(
                                      borderSide: BorderSide(
                                        color: tPrimaryColor,
                                      ),
                                      color: tPrimaryColor,
                                      child: Text(
                                        'next'.tr,
                                        style: GoogleFonts.mulish(
                                          color: tWhite,
                                          fontWeight: FontWeight.w800,
                                          fontSize:
                                              isTab(context) ? 10.sp : 16.sp,
                                        ),
                                      ),
                                      borderRadius: 15.0,
                                      onTap: (startLoading, stopLoading,
                                          btnState) =>
                                          _verifyOtp(startLoading, stopLoading),
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: isTab(context)
                                    ? tDefaultPadding
                                    : tDefaultPadding / 2),
                          ],
                        ),
                      ),
                    ),
                  ])),
        ));
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _OtppageState - the data and logic behind its screen
