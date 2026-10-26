// =============================================================================
// WHAT : List of options on the profile tab (favourites, wallet, refer,
//        support...).
// NOTES: Navigation only.
// =============================================================================
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';

import 'package:base_project_flutter/views/profilePage/components/AllOptionsComponents/ReferAndEarn.dart';
import 'package:base_project_flutter/views/profilePage/components/emergencyContactPage.dart';
import 'package:base_project_flutter/views/profilePage/components/notifactionPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';

import 'AllOptionsComponents/FavoritesLocation.dart';
import 'support.dart';
// import 'AllOptionsComponents/Support.dart';

// >>> START: AllOptionsCard - screen/widget shell (the visible part is in its State class)
class AllOptionsCard extends StatefulWidget {
  const AllOptionsCard({Key? key}) : super(key: key);

  @override
  State<AllOptionsCard> createState() => _AllOptionsCardState();
}
// <<< END: AllOptionsCard - screen/widget shell (the visible part is in its State class)

// >>> START: _AllOptionsCardState - the data and logic behind its screen
class _AllOptionsCardState extends State<AllOptionsCard> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
          decoration: BoxDecoration(
              color: tWhite,
              boxShadow: [tBackbtnBoxShadow],
              borderRadius: BorderRadiusDirectional.circular(10)),
          child: Column(
            children: [
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Twl.navigateTo(
                          context,
                          BottomNavigation(
                            tabIndexId: 1,
                          ));
                    },
                    leading: Image.asset(
                      Images.MY_RIDES,
                      scale: 3.5,
                    ),
                    title: Text(
                      'myrides'.tr,
                      style: TextStyle(color: tSecondaryColor),
                    ),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     Twl.navigateTo(
                  //         context,
                  //         BottomNavigation(
                  //           tabIndexId: 2,
                  //         ));
                  //   },
                  //   title: Text(
                  //     'wallet'.tr,
                  //     style: TextStyle(color: tSecondaryColor),
                  //   ),
                  //   trailing: Icon(
                  //     Icons.arrow_forward_ios,
                  //     color: tWhite,
                  //     size: 20,
                  //   ),
                  // ),
                  ListTile(
                    onTap: () {
                      // Twl.navigateTo(context, ReferAndEarn());
                      Twl.navigateTo(context, Notifactionpage());
                    },
                    leading: Image.asset(
                      Images.NOTIFICATIONS,
                      scale: 3.5,
                    ),
                    title: Text(
                      'notifications'.tr,
                      style: TextStyle(color: tSecondaryColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: tWhite,
                      size: 20,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Twl.navigateTo(context, FavouriteLocation());
                    },
                    
                    leading: Image.asset(
                      Images.FAV_LOCATION,
                      scale: 3.5,
                    ),
                    title: Text(
                      'Favorites_Location'.tr,
                      style: TextStyle(color: tSecondaryColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: tWhite,
                      size: 20,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      // Twl.navigateTo(context, Support());
                      Twl.navigateTo(context, EmergencyContact());
                    },
                    leading: Image.asset(
                      Images.EMERGENCY_CONTACT,
                      scale: 3.5,
                    ),
                    title: Text(
                      'emergency_contact'.tr,
                      style: TextStyle(color: tSecondaryColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: tWhite,
                      size: 20,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Twl.navigateTo(context, ReferAndEarn());
                    },
                    leading: Image.asset(
                      Images.REFER_EARN,
                      scale: 3.5,
                    ),
                    title: Text(
                      'refer_&_earn'.tr,
                      style: TextStyle(color: tSecondaryColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: tWhite,
                      size: 20,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Twl.navigateTo(context, Support());
                    },
                    leading: Image.asset(
                      Images.SUPPORT,
                      scale: 3.5,
                    ),
                    title: Text(
                      'support'.tr,
                      style: TextStyle(color: tSecondaryColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: tWhite,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _AllOptionsCardState - the data and logic behind its screen
