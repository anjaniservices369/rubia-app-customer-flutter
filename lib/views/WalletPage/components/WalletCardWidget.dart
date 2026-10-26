// =============================================================================
// WHAT : Wallet balance card with 'Add money'.
// NOTES: Server: add-balance.
// =============================================================================
import 'dart:io';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/constants.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../globalWidgets/textformfieldWidget.dart';
import '../../../responsive.dart';
// import 'package:open_payment/open_payment.dart';

// >>> START: WalletCardWidget - screen/widget shell (the visible part is in its State class)
class WalletCardWidget extends StatefulWidget {
  const WalletCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletCardWidget> createState() => _WalletCardWidgetState();
}
// <<< END: WalletCardWidget - screen/widget shell (the visible part is in its State class)

// >>> START: _WalletCardWidgetState - the data and logic behind its screen
class _WalletCardWidgetState extends State<WalletCardWidget> {
  final TextEditingController _amountController = TextEditingController();
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    fetchBalance();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  String? result;
  bool isLoading = true;
  var walletAmount;
  var resNOK;
  // >>> START: fetchBalance - fetches balance
  fetchBalance() async {
    var response = await UserAPI().walletAmount(
      context,
    );
    if (response != null && response['status'] == 'OK') {
      setState(() {
        walletAmount = response['details'];
      });
    } else {
      resNOK = response['status'];
    }
  }
  // <<< END: fetchBalance - fetches balance

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return walletAmount == null
        ? SpinKitThreeBounce(
            color: tPrimaryColor,
            size: 20.0,
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: isTab(context) ? 30.h : 20.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: SvgPicture.asset(
                      "assets/wallet.svg",
                      fit: BoxFit.fill,
                      height: 210,
                    ),
                  ),
                  Positioned(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        walletAmount == null
                            ? Text(
                                currencySymbol + '0',
                                style: GoogleFonts.mulish(
                                    fontSize: isTab(context) ? 23.sp : 27.sp,
                                    fontWeight: FontWeight.w800,
                                    color: tWhite),
                              )
                            : Text(
                                currencySymbol + walletAmount.toString(),
                                style: GoogleFonts.mulish(
                                    fontSize: isTab(context) ? 23.sp : 27.sp,
                                    fontWeight: FontWeight.w800,
                                    color: tDarkNavyblue),
                              ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          'available_balance'.tr,
                          style: GoogleFonts.mulish(
                              fontSize: isTab(context) ? 10.sp : 13.sp,
                              fontWeight: FontWeight.w800,
                              color: tWhite),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: isTab(context) ? 4.h : 0,
                      right: isTab(context) ? 0 : 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 2.h),
                        child: Transform.scale(
                          scale: isTab(context) ? 1 : 1,
                          child: (Platform.isIOS)
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    createAlert(context);
                                  },
                                  child: Icon(
                                    Icons.add_circle,
                                    size: isTab(context) ? 50 : 35,
                                    color: tWhite,
                                  ),
                                ),
                        ),
                      ))
                ],
              ),
            ),
          );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: createAlert - shows a simple message pop-up
  createAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'enter_amount'.tr,
            style: TextStyle(color: tSecondaryColor),
          )),
          content: TextFormFieldWidgets(
            style: TextStyle(fontWeight: FontWeight.w600),
            controller: _amountController,
            validator: (value) {
              final RegExp regex = RegExp(r'^[0-9]');
              if (value!.isEmpty) {
                return 'amount_empty'.tr;
              } else if (value != null && value > 5) {
                return 'amount_exceeded'.tr;
              }
            },
            inputFormater: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(
                "[0-9]",
              )),
              LengthLimitingTextInputFormatter(5),
            ],
            keyboardTyp: TextInputType.number,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            fillcolor: tBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hinttext: 'Enter_amount'.tr,
            hintStyl: TextStyle(
                color: tGray,
                fontSize: isTab(context) ? 7.sp : 10.sp,
                fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    Twl.navigateBack(context);
                  },
                  child: Container(
                      width: 30.w,
                      padding: EdgeInsets.symmetric(
                        vertical: isTab(context) ? 8 : 5,
                        // horizontal: isTab(context) ? 10.w : 5.w
                      ),
                      decoration: BoxDecoration(
                          color: tWhite,
                          // boxShadow: [tBackbtnBoxShadow],
                          border: Border.all(color: tGray, width: 0.5),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          'Cancel'.tr,
                          style: TextStyle(
                              color: tGray,
                              fontSize: isTab(context) ? 10.sp : 13.sp),
                        ),
                      )),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Container(
                  width: 30.w,
                  height: 5.h,
                  child: ButtonWidget(
                    borderSide: BorderSide(color: tappbarclr),
                    color: tappbarclr,
                    borderRadius: isTab(context) ? 25.0 : 15.0,
                    child: Text('add'.tr,
                        style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: isTab(context) ? 10.sp : 13.sp)),
                    onTap: (startLoading, stopLoading, btnState) async {
                      startLoading();
                      Map<String, String> param = {
                        'amount': _amountController.text
                      };
                      var res = await UserAPI().addMoneyApi(context, param);
                      if (res != null && res['status'] == 'OK') {
                        setState(() {
                          Twl.forceNavigateTo(
                              context,
                              BottomNavigation(
                                tabIndexId: 2,
                              ));
                          res['details']['id'];
                          // onPaymentClick(res['details']['id']);
                        });
                        stopLoading();
                      } else {
                        stopLoading();
                        Twl.createAlert(
                            context, 'Oops', res['error'].toString());
                        stopLoading();
                      }
                      stopLoading();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  // <<< END: createAlert - shows a simple message pop-up

  //   OpenPaymentPayload openPaymentPayload = OpenPaymentPayload(
  //       accessToken: ACCESSTOKEN,
  //       paymentToken: paymentToekn,
  //       environment: PaymentEnvironment.live, //PaymentEnvironment.sandbox
  //       logoUrl: "assets/images/mainlogo.png",
  //       mainColor: "#83025c",
  //       errorColor: "#ff0000");

  //   await OpenPayment.initiatePayment(
  //       openPaymentPayload: openPaymentPayload,
  //       onTransactionComplete: (TransactionDetails transactionDetails) async {
  //         print('TransactionDetails');
  //         print(transactionDetails.status.toString());
  //         // Handle transaction result
  //         print('Sucessful completed trans..');
  //         print('result...');
  //         print(result);
  //         setState(() {
  //           result = transactionDetails.status;
  //         });
  //         setState(() {
  //           isLoading = false;
  //         });

  //         Map<String, String> param = {'payment_token': paymentToekn};
  //         print(param);
  //         if (transactionDetails.status != 'cancelled') {
  //           var res = await UserAPI().addMoneyApi(context, param);
  //           if (res != null && res['status'] == 'OK') {
  //             setState(() {
  //               Twl.forceNavigateTo(context, WalletPage());
  //               setState(() {
  //                 isLoading = false;
  //               });
  //             });
  //           } else {
  //             setState(() {
  //               isLoading = false;
  //             });
  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //               behavior: SnackBarBehavior.floating,
  //               content: Text(res['error']),
  //             ));
  //           }
  //           print(result);
  //         }
  //       },
  //       onError: (String error) {
  //         // Handle integration error
  //         setState(() {
  //           result = error;
  //         });
  //         print('failed failed trans..');
  //         Twl.createAlert(context, 'Oops', error.toString());
  //         print(error.toString());
  //       });
  // }
}
// <<< END: _WalletCardWidgetState - the data and logic behind its screen
