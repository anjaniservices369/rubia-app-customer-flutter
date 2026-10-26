// =============================================================================
// WHAT : Profile header card; changing the photo uploads it to the Rubia
//        server.
// NOTES: Server: media/upload, update-profile-pic.
// =============================================================================
import 'dart:io';

import 'package:base_project_flutter/views/profilePage/components/profilePage.dart';
import 'package:base_project_flutter/api_services/mediaApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../responsive.dart';
import '../../bottomNavigation.dart/bottomNavigation.dart';

// >>> START: ProfileCard - screen/widget shell (the visible part is in its State class)
class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key, this.checkDetails}) : super(key: key);
  final checkDetails;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}
// <<< END: ProfileCard - screen/widget shell (the visible part is in its State class)

// >>> START: _ProfileCardState - the data and logic behind its screen
class _ProfileCardState extends State<ProfileCard> {
  var checkDetails;

  bool _isLoading = true;
  bool kycLoading = true;
  bool _profileLoader = true;
  final picker = ImagePicker();
  String profileImage = '';

  // >>> START: getProfileImage - gets profile image
  Future getProfileImage(String type) async {
    var pickedFile;
    if (type == 'camera') {
      pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 50);
    } else if (type == 'gallery') {
      pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 50);
    } else {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1600,
        maxWidth: 1600,
        imageQuality: 80,
      );
    }
    setState(() => kycLoading = false);
    if (pickedFile != null) {
      _profileLoader = false;
      File _file = File(pickedFile.path);
      setState(() => kycLoading = false);
      // Upload to the backend media store (replaces Firebase Storage).
      setState(() => kycLoading = false);
      final String? url = await MediaApi.upload(context, _file);
      if (url != null) {
        setState(() {
          _profileLoader = false;
          profileImage = url;
          _profileLoader = true;
          kycLoading = true;
        });
        uploadImage(profileImage);
      } else {
        setState(() => kycLoading = true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not upload the image. Please try again.'),
        ));
      }
    }
    // ignore: unused_element
  }
  // <<< END: getProfileImage - gets profile image

  // >>> START: uploadImage - uploads image
  uploadImage(profileImage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var check = await UserAPI().updateProfilePic(context, profileImage);
    if (check != null && check['status'] == 'OK') {
      setState(() {
        checkDetails = check['detail'];
      });
      Twl.forceNavigateTo(
          context,
          BottomNavigation(
            tabIndexId: 2,
          ));
    }
  }
  // <<< END: uploadImage - uploads image

  // >>> START: checkLoginStatus - checks login status
  Future<Null> checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var check =
        await UserAPI().checkApi(sharedPreferences.getString("authCode")!);

    if (check != null && check['status'] == 'OK') {
      sharedPreferences.setString('profileImage',
          check['detail']['selfie'] != null ? check['detail']['selfie'] : '');
      if (mounted) {
        setState(() {
          checkDetails = check['detail'];
        });
      }
      // sharedPreferences.setString('emailId', check['detail']['username']);
    }
  }
  // <<< END: checkLoginStatus - checks login status

  //         source: ImageSource.camera,
  //         maxHeight: 480,
  //         maxWidth: 640,
  //         imageQuality: 50);
  //   } else if (type == 'gallery') {
  //     pickedFile = await picker.getImage(
  //         source: ImageSource.gallery,
  //         maxHeight: 480,
  //         maxWidth: 640,
  //         imageQuality: 50);

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    profileImage = '';
    // checkLoginApi();
    checkLoginStatus();
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return checkDetails == null
        ? SpinKitThreeBounce(
            color: tPrimaryColor,
            size: 20.0,
          )
        : GestureDetector(
            child: Center(
              child: Container(
                // margin: EdgeInsets.only(
                //     left: 10,
                //     right: 10,
                //     top: isTab(context)
                //         ? 8
                //         : isDesktop(context)
                //             ? 15
                //             : isMobile(context)
                //                 ? 10
                //                 : 10),
                child: Card(
                  elevation: 0,
                  // color: tBoxShadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: tDivider.withValues(alpha: 0.7)),
                  ),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 2.w,
                          ),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: tDarkNavyblue, width: 1.5)),
                                child:
                                    // CircleAvatar(
                                    //   child: Image.asset(Images.PROFILE_IMAGE),
                                    //   backgroundImage: AssetImage(
                                    // checkDetails['profile_image'] == null
                                    //     ? CircleAvatar(
                                    //         backgroundImage: NetworkImage(
                                    //             Images.BOOKINGS),
                                    //         radius: isTab(context) ? 80 : 50,
                                    //       )
                                    //     : CircleAvatar(
                                    //         backgroundImage: NetworkImage(
                                    //             checkDetails[
                                    //                 'profile_image']),
                                    //         radius: isTab(context) ? 80 : 50,
                                    //       )
                                    Container(
                                  height: isTab(context) ? 145 : 95,
                                  width: isTab(context) ? 145 : 95,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: checkDetails['selfie'] != null &&
                                            checkDetails['selfie']
                                                .toString()
                                                .isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              checkDetails['selfie'],
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : profileImage.isNotEmpty
                                            ? DecorationImage(
                                                image:
                                                    NetworkImage(profileImage),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                    border: Border.all(
                                        color: tDarkNavyblue, width: 1.5),
                                  ),
                                  child: (checkDetails['selfie'] == null ||
                                              checkDetails['selfie']
                                                  .toString()
                                                  .isEmpty) &&
                                          profileImage.isEmpty
                                      ? Icon(
                                          Icons.person_rounded,
                                          color: tDarkNavyblue.withValues(
                                              alpha: 0.55),
                                          size: 48,
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                child: InkWell(
                                  onTap: () async {
                                    showBarModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        backgroundColor: tWhite,
                                        builder: (context) => Container(
                                            height:
                                                isMobile(context) ? 150 : 30.w,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 60, top: 30, right: 60),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          getProfileImage(
                                                              'camera');

                                                          // getImage('camera getImage(

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/Camera.png",
                                                              scale:
                                                                  isTab(context)
                                                                      ? 3
                                                                      : 5,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  tDefaultPadding,
                                                            ),
                                                            Text("camera".tr)
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          getProfileImage(
                                                              'gallery');

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/imageUpload.png",
                                                              scale:
                                                                  isTab(context)
                                                                      ? 3
                                                                      : 5,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  tDefaultPadding,
                                                            ),
                                                            Text("Gallery".tr)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: tPrimaryColor,
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: tWhite,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 56.w,
                                child: Text(
                                  // 'Name',
                                  checkDetails['first_name'].toString() +
                                      ' ' +
                                      checkDetails['last_name'].toString(),

                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.mulish(
                                      color: tSecondaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                checkDetails['contact_no'].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                              SizedBox(height: isTab(context) ? 1 : 1.h),
                              Material(
                                color: tPrimaryColor,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () {
                                    Twl.navigateTo(
                                      context,
                                      ProfilePage(),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 17,
                                          color: tWhite,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'edit_profile'.tr,
                                          style: GoogleFonts.mulish(
                                            color: tWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                // ),
              ),
            ),
          );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _ProfileCardState - the data and logic behind its screen
