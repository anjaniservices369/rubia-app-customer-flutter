// =============================================================================
// WHAT : First-time profile form: name, email. Shown as a bottom sheet on top
//        of Home right after a brand-new customer verifies their OTP, chained
//        into the referral-code and enable-location sheets that follow it.
// NOTES: Saved with update-profile.
// =============================================================================
import 'package:base_project_flutter/views/PersonalDetails/components/referalCardView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/buttonWidget.dart';
import 'package:base_project_flutter/globalWidgets/textformfieldWidget.dart';
import 'package:sizer/sizer.dart';

import '../../responsive.dart';

// >>> START: PersonalDetails - screen/widget shell (the visible part is in its State class)
class PersonalDetails extends StatefulWidget {
  PersonalDetails({Key? key, this.details}) : super(key: key);
  var details;

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}
// <<< END: PersonalDetails - screen/widget shell (the visible part is in its State class)

// >>> START: _PersonalDetailsState - the data and logic behind its screen
class _PersonalDetailsState extends State<PersonalDetails> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailaddressController = TextEditingController();

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    if (widget.details != null) {
      _firstNameController.text = widget.details['first_name'].toString();
      _emailaddressController.text = widget.details['email'].toString();
    }
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  final _formKey = GlobalKey<FormState>();

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: tWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [tBoxShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.7.h),
                  Text(
                    'personal_details'.tr,
                    style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontWeight: FontWeight.w800,
                      fontSize: isTab(context) ? 10.sp : 20.sp,
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                  Text(
                    'Full_name'.tr,
                    style: TextStyle(
                        color: tDarkOrangeColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp),
                  ),
                  SizedBox(height: 1.h),
                  TextFormFieldWidgets(
                    style: TextStyle(fontWeight: FontWeight.w600),
                    controller: _firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'first_name_empty'.tr;
                      } else {
                        return null;
                      }
                    },
                    keyboardTyp: TextInputType.text,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                    fillcolor: tBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hinttext: 'enter_full_name'.tr,
                    hintStyl: TextStyle(
                        color: tGray,
                        fontSize: isTab(context) ? 10.sp : 13.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'email'.tr,
                    style: TextStyle(
                        color: tDarkOrangeColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp),
                  ),
                  SizedBox(height: 1.h),
                  TextFormFieldWidgets(
                    style: TextStyle(fontWeight: FontWeight.w600),
                    controller: _emailaddressController,
                    keyboardTyp: TextInputType.text,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                    fillcolor: tBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hinttext: 'enter_email'.tr,
                    hintStyl: TextStyle(
                        color: tGray,
                        fontSize: isTab(context) ? 10.sp : 13.sp,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                        return 'enter_correct_email'.tr;
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: SizedBox(
                      width: isTab(context) ? 50.w : 50.w,
                      height: isTab(context) ? 6.h : 7.h,
                      child: ButtonWidget(
                        borderSide: BorderSide(
                          color: tPrimaryColor,
                        ),
                        color: tPrimaryColor,
                        borderRadius: 15.0,
                        child: Text(
                          'next'.tr,
                          style: TextStyle(
                              letterSpacing: 1,
                              color: tWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: isTab(context) ? 10.sp : 16.sp),
                        ),
                        onTap: (startLoading, stopLoading, btnState) async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, String> param = {
                              "first_name": _firstNameController.text,
                              "email": _emailaddressController.text,
                            };
                            var res =
                                await UserAPI().personalDetails(context, param);
                            if (res != null && res['status'] == 'OK') {
                              Twl.navigateBack(context);
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: false,
                                  enableDrag: false,
                                  builder: (context) => ReferalCardView());
                            } else {
                              Twl.createAlert(
                                  context, 'Oops', res['error'].toString());
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          isTab(context) ? tDefaultPadding : tDefaultPadding / 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _PersonalDetailsState - the data and logic behind its screen
