// =============================================================================
// WHAT : DRIVERS BOOKING: 'Your order has been placed' screen.
// NOTES: Leads to My Bookings.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';

// >>> START: OrderPlaced - screen/widget shell (the visible part is in its State class)
class OrderPlaced extends StatefulWidget {
  const OrderPlaced({Key? key}) : super(key: key);

  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}
// <<< END: OrderPlaced - screen/widget shell (the visible part is in its State class)

// >>> START: _OrderPlacedState - the data and logic behind its screen
class _OrderPlacedState extends State<OrderPlaced> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(context, BottomNavigation(tabIndexId: 0));
      },
      child: Scaffold(
        body: Center(
          child: Container(
            height: 60.h,
            padding: MediaQuery.of(context).viewInsets,
            decoration: BoxDecoration(
                color: tWhite,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                boxShadow: [tBoxShadow]),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'order_placed'.tr,
                    style: TextStyle(
                        fontSize: isTab(context) ? 10.sp : 16.sp,
                        fontWeight: FontWeight.w700,
                        color: tSecondaryColor),
                  ),
                  SizedBox(height: 5.h),
                  Image.asset(
                    Images.CONFIRM,
                    scale: isTab(context) ? 1 : 4,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'ride_is_placed_please_wait'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: isTab(context) ? 10.sp : 16.sp,
                        fontWeight: FontWeight.w500,
                        color: tSecondaryColor),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () {
                      Twl.forceNavigateTo(
                          context,
                          BottomNavigation(
                            tabIndexId: 1,
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SizedBox(
                          width: isTab(context) ? 60.w : 50.w,
                          height: isTab(context) ? 6.h : 7.h,
                          child: Container(
                            height: 2.h,
                            width: 6.w,
                            decoration: BoxDecoration(
                              color: tPrimaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                "My Bookings".tr,
                                style: TextStyle(
                                    letterSpacing: 1,
                                    color: tWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTab(context) ? 10.sp : 16.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
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
// <<< END: _OrderPlacedState - the data and logic behind its screen
