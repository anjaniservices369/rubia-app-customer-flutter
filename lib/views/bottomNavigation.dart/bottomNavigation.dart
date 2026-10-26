// =============================================================================
// WHAT : The bottom tab bar: Home, Bookings, Profile.
// NOTES: Hosts the three main screens.
// =============================================================================
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/taxiservices/rideservices/rideLayout.dart';
import 'package:base_project_flutter/views/homePage/homePage.dart';
import 'package:base_project_flutter/views/profilePage/ProfilePageView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../Bookings/bookingPageView.dart';
import '../PersonalDetails/personalDetailsView.dart';

// >>> START: BottomNavigation - screen/widget shell (the visible part is in its State class)
class BottomNavigation extends StatefulWidget {
  BottomNavigation({
    Key? key,
    this.tabIndexId,
    this.selectedType,
    this.showRegistrationSheet = false,
  }) : super(key: key);

  final tabIndexId;
  final selectedType;
  // A brand-new customer completes their profile (name/email, referral,
  // location) as a chain of bottom sheets opened on top of Home, right after
  // this screen first appears, instead of a separate full-screen stop.
  final bool showRegistrationSheet;
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}
// <<< END: BottomNavigation - screen/widget shell (the visible part is in its State class)

// >>> START: _BottomNavigationState - the data and logic behind its screen
class _BottomNavigationState extends State<BottomNavigation> {
  // >>> START: checkBottomIndex - checks bottom index
  void checkBottomIndex() {
    setState(() {
      tabIndexs = widget.tabIndexId != null ? widget.tabIndexId : 0;
    });
  }
  // <<< END: checkBottomIndex - checks bottom index

  var tabIndexs = 0;
  // >>> START: _onItemTapped - reacts to item tapped
  void _onItemTapped(int index) {
    setState(() {
      tabIndexs = index;
    });
  }
  // <<< END: _onItemTapped - reacts to item tapped

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    checkBottomIndex();

    // Push notifications are handled by PushService (OneSignal).

    if (widget.showRegistrationSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            isDismissible: false,
            enableDrag: false,
            builder: (context) => PersonalDetails(),
          );
        }
      });
    }
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    Image home(int index) => tabIndexs == index
        ? Image.asset(
      Images.SELECT_HOME,
      width: isTab(context) ? 40 : 22,
    )
        : Image.asset(
      Images.HOME,
      width: isTab(context) ? 35 : 22,
    );
    Image nearby(int index) => tabIndexs == index
        ? Image.asset(
      Images.SELECT_BOOKINGS,
      width: isTab(context) ? 38 : 25,
    )
        : Image.asset(
      Images.BOOKINGS,
      width: isTab(context) ? 38 : 25,
    );
    Image profile(int index) => tabIndexs == index
        ? Image.asset(
      Images.SELECT_PROFILE,
      width: isTab(context) ? 36 : 18,
    )
        : Image.asset(
      Images.PROFILE,
      width: isTab(context) ? 36 : 18,
    );
    return NewRideLayout(
      child: WillPopScope(
        onWillPop: () => tabIndexs == 0
            ? Twl.willpopAlert(context)
            : tabIndexs == 1
            ? Twl.forceNavigateTo(context, BottomNavigation(tabIndexId: 0))
            : tabIndexs == 2
            ? Twl.forceNavigateTo(
            context, BottomNavigation(tabIndexId: 0))
            // : tabIndexs == 3
            // ? Twl.forceNavigateTo(
            // context, BottomNavigation(tabIndexId: 0))
            : null,
        child: Scaffold(
          body: Stack(
            children: [
              // DrawerList(),
              IndexedStack(
                index: tabIndexs,
                children: [
                  HomePage(),
                  BookingPageView(),
                  // WalletPage(selectedType: widget.selectedType),
                  ProfilePageView(),
                  // Darwer(),
                ],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: tDarkNavyblue,
            selectedItemColor: tPrimaryColor,
            onTap: _onItemTapped,
            currentIndex: tabIndexs,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            iconSize: isTab(context) ? 40 : 30,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: [
              _bottomNavigationBarItem(
                icon: home(0),
                label: 'home'.tr,
              ),
              _bottomNavigationBarItem(
                icon: nearby(1),
                // icon: Icon(Icons.history_sharp),
                label: 'bookings'.tr,
              ),
              // _bottomNavigationBarItem(
              //   icon: orders(2),
              //   label: 'wallet'.tr,
              // ),
              _bottomNavigationBarItem(
                icon: profile(2),
                label: 'profile'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: _bottomNavigationBarItem - bottom navigation bar item
  _bottomNavigationBarItem({required icon, required String label}) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
  // <<< END: _bottomNavigationBarItem - bottom navigation bar item
}
// <<< END: _BottomNavigationState - the data and logic behind its screen