// =============================================================================
// WHAT : Side menu with the customer's name and shortcuts.
// NOTES: Visual component.
// =============================================================================
import 'dart:io';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/providers/themeProvider.dart';
import 'package:base_project_flutter/responsive.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import '../profilePage/components/profilePage.dart';

// >>> START: Darwer - screen/widget shell (the visible part is in its State class)
class Darwer extends StatefulWidget {
  const Darwer({Key? key}) : super(key: key);

  @override
  State<Darwer> createState() => _DarwerState();
}
// <<< END: Darwer - screen/widget shell (the visible part is in its State class)

// >>> START: _DarwerState - the data and logic behind its screen
class _DarwerState extends State<Darwer> {
  bool _switchValue = false;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    ThemeProvider _themeData = Provider.of<ThemeProvider>(context);
    return Container(
      width: isTab(context) ? 50.w : 70.w,
      child: Drawer(
          backgroundColor: tBackground,
          child: SafeArea(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              Container(
                color: tWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    SizedBox(height: 10),
                    UserDetail(
                      name: 'Enter Your Email',
                      contactNumber: '',
                      updateEdit: () {
                        Twl.navigateTo(context, ProfilePage());
                      },
                      decoration: new BoxDecoration(
                        color: const Color(0xFFF3F6FA),
                        image: new DecorationImage(
                          image: new NetworkImage(
                              ' https://img.icons8.com/bubbles/50/000000/user.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(isTab(context) ? 50 : 30.0)),
                      ),
                      // image: Image.network(
                      //   profileImage != null ? profileImage : "",
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              if (Platform.isIOS)
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ListTile(
                      leading: Icon(
                        Icons.home,
                        size: isTab(context) ? 35 : 25,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                            color: tBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp),
                      ),
                      onTap: () {
                        // Get.toNamed(AppRoutes.WALLETTRANSACTIONS);
                      }),
                ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                    leading: Icon(Icons.translate_sharp,
                        color: tBlack, size: isTab(context) ? 35 : 25),
                    title: Text(
                      'My Transactions',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    onTap: () {
                      // Get.toNamed(AppRoutes.WALLETTRANSACTIONS);
                    }),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                    leading: Icon(Icons.local_offer,
                        color: tBlack, size: isTab(context) ? 35 : 25),
                    title: Text(
                      'Offers',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    onTap: () {}),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      'Night Mode',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    Spacer(),
                    CupertinoSwitch(
                      value: _themeData.swithValue,
                      onChanged: (value) {
                        if (_themeData.swithValue == true) {
                          _themeData.setDayMode(value);
                        } else {
                          _themeData.setNightMode(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                    leading: Icon(Icons.notifications,
                        color: tBlack, size: isTab(context) ? 35 : 25),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    onTap: () {}),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                    leading: Icon(Icons.share,
                        color: tBlack, size: isTab(context) ? 35 : 25),
                    title: Text(
                      'Referral',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    onTap: () {}),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                    leading: Icon(Icons.lock_outlined,
                        color: tBlack, size: isTab(context) ? 35 : 25),
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    onTap: () {}),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                    leading: Icon(Icons.logout,
                        color: tBlack, size: isTab(context) ? 35 : 25),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    onTap: () async {}),
              ),
              SizedBox(height: tDefaultPadding),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'About Us',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Get.to(HelpFaqWebView());
                    },
                    child: Text(
                      'Help & FAQS',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
              if (isTab(context))
                SizedBox(
                  height: tDefaultPadding,
                ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Get.toNamed(AppRoutes.TERMSCONDITION);
                    },
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                          color: tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _DarwerState - the data and logic behind its screen

// >>> START: UserDetail - screen/widget
class UserDetail extends StatelessWidget {
  const UserDetail({
    Key? key,
    this.name,
    this.contactNumber,
    this.image,
    this.decoration,
    this.updateEdit,
    // this.mail,
  }) : super(key: key);

  final String? name;
  final String? contactNumber;
//  final String?mail;
  final Image? image;
  final Decoration? decoration;
  final updateEdit;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              width: isTab(context) ? 100 : 65.0,
              height: isTab(context) ? 100 : 65.0,
              decoration: decoration,
            )),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contactNumber!,
                  style: TextStyle(
                      color: tBlack,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: isTab(context) ? tDefaultPadding : 6),
              Row(
                children: [
                  Text(
                    name!,
                    style: TextStyle(
                        color: tBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: updateEdit,
                      child: Icon(
                        Icons.edit,
                        color: tBlack,
                        size: isTab(context) ? 35 : 25,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: UserDetail - screen/widget
