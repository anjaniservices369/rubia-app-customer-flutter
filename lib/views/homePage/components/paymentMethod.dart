// =============================================================================
// WHAT : Choose how to pay (cash / wallet).
// NOTES: Choice is kept in TripOptionsProvider.
// =============================================================================
// import 'package:easy_go/responsive.dart';
import 'package:base_project_flutter/views/RideBooking/RideEstimateInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
// import '../../../globalWidgets/backiconWidget.dart';
import '../../../globalWidgets/buttonIconWidget.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../responsive.dart';
import 'paymentDonePage.dart';

// >>> START: PqymentMethod - screen/widget shell (the visible part is in its State class)
class PqymentMethod extends StatefulWidget {
  const PqymentMethod({Key? key}) : super(key: key);

  @override
  State<PqymentMethod> createState() => _PqymentMethodState();
}
// <<< END: PqymentMethod - screen/widget shell (the visible part is in its State class)

// >>> START: _PqymentMethodState - the data and logic behind its screen
class _PqymentMethodState extends State<PqymentMethod> {
  String radioButtonItem = 'ONE';
  int id = 1;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackground,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Twl.navigateBack(context);
              // Twl.forceNavigateTo(
              //     context,
              //     BottomNavigation(
              //       tabIndexId: 1,
              //     ));
            },
            child: Padding(
              padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
              child: BackIconWidget(),
            )),
        elevation: 0,
        titleSpacing: 7,
        backgroundColor: tYellow,
        title: Text(
          'payment'.tr,
          style: GoogleFonts.mulish(
            color: tDarkNavyblue,
            fontWeight: FontWeight.w700,
            fontSize: isTab(context) ? 10.sp : 17.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.8.h,
            ),
            Container(
              padding: EdgeInsets.all(isTab(context) ? 15 : 20),
              decoration: BoxDecoration(
                color: tYellow,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [tBackbtnBoxShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'pay'.tr,
                    style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontWeight: FontWeight.w700,
                      fontSize: isTab(context) ? 10.sp : 16.sp,
                    ),
                  ),
                  Text(
                    currencySymbol + '52',
                    style: GoogleFonts.mulish(
                      color: tBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: isTab(context) ? 10.sp : 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.8.h,
            ),
            Text(
              'Recent'.tr,
              style: GoogleFonts.mulish(
                color: tGray,
                fontWeight: FontWeight.w600,
                fontSize: isTab(context) ? 10.sp : 14.sp,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              decoration: BoxDecoration(
                color: tWhite,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [tBackbtnBoxShadow],
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Radio(
                      activeColor: tDarkNavyblue,
                      value: 1,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Veg';
                          id = 1;
                        });
                      },
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: tDividerColor, width: 1),
                      ),
                      child: Image.asset(
                        Images.GPAY,
                        scale: 4,
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      children: [
                        Text(
                          'google'.tr,
                          style: GoogleFonts.mulish(
                            color: tDarkNavyblue,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 10.sp : 13.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.8.h,
            ),
            Text(
              'Debit'.tr,
              style: GoogleFonts.mulish(
                color: tGray,
                fontWeight: FontWeight.w600,
                fontSize: isTab(context) ? 10.sp : 14.sp,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              decoration: BoxDecoration(
                color: tWhite,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [tBackbtnBoxShadow],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: tWhite,
                            border: Border.all(color: tDividerColor, width: 1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 6),
                            child: Icon(
                              Icons.add_rounded,
                              color: tDarkNavyblue,
                              size: isTab(context) ? 20 : 25,
                            ))),
                    SizedBox(
                      width: isTab(context) ? 10 : 4.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Card',
                          style: GoogleFonts.mulish(
                            color: tDarkNavyblue,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 10.sp : 13.sp,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Visa'.tr,
                          style: GoogleFonts.mulish(
                            color: tGray,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 7.sp : 10.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 7),
              child: Text(
                'Upi'.tr,
                style: GoogleFonts.mulish(
                  color: tGray,
                  fontWeight: FontWeight.w600,
                  fontSize: isTab(context) ? 10.sp : 14.sp,
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              decoration: BoxDecoration(
                color: tWhite,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [tBackbtnBoxShadow],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: tDarkNavyblue,
                          value: 2,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'Veg';
                              id = 2;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: tDividerColor, width: 1),
                          ),
                          child: Image.asset(
                            Images.PHONEPE,
                            scale: 4,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Phone'.tr,
                          style: GoogleFonts.mulish(
                            color: tDarkNavyblue,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 10.sp : 13.sp,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50, right: 17),
                      child: Divider(
                        color: tDividerColor,
                        thickness: 1,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: tWhite,
                                  border: Border.all(
                                      color: tDividerColor, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 6),
                                  child: Icon(Icons.add_rounded,
                                      color: tDarkNavyblue,
                                      size: isTab(context) ? 20 : 25))),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'add_new_upi'.tr,
                              style: GoogleFonts.mulish(
                                color: tDarkNavyblue,
                                fontWeight: FontWeight.w600,
                                fontSize: isTab(context) ? 10.sp : 12.sp,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              'you_need_to_have_registered_upi_id'.tr,
                              style: GoogleFonts.mulish(
                                color: tGray,
                                fontWeight: FontWeight.w600,
                                fontSize: isTab(context) ? 7.sp : 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                // expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    child: Container(
                        height: 100.h,
                        // height: MediaQuery.of(context).size.height / 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: RentalVehicleInfo())),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: tWhite,
                  boxShadow: [tBoxShadow],
                  borderRadius: BorderRadiusDirectional.circular(8)),
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Row(children: [
                SizedBox(
                  width: 4.w,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Price".tr,
                    style: TextStyle(
                        fontSize: isTab(context) ? 8.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        color: tDarkNavyblue),
                  ),
                ),
                SizedBox(
                  width: 1.5.w,
                ),
                Row(
                  children: [
                    Text(
                      currencySymbol + "52",
                      style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontWeight: FontWeight.w800,
                        fontSize: isTab(context) ? 14.sp : 20.sp,
                      ),
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: isTab(context) ? 15 : 20,
                          color: tPrimaryColor,
                        ),
                        SizedBox(height: 3.h)
                      ],
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: isTab(context) ? 22.w : 33.w,
                  height: isTab(context) ? 5.h : 5.5.h,
                  child: ButtonWidget(
                    borderRadius: isTab(context) ? 40.0 : 8.0,
                    color: tPrimaryColor,
                    child: Text(
                      "pay".tr,
                      // style: TextStyle(
                      //     letterSpacing: 1,
                      //     color: tBlack,
                      //     fontWeight: FontWeight.w700,
                      //
                      style: GoogleFonts.mulish(
                          color: tWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: isTab(context) ? 9.sp : 16.sp),
                    ),
                    onTap: (startLoading, stopLoading, btnState) {
                      setState(() {
                        Map<String, String> param = {
                          'id': radioButtonItem,
                        };
                        Twl.forceNavigateTo(context, PaymentDonePage());
                      });
                    },
                    borderSide: BorderSide(
                      color: tPrimaryColor,
                    ),
                  ),
                )
              ]),
            ),
          ),
        )
      ]),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _PqymentMethodState - the data and logic behind its screen
