// =============================================================================
// WHAT : Refer & Earn: share code and see rewards.
// NOTES: Server: refer-earn.
// =============================================================================
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:base_project_flutter/globalWidgets/legalDocumentPage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_plus/share_plus.dart' import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        backgroundColor: tBackground,
        appBar: AppBar(
          elevation: 1,
          titleSpacing: 7,
          backgroundColor: tYellow,

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
                color: tDarkNavyblue,
                fontFamily: "mulish",
                fontSize: 18,
                fontWeight: FontWeight.w700),
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Form(
            key: _formKey,
            child: checkDetails == null
                ? SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(color: tPrimaryColor),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [tBoxShadow],
                        ),
                        child: Column(
                          children: [
                            Image(
                              height: 160,
                              fit: BoxFit.contain,
                              image: AssetImage(Images.REFERFRENDSIMG),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'refer_friends'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tDarkNavyblue,
                                fontFamily: 'mulish',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'earn_Upto_₹100_Per_Friend_You_Invite'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tGray,
                                fontFamily: 'mulish',
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: tYellow.withValues(alpha: 0.2),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.card_giftcard_rounded,
                                    color: tPrimaryColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'my_rewards'.tr,
                                      style: TextStyle(
                                        color: tDarkNavyblue,
                                        fontFamily: 'mulish',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    referEarnings != null
                                        ? currencySymbol +
                                            referEarnings['earnings'].toString()
                                        : currencySymbol,
                                    style: TextStyle(
                                      color: tDarkNavyblue,
                                      fontFamily: 'mulish',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [tBoxShadow],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'share_Your_Invite_Code'.tr,
                                    style: TextStyle(
                                      color: tDarkNavyblue,
                                      fontFamily: 'mulish',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  // the app's own Terms page (the old link had a typo and opened the company home page)
                                  onPressed: () => LegalDocumentPage.open(
                                      context, LegalDocumentPage.terms, "Terms and Conditions"),
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: tPrimaryColor,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'T&Cs',
                                    style: TextStyle(
                                      color: tPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(
                                  text: checkDetails['referal_code'].toString(),
                                ));
                                Fluttertoast.showToast(
                                  msg: 'referal_code'.tr,
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: tDarkNavyblue,
                                  textColor: Colors.white,
                                  fontSize: 16,
                                );
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 14,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: tReferColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: tPrimaryColor.withValues(alpha: 0.7),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.copy_rounded,
                                      color: tPrimaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        checkDetails['referal_code'].toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: tDarkNavyblue,
                                          fontFamily: 'mulish',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 32),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'When_your_friends_sign_up_this_referral_code_you_can_received_a_free_ride'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tGray,
                                fontFamily: 'mulish',
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'share_your_refer'.tr,
                              style: TextStyle(
                                color: tDarkNavyblue,
                                fontFamily: 'mulish',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ButtonWidget(
                                color: tPrimaryColor,
                                child: Text(
                                  'refer'.tr,
                                  style: TextStyle(
                                    color: tWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                borderRadius: 14.0,
                                borderSide: BorderSide(color: tPrimaryColor),
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  startLoading();
                                  Share.share(
                                    'Share your referral code ${checkDetails['referal_code']} and refer your friend to get earnings \n https://play.google.com/store/apps/details?id=com.rubia.user',
                                  );
                                  stopLoading();
                                },
                              ),
                            ),
                          ],
                        ),
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
