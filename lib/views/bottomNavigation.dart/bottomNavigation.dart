// =============================================================================
// WHAT : The bottom tab bar: Home, Bookings, Profile.
// NOTES: Hosts the three main screens.
// =============================================================================
import 'dart:async';

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
import '../Bookings/components/rateRide.dart';
import '../PersonalDetails/components/EnableLocationView.dart';
import '../PersonalDetails/personalDetailsView.dart';

// >>> START: BottomNavigation - screen/widget shell (the visible part is in its State class)
class BottomNavigation extends StatefulWidget {
  BottomNavigation({
    Key? key,
    this.tabIndexId,
    this.selectedType,
    this.showRegistrationSheet = false,
    this.showLocationSheet = false,
  }) : super(key: key);

  final tabIndexId;
  final selectedType;
  // A brand-new customer starts registration with the name / email / referral
  // sheet opened on top of Home, right after this screen first appears. The
  // emergency contacts screen follows, then Home again with the location sheet.
  final bool showRegistrationSheet;
  final bool showLocationSheet;
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}
// <<< END: BottomNavigation - screen/widget shell (the visible part is in its State class)

// >>> START: _BottomNavigationState - the data and logic behind its screen
class _BottomNavigationState extends State<BottomNavigation>
    with WidgetsBindingObserver {
  // Checks whether the ride just booked has been completed (see rateRide.dart).
  Timer? _rideTimer;

  // >>> START: checkBottomIndex - checks bottom index
  /// `tabIndexId` keeps its old meaning for the many callers: 0 = Home,
  /// 1 = My Bookings, 2 = Profile. My Bookings is no longer a tab: it opens on
  /// top of Home (the bottom bar only has Home and Profile).
  void checkBottomIndex() {
    setState(() {
      tabIndexs = widget.tabIndexId == 2 ? 1 : 0;
    });
    if (widget.tabIndexId == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => BookingPageView()));
        }
      });
    }
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

    // As soon as the ride is completed, ask the customer to rate the driver,
    // whichever screen they are on.
    WidgetsBinding.instance.addObserver(this);
    _rideTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (mounted) RideRatingPrompt.check(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) RideRatingPrompt.check(context);
    });

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
    if (widget.showLocationSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => EnableLocationView(),
          );
        }
      });
    }
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: didChangeAppLifecycleState - checks the ride again when the app comes back
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      RideRatingPrompt.check(context);
    }
  }
  // <<< END: didChangeAppLifecycleState - checks the ride again when the app comes back

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _rideTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

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
            : Twl.forceNavigateTo(context, BottomNavigation(tabIndexId: 0)),
        child: Scaffold(
          body: Stack(
            children: [
              // DrawerList(),
              IndexedStack(
                index: tabIndexs,
                children: [
                  HomePage(),
                  ProfilePageView(),
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
                icon: profile(1),
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