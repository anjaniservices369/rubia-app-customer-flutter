// =============================================================================
// WHAT : Lets a new customer enter a referral code.
// NOTES: Gives the referrer a reward.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../globalWidgets/textformfieldWidget.dart';
import 'EnableLocationView.dart';

// >>> START: ReferalCardView - screen/widget shell (the visible part is in its State class)
class ReferalCardView extends StatefulWidget {
  const ReferalCardView({
    Key? key,
  }) : super(key: key);

  @override
  State<ReferalCardView> createState() => _ReferalCardViewState();
}
// <<< END: ReferalCardView - screen/widget shell (the visible part is in its State class)

// >>> START: _ReferalCardViewState - the data and logic behind its screen
class _ReferalCardViewState extends State<ReferalCardView> {
  // final TextEditingController _referralCodecontroller;
  final _formKey = new GlobalKey<FormState>();

  final TextEditingController _referralCodecontroller = TextEditingController();

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
              // height: 40.h,

              // MediaQuery.of(context).size.height / 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                    color: tWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [tBoxShadow]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(height: 1.7.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // GestureDetector(
                            //     onTap: () {
                            //       Twl.willpopAlert(context);
                            //     },
                            //     child: BackIconWidget()),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'referral_code'.tr,
                              style: GoogleFonts.mulish(
                                color: tDarkNavyblue,
                                fontWeight: FontWeight.w800,
                                fontSize: isTab(context) ? 10.sp : 20.sp,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              Twl.navigateBack(context);
                              showModalBottomSheet(
                                isScrollControlled: true,
                                // expand: false,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    child: EnableLocationView()),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  'skip'.tr,
                                  style: TextStyle(
                                    color: tPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTab(context) ? 10.sp : 12.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: tPrimaryColor,
                                )
                              ],
                            ),
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
                            'enter_refer_code'.tr,
                            style: TextStyle(
                              color: tDarkOrangeColor,
                              fontSize: isTab(context) ? 9.sp : 11.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.6.h,
                    ),
                    TextFormFieldWidgets(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'referral_empty'.tr;
                          //
                        }
                      },
                      keyboardTyp: TextInputType.number,
                      hinttext: 'enter_code'.tr,
                      controller: _referralCodecontroller,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(height: tDefaultPadding * 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SizedBox(
                          width: isTab(context) ? 50.w : 50.w,
                          height: isTab(context) ? 6.h : 7.h,
                          child: ButtonWidget(
                              borderSide: BorderSide(
                                color: tPrimaryColor,
                              ),
                              // borderRadius: BorderRadius.circular(15),
                              borderRadius: 15.0,
                              color: tPrimaryColor,
                              textcolor: tWhite,
                              child: Text(
                                'submit'.tr,
                                style: TextStyle(
                                    letterSpacing: 1,
                                    color: tWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTab(context) ? 10.sp : 16.sp),
                              ),
                              onTap:
                                  (startLoading, stopLoading, btnState) async {
                                startLoading();
                                if (_formKey.currentState!.validate()) {

                                  Map<String, String> param = {
                                    "referal_code": _referralCodecontroller.text
                                  };
                                  var res = await UserAPI()
                                      .applyReferral(context, param);
                                  if (res != null && res['status'] == 'OK') {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      // expand: false,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: EnableLocationView()),
                                    );
                                  } else {
                                    stopLoading();
                                    Twl.createAlert(context, 'oops'.tr,
                                        res['error'].toString());
                                    stopLoading();
                                  }
                                  stopLoading();
                                } else {
                                  stopLoading();
                                  // return _showDialog(context);
                                }
                                stopLoading();
                              }),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: isTab(context)
                            ? tDefaultPadding
                            : tDefaultPadding / 2),
                  ],
                ),
              )),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _ReferalCardViewState - the data and logic behind its screen
