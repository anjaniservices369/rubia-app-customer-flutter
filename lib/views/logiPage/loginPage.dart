// =============================================================================
// WHAT : Login screen, the first screen for a signed-out customer: logo and
//        welcome line, mobile number and terms; the server sends an OTP SMS.
// NOTES: On success moves to the OTP screen. (It replaces the old separate
//        "Get Started" welcome screen.)
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/buttonWidget.dart';
import '../../globalWidgets/legalDocumentPage.dart';
import '../../globalWidgets/textformfieldWidget.dart';
import '../../responsive.dart';
import '../otpPage/otpPage.dart';

// >>> START: LoginScreen - login screen: mobile number and terms
class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
// <<< END: LoginScreen - login screen: mobile number and terms

// >>> START: _LoginScreenState - the data and logic behind its screen
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernumbercontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  late final TapGestureRecognizer _termsRecognizer;

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        LegalDocumentPage.open(
            context, LegalDocumentPage.terms, 'Terms and Conditions');
      };
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _termsRecognizer.dispose();
    _usernumbercontroller.dispose();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.LOGO,
                        scale: 4,
                      ),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Book a driver or a ride in minutes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.mulish(
                            color: tWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 10.sp : 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: tWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [tBoxShadow],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'login'.tr,
                                style: GoogleFonts.mulish(
                                  color: tDarkNavyblue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isTab(context) ? 15.sp : 20.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'mobile_number'.tr,
                                  style: GoogleFonts.mulish(
                                    color: tDarkOrangeColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isTab(context) ? 16.sp : 15.sp,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                TextFormFieldWidgets(
                                  validator: (value) {
                                    final text = value ?? '';
                                    final RegExp regex = RegExp(r'^[6-9]\d{9}$');
                                    if (text.isEmpty) {
                                      return 'mobile_number_can\'t_be_empty'.tr;
                                    } else if (text.length != 10) {
                                      return 'mobile_number_must_be_10_digits'.tr;
                                    } else if (!regex.hasMatch(text)) {
                                      return 'invalid_number'.tr;
                                    }
                                    return null;
                                  },
                                  inputFormater: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]"),
                                    ),
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  keyboardTyp: TextInputType.number,
                                  hinttext: 'enter_mobile_number'.tr,
                                  hintStyl: TextStyle(color: tDarkNavyblue),
                                  controller: _usernumbercontroller,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              SizedBox(width: 2.w, height: 1.h),
                              Checkbox(
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    width: 1.0,
                                    color: tPrimaryColor,
                                  ),
                                ),
                                focusColor: tGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.80)),
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                                activeColor: tPrimaryColor,
                                checkColor: Colors.white,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'i_agree_to_the'.tr,
                                    style: GoogleFonts.mulish(
                                      color: tDarkOrangeColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTab(context) ? 7.sp : 10.sp,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'terms_conditions'.tr,
                                        style: GoogleFonts.mulish(
                                          color: tPrimaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              isTab(context) ? 7.sp : 10.sp,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: _termsRecognizer,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: tDefaultPadding * 3),
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
                                  borderRadius: 14.0,
                                  color: tPrimaryColor,
                                  textcolor: Colors.black,
                                  child: Text(
                                    'login'.tr,
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      color: tWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          isTab(context) ? 10.sp : 16.sp,
                                    ),
                                  ),
                                  onTap: (startLoading, stopLoading,
                                      btnState) async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    if (!isChecked) {
                                      _showDialog(context);
                                      return;
                                    }
                                    startLoading();
                                    try {
                                      Map<String, String> param = {
                                        'contact_no':
                                            _usernumbercontroller.text,
                                      };
                                      var res =
                                          await UserAPI().sendOtp(context, param);
                                      if (!mounted) return;
                                      if (res != null &&
                                          res['status'] == 'OK') {
                                        Twl.navigateTo(
                                          context,
                                          Otppage(
                                            mobileNumber:
                                                _usernumbercontroller.text,
                                            sessionCode: res['details']
                                                ['Details'],
                                          ),
                                        );
                                      } else {
                                        Twl.createAlert(
                                          context,
                                          'Oops',
                                          res == null
                                              ? 'Unable to send OTP. Please check your connection and retry.'
                                              : (res['error'] ??
                                                      'OTP failed. Please retry.')
                                                  .toString(),
                                        );
                                      }
                                    } finally {
                                      stopLoading();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: isTab(context)
                                ? tDefaultPadding
                                : tDefaultPadding / 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _LoginScreenState - the data and logic behind its screen

// >>> START: _showDialog - shows dialog
void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('alert'.tr),
        content: Text('please_select_terms_conditions'.tr),
        actions: <Widget>[
          TextButton(
            child: Text('ok'.tr),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
// <<< END: _showDialog - shows dialog
