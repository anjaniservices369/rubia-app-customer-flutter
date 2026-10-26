// =============================================================================
// WHAT : Add an emergency contact.
// NOTES: Server: add-emergency-contact.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/TextFieldWidgets.dart';
import 'package:base_project_flutter/globalWidgets/TextFildTital.dart';
import 'package:base_project_flutter/globalWidgets/button.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// >>> START: AddContact - screen/widget shell (the visible part is in its State class)
class AddContact extends StatefulWidget {
  AddContact({
    Key? key,
    this.lastName,
    this.Email,
    this.DateOfBirth,
    this.gender,
    this.address,
    this.allContacts,
  }) : super(key: key);
  var firstName;
  var lastName;
  var Email;
  final DateOfBirth;
  var gender;
  var address;
  final allContacts;

  @override
  _AddContactState createState() => _AddContactState();
}
// <<< END: AddContact - screen/widget shell (the visible part is in its State class)

// >>> START: _AddContactState - the data and logic behind its screen
class _AddContactState extends State<AddContact> {
  @override
  // final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _relationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = new GlobalKey<FormState>();
  // >>> START: build - draws this screen/widget on the display
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 1.7.h),
                  Text(
                    'Add_Emergency_Contact'.tr,
                    style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontWeight: FontWeight.w800,
                      fontSize: isTab(context) ? 10.sp : 20.sp,
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                  TextFildTital(
                    text: 'phone_number'.tr,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  TextFieldWidgets(
                    validator: (value) {
                      final RegExp regex = RegExp(r'^[6-9]');
                      if (value!.isEmpty) {
                        return 'mobile_number_can\'t_be_empty'.tr;
                        //
                      } else if (value.length != 10 && value.length < 10) {
                        return 'mobile_number_must_be_10_digits'.tr;
                      } else if (!regex.hasMatch(value)) {
                        return 'invalid_number'.tr;
                      } else if (widget.allContacts != null &&
                          widget.allContacts.any((details) {
                            return details['phone_number'].toString() ==
                                value;
                          })) {
                        return 'Phone Number exists'.tr;
                      }
                      return null;
                    },
                    inputFormater: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(
                        "[0-9]",
                      )),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardTyp: TextInputType.number,
                    hinttext: 'Eg : XXXXXXXXX'.tr,
                    controller: _phoneController,
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: Container(
                      width: isTab(context) ? 50.w : 50.w,
                      height: isTab(context) ? 6.h : 7.h,
                      child: Button(
                        color: tPrimaryColor,
                        textcolor: tWhite,
                        bottonText: 'Save'.tr,
                        borderSide: BorderSide(
                          color: tPrimaryColor,
                        ),
                        onTap: (startLoading, stopLoading, btnState) async {
                          startLoading();

                          if (_formKey.currentState!.validate()) {
                            Map<String, String> param = {
                              'phone_number': _phoneController.text,
                            };
                            var res = await UserAPI()
                                .addEmergencyContacts(context, param);
                            if (res != null && res['status'] == 'OK') {
                              Twl.navigateBack(context);
                            } else {
                              stopLoading();
                              Twl.createAlert(
                                  context, 'oops'.tr, res['error'].toString());
                              stopLoading();
                            }
                            stopLoading();
                          } else {
                            stopLoading();
                          }
                          stopLoading();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
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
// <<< END: _AddContactState - the data and logic behind its screen
