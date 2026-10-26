// =============================================================================
// WHAT : Refer & Earn: share code and see rewards.
// NOTES: Server: refer-earn.
// =============================================================================
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_plus/share_plus.dart' import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../api_services/userApi.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/imageConstant.dart';
import '../../../../globalFuctions/globalFunctions.dart';
import '../../../../globalWidgets/buttonIconWidget.dart';
import '../../../../globalWidgets/buttonWidget.dart';
import '../../../../responsive.dart';

// >>> START: ReferAndEarn - screen/widget shell (the visible part is in its State class)
class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}
// <<< END: ReferAndEarn - screen/widget shell (the visible part is in its State class)

// >>> START: _ReferAndEarnState - the data and logic behind its screen
class _ReferAndEarnState extends State<ReferAndEarn> {
  var checkDetails;
  // >>> START: checkWalletApi - checks wallet api
  @override
  checkWalletApi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var check =
        await UserAPI().checkApi(sharedPreferences.getString('authCode')!);
    if (check != null && check['status'] == 'OK') {
      setState(() {
        checkDetails = check['detail'];
      });
    }
  }
  // <<< END: checkWalletApi - checks wallet api

  var referEarnings;
  var resNOK;

  // >>> START: fetchReferEarnings - fetches refer earnings
  fetchReferEarnings() async {
    var response = await UserAPI().referEarnings(context);
    if (response != null && response['status'] == 'OK') {
      setState(() {
        referEarnings = response['details'];
      });
    } else {
      setState(() {
        resNOK = response['status'];
      });
    }
  }
  // <<< END: fetchReferEarnings - fetches refer earnings

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    checkWalletApi();
    fetchReferEarnings();
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  final _formKey = new GlobalKey<FormState>();
  // >>> START: build - draws this screen/widget on the display
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
            context,
            BottomNavigation(
              tabIndexId: 2,
            ));
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          titleSpacing: 7,
          backgroundColor: tappbarclr,

          leading: GestureDetector(
              onTap: () {
                Twl.forceNavigateTo(
                    context,
                    BottomNavigation(
                      tabIndexId: 2,
                    ));
              },
              child: Padding(
                padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                child: BackIconWidget(),
              )),
          title: Text(
            "refer_&_earn".tr,
            style: TextStyle(
                color: tSecondaryColor,
                fontFamily: "mulish",
                fontSize: isTab(context) ? 10.sp : 17.sp,
                fontWeight: FontWeight.w600),
          ),
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       Twl.navigateTo(context, Support());
          //     },
          //     child: Row(
          //       children: [
          //         Image.asset(
          //           Images.SUPPORTICON,
          //           scale: isTab(context) ? 2 : 3,
          //         ),
          //         SizedBox(
          //           width: 0.5.w,
          //         ),
          //         Text(
          //           'Support',
          //           style: GoogleFonts.mulish(
          //             color: tSecondaryColor,
          //             fontSize: isTab(context) ? 9.sp : 12.sp,
          //             fontWeight: FontWeight.w600,
          //             // fontFamily:
          //           ),
          //         ),
          //         SizedBox(width: 4.w)
          //       ],
          //     ),
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: checkDetails == null
                ? Align(
                    alignment: Alignment.center,
                    child: SpinKitThreeBounce(
                      color: tPrimaryColor,
                      size: 20.0,
                    ))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 9,
                                horizontal: isTab(context) ? 25 : 15),
                            padding: EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                                boxShadow: [tBoxShadow],
                                borderRadius: BorderRadius.circular(20),
                                color: tWhite),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Image(
                                    height: 19.h,
                                    image: AssetImage(Images.REFERFRENDSIMG),
                                  ),
                                ),
                                Text(
                                  "refer_friends".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: tSecondaryColor,
                                      fontFamily: "mulish",
                                      fontSize: isTab(context) ? 17.sp : 19.sp),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "earn_Upto_₹100_Per_Friend_You_Invite".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: tSecondaryColor,
                                      fontFamily: "mulish",
                                      fontSize: isTab(context) ? 12.sp : 12.sp),
                                ),
                                SizedBox(height: 1.5.h),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: isTab(context) ? 10 : 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: tappbarclr),
                                    child: Row(children: [
                                      Image(
                                        height: 2.4.h,
                                        image: AssetImage(Images.GITICON),
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        "my_rewards".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: tSecondaryColor,
                                            fontFamily: "mulish",
                                            fontSize:
                                                isTab(context) ? 9.sp : 11.sp),
                                      ),
                                      Spacer(),
                                      Text(
                                          (referEarnings != null
                                              ? currencySymbol +
                                                  referEarnings['earnings']
                                                      .toString()
                                              : currencySymbol + ''),
                                          // currencySymbol +
                                          //     referEarnings['earnings']
                                          //         .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: tSecondaryColor,
                                              fontFamily: "mulish",
                                              fontSize: isTab(context)
                                                  ? 12.sp
                                                  : 14.sp))
                                    ]))
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: isTab(context) ? 25 : 15,
                                  vertical: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [tBoxShadow],
                                  borderRadius: BorderRadius.circular(14),
                                  color: tWhite),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Text(
                                      "share_Your_Invite_Code".tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: tSecondaryColor,
                                          fontFamily: "mulish",
                                          fontSize:
                                              isTab(context) ? 12.sp : 14.sp),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: (() => launch(
                                          "https://rubia.services/terme%20and%20conditions.html")),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                      color: tPrimaryColor,
                                                      width: 1.0)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6.0,
                                                    vertical: 1.0),
                                                child: Text('!',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: tPrimaryColor,
                                                        fontFamily: "mulish",
                                                        fontSize: isTab(context)
                                                            ? 8.sp
                                                            : 9.sp)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text("T&Cs",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: tPrimaryColor,
                                                    fontFamily: "mulish",
                                                    fontSize: isTab(context)
                                                        ? 8.sp
                                                        : 10.sp))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                  GestureDetector(
                                    onTap: () async {
                                      await Clipboard.setData(ClipboardData(
                                        text: checkDetails['referal_code']
                                            .toString(),
                                      ));
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //       content: Text("${widget.item['code'].toString()}"),
                                      //     ),

                                      //   );
                                      Fluttertoast.showToast(
                                        msg: 'referal_code'.tr,
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );

                                      // copied successfully
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: tReferColor),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 15),
                                      child: DottedBorder(
                                        color: tPrimaryColor,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(15),
                                        strokeWidth: 1,
                                        dashPattern: [8],
                                        // padding: EdgeInsets.all(6),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: tReferColor),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                  height: 2.5.h,
                                                  image: AssetImage(
                                                      Images.COPYICON),
                                                ),
                                                SizedBox(
                                                  width: 1.w,
                                                ),
                                                Text(
                                                  checkDetails['referal_code']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: tPrimaryColor,
                                                      fontFamily: "mulish",
                                                      fontSize: isTab(context)
                                                          ? 12.sp
                                                          : 15.sp),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 60),
                                    child: Center(
                                      child: Text(
                                        "When_your_friends_sign_up_this_referral_code_you_can_received_a_free_ride"
                                            .tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: tDarkOrangeColor,
                                            fontFamily: "mulish",
                                            fontSize:
                                                isTab(context) ? 8.sp : 10.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'share_your_refer'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: tPrimaryColor,
                                    fontFamily: "mulish",
                                    fontSize: isTab(context) ? 12.sp : 15.sp),
                              ),
                              // GestureDetector(
                              //     image: AssetImage(
                              // GestureDetector(
                              //     image: AssetImage(
                              // GestureDetector(
                              //     image: AssetImage(
                            ],
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Center(
                            child: SizedBox(
                              width: isTab(context) ? 50.w : 60.w,
                              height: isTab(context) ? 6.h : 8.h,
                              child: ButtonWidget(
                                color: tPrimaryColor,
                                child: Text(
                                  "refer".tr,
                                  style: TextStyle(
                                      color: tWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTab(context) ? 10.sp : 16.sp),
                                ),
                                borderRadius: isTab(context) ? 40.0 : 15.0,
                                borderSide: BorderSide(
                                  color: tPrimaryColor,
                                ),
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  startLoading();
                                  Share.share('Share your referral code ' +
                                      checkDetails['referal_code'].toString() +
                                      ' and refer your friend to get earnings \n https://play.google.com/store/apps/details?id=com.rubia.user');

                                  stopLoading();
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _ReferAndEarnState - the data and logic behind its screen
