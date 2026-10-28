// =============================================================================
// WHAT : First-time profile form: name and email (required), plus an optional
//        photo, gender, date of birth and referral code.
//        Shown as a bottom sheet on top of Home right after a brand-new
//        customer verifies their OTP; on success the emergency contacts
//        screen follows, then Home with the enable-location sheet.
// NOTES: Saved with update-profile; the photo is uploaded with media/upload and
//        saved with update-profile-pic; the referral code (if typed) with
//        apply-referral.
// =============================================================================
import 'dart:io';

import 'package:base_project_flutter/api_services/mediaApi.dart';
import 'package:base_project_flutter/views/EmergencyContact/EmergencyContacts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _referralController = TextEditingController();
  // Same values the Profile screen uses, so the two always agree.
  static const List<String> _genders = ['Male', 'Female', 'Other'];
  String? _gender;
  // dd-MM-yyyy, the format the Profile screen saves.
  String? _dob;
  File? _photo;
  String? _photoUrl;
  bool _uploadingPhoto = false;
  final ImagePicker _picker = ImagePicker();

  // >>> START: _pickPhoto - takes or chooses a photo and uploads it
  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(
        source: source, maxHeight: 1024, maxWidth: 1024, imageQuality: 70);
    if (picked == null || !mounted) return;
    final file = File(picked.path);
    setState(() {
      _photo = file;
      _photoUrl = null;
      _uploadingPhoto = true;
    });
    final url = await MediaApi.upload(context, file);
    if (!mounted) return;
    setState(() {
      _photoUrl = url;
      _uploadingPhoto = false;
    });
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not upload the photo. You can add it later in Profile.')));
    }
  }
  // <<< END: _pickPhoto - takes or chooses a photo and uploads it

  // >>> START: _choosePhotoSource - asks camera or gallery
  void _choosePhotoSource() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Take a photo'),
            onTap: () {
              Navigator.pop(ctx);
              _pickPhoto(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(ctx);
              _pickPhoto(ImageSource.gallery);
            },
          ),
        ]),
      ),
    );
  }
  // <<< END: _choosePhotoSource - asks camera or gallery

  // >>> START: _pickDob - date of birth picker
  Future<void> _pickDob() async {
    FocusScope.of(context).unfocus();
    final date = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) {
      setState(() => _dob = DateFormat('dd-MM-yyyy').format(date));
    }
  }
  // <<< END: _pickDob - date of birth picker

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
      // errors appear and disappear as the customer types, instead of staying until Next is pressed again
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Padding(
          // above the keyboard, and above the phone's own navigation bar so Next is never hidden behind it
          padding: MediaQuery.of(context).viewInsets +
              EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
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
                  SizedBox(height: 1.2.h),
                  Center(
                    child: GestureDetector(
                      onTap: _uploadingPhoto ? null : _choosePhotoSource,
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: tBackground,
                          backgroundImage: _photo != null ? FileImage(_photo!) : null,
                          child: _uploadingPhoto
                              ? CircularProgressIndicator(color: tPrimaryColor)
                              : (_photo == null
                                  ? Icon(Icons.person, size: 40, color: tGray)
                                  : null),
                        ),
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: tPrimaryColor,
                          child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
                        ),
                      ]),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Add a photo (optional)',
                          style: TextStyle(color: tGray, fontSize: isTab(context) ? 8.sp : 11.sp)),
                    ),
                  ),
                  SizedBox(height: 1.4.h),
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
                        return 'Please enter your full name';
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
                  SizedBox(height: 1.6.h),
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
                  SizedBox(height: 1.6.h),
                  Text(
                    'gender'.tr + ' (optional)',
                    style: TextStyle(
                        color: tDarkOrangeColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 10,
                    children: _genders
                        .map((g) => ChoiceChip(
                              label: Text(g),
                              selected: _gender == g,
                              selectedColor: tPrimaryColor,
                              labelStyle: TextStyle(
                                  color: _gender == g ? Colors.white : tDarkNavyblue,
                                  fontWeight: FontWeight.w600),
                              onSelected: (on) =>
                                  setState(() => _gender = on ? g : null),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 1.6.h),
                  Text(
                    'Date of birth (optional)',
                    style: TextStyle(
                        color: tDarkOrangeColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: _pickDob,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: tBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Text(_dob ?? 'DD-MM-YYYY',
                              style: TextStyle(
                                  color: _dob == null ? tGray : tDarkNavyblue,
                                  fontWeight:
                                      _dob == null ? FontWeight.w400 : FontWeight.w600,
                                  fontSize: isTab(context) ? 10.sp : 13.sp)),
                        ),
                        Icon(Icons.calendar_today, size: 18, color: tPrimaryColor),
                      ]),
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                  Text(
                    'referral_code'.tr,
                    style: TextStyle(
                        color: tDarkOrangeColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp),
                  ),
                  SizedBox(height: 1.h),
                  TextFormFieldWidgets(
                    style: TextStyle(fontWeight: FontWeight.w600),
                    controller: _referralController,
                    keyboardTyp: TextInputType.text,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                    fillcolor: tBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hinttext: 'Referral code (optional)',
                    hintStyl: TextStyle(
                        color: tGray,
                        fontSize: isTab(context) ? 10.sp : 13.sp,
                        fontWeight: FontWeight.w400),
                    validator: (value) => null,
                  ),
                  SizedBox(height: 1.6.h),
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
                              if (_gender != null) "gender": _gender!,
                              if (_dob != null) "date_of_birth": _dob!,
                            };
                            if (_uploadingPhoto) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Uploading your photo, please wait.')));
                              return;
                            }
                            var res =
                                await UserAPI().personalDetails(context, param);
                            if (res == null || res['status'] != 'OK') {
                              Twl.createAlert(
                                  context, 'Oops', '${res?['error']}');
                              return;
                            }
                            // A photo that failed to save is not worth stopping for:
                            // it can be added later in Profile.
                            if (_photoUrl != null) {
                              await UserAPI().updateProfilePic(context, _photoUrl!);
                            }
                            // The referral code is optional; a wrong one is shown
                            // here so the customer can fix or clear it.
                            final code = _referralController.text.trim();
                            if (code.isNotEmpty) {
                              var ref = await UserAPI()
                                  .applyReferral(context, {"referal_code": code});
                              if (ref == null || ref['status'] != 'OK') {
                                Twl.createAlert(
                                    context, 'Oops', '${ref?['error']}');
                                return;
                              }
                            }
                            final nav = Navigator.of(context);
                            nav.pop();
                            nav.push(MaterialPageRoute(
                                builder: (_) =>
                                    EmergencyContact(showLocationSheet: true)));
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
