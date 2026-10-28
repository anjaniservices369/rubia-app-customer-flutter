// =============================================================================
// WHAT : List of options on the profile tab (My Transactions, notifications,
//        favourites, emergency contacts, refer, support...).
// NOTES: Navigation only.
// =============================================================================

import 'package:base_project_flutter/views/profilePage/components/AllOptionsComponents/ReferAndEarn.dart';
import 'package:base_project_flutter/views/Transactions/myTransactionsPage.dart';
import 'package:base_project_flutter/views/profilePage/components/emergencyContactPage.dart';
import 'package:base_project_flutter/views/profilePage/components/notifactionPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: tWhite,
              boxShadow: [tBackbtnBoxShadow],
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _optionTile(
                image: Images.MY_RIDES,
                title: 'my_transactions'.tr,
                onTap: () {
                  // Every service's payments in one place, by day and by month.
                  Twl.navigateTo(context, const MyTransactionsPage());
                },
              ),
              _optionTile(
                image: Images.NOTIFICATIONS,
                title: 'notifications'.tr,
                onTap: () => Twl.navigateTo(context, Notifactionpage()),
              ),
              _optionTile(
                image: Images.FAV_LOCATION,
                title: 'Favorites_Location'.tr,
                onTap: () => Twl.navigateTo(context, FavouriteLocation()),
              ),
              _optionTile(
                image: Images.EMERGENCY_CONTACT,
                title: 'emergency_contact'.tr,
                onTap: () => Twl.navigateTo(context, EmergencyContact()),
              ),
              _optionTile(
                image: Images.REFER_EARN,
                title: 'refer_&_earn'.tr,
                onTap: () => Twl.navigateTo(context, ReferAndEarn()),
              ),
              _optionTile(
                image: Images.SUPPORT,
                title: 'support'.tr,
                onTap: () => Twl.navigateTo(context, Support()),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: _optionTile - option tile
  Widget _optionTile({
    required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tFieldColor,
        border: Border.all(color: tDivider.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: tWhite,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Image.asset(
                      image,
                      width: 22,
                      height: 22,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: tDarkNavyblue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: tDarkNavyblue.withValues(alpha: 0.55),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // <<< END: _optionTile - option tile
}
// <<< END: _AllOptionsCardState - the data and logic behind its screen
