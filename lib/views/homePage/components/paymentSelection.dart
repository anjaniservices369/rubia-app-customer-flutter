// =============================================================================
// WHAT : Payment method picker used during booking.
// NOTES: Choice is kept in TripOptionsProvider.
// =============================================================================
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/taxiservices/searchlocation/searchlocation.dart';
import 'package:base_project_flutter/views/homePage/components/OneWay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../responsive.dart';
import 'paymentMethod.dart';

// >>> START: PaymentSelection - screen/widget shell (the visible part is in its State class)
class PaymentSelection extends StatefulWidget {
  const PaymentSelection({Key? key, this.boolpaymentpage, this.rideData})
      : super(key: key);
  final bool? boolpaymentpage;
  final rideData;

  @override
  State<PaymentSelection> createState() => _PaymentSelectionState();
}
// <<< END: PaymentSelection - screen/widget shell (the visible part is in its State class)

// >>> START: _PaymentSelectionState - the data and logic behind its screen
class _PaymentSelectionState extends State<PaymentSelection> {
  var slectedIndex = 0;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return widget.boolpaymentpage == true
            ? Twl.forceNavigateTo(context, SearchLocation())
            : Twl.forceNavigateTo(context, OneWay());
      },
      child: Scaffold(
        backgroundColor: tWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: tappbarclr,
          title: Text(
            "payment".tr,
            style: GoogleFonts.mulish(
              color: tDarkNavyblue,
              fontWeight: FontWeight.w700,
              fontSize: isTab(context) ? 7.sp : 18.sp,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              widget.boolpaymentpage == true
                  ? Twl.forceNavigateTo(context, SearchLocation())
                  : Twl.forceNavigateTo(context, OneWay());
            },
            child: Image.asset(
              Images.CLOSE,
              scale: 4,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [tBoxShadow],
                      color: tWhite),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'total_amount'.tr,
                              style: TextStyle(
                                  color: tDarkNavyblue,
                                  fontSize: isTab(context) ? 8.sp : 14.sp,
                                  fontWeight: FontWeight.w700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(currencySymbol + '17509',
                                    // rideDetails['total_fare'].toString(),
                                    style: TextStyle(
                                        fontSize: isTab(context) ? 8.sp : 14.sp,
                                        color: tDarkNavyblue,
                                        fontWeight: FontWeight.w700))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Choose".tr,
                style: GoogleFonts.mulish(
                  color: tDarkNavyblue,
                  fontWeight: FontWeight.w700,
                  fontSize: isTab(context) ? 7.sp : 14.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [tBoxShadow],
                      color: tWhite,
                      borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Twl.navigateTo(context, PqymentMethod());
                              // selectedWalletIndex = 0;
                              slectedIndex = 0;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: slectedIndex == 0 ? tPrimaryColor : tWhite,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Images.WALLET,
                                  scale: 4,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Wallet'.tr,
                                      style: GoogleFonts.mulish(
                                        color: slectedIndex == 0
                                            ? tWhite
                                            : tDarkNavyblue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTab(context) ? 7.sp : 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Add'.tr,
                                        style: GoogleFonts.mulish(
                                          color: slectedIndex == 0
                                              ? tWhite
                                              : tPrimaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              isTab(context) ? 7.sp : 8.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  currencySymbol + '0.0',
                                  style: GoogleFonts.mulish(
                                    color: slectedIndex == 0
                                        ? tWhite
                                        : tPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTab(context) ? 7.sp : 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              slectedIndex = 1;
                              // selectedRow2 = selectedRow2 == -1 ? 0 : -1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                                color:
                                    slectedIndex == 1 ? tPrimaryColor : tWhite),
                            child: Row(
                              children: [
                                Image.asset(
                                  Images.QRICON,
                                  scale: 4,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pay at'.tr,
                                      style: GoogleFonts.mulish(
                                        color: slectedIndex == 1
                                            ? tWhite
                                            : tDarkNavyblue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTab(context) ? 7.sp : 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Pay the driver in cash after the ride.',
                                      style: GoogleFonts.mulish(
                                        color: slectedIndex == 1
                                            ? tWhite
                                            : tPrimaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: isTab(context) ? 7.sp : 8.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                            onTap: () {
                              // print(selectedRow1);
                              setState(() {
                                slectedIndex = 2;
                                //  selectedRow1 = selectedRow1 == 0 ? -1 : 0;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.5.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color:
                                    slectedIndex == 2 ? tPrimaryColor : tWhite,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    Images.RUPEE,
                                    scale: 4,
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Text(
                                    'cash'.tr,
                                    style: GoogleFonts.mulish(
                                      color: slectedIndex == 2
                                          ? tWhite
                                          : tDarkNavyblue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTab(context) ? 7.sp : 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _PaymentSelectionState - the data and logic behind its screen
