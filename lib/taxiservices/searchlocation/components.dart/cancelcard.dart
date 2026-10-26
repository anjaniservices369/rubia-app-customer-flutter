// =============================================================================
// WHAT : TAXI: cancel-ride confirmation card.
// NOTES: Cancel calls the server.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/buttonWidget.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/taxiservices/rideservices/riderServices.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:open_payment/open_payment.dart';
import 'package:sizer/sizer.dart';

//   @override
//   State<PriceWidgetCard> createState() => _PriceWidgetCardState();
// }

//   @override
//           color: tWhite,
//           boxShadow: [tBoxShadow],
//           borderRadius: BorderRadiusDirectional.circular(40)),
//           ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//               SizedBox(
//                 width: 4.w,
//               ),
//               Text(
//                 "Price",
//                 style: TextStyle(
//                     fontSize: isTab(context) ? 8.sp : 12.sp,
//                     fontWeight: FontWeight.w500,
//                     color: tBlack),
//               ),
//               SizedBox(
//                 width: 1.5.w,
//               ),
//               Text(
//                 currencySymbol + widget.rideDetails['final_price'].toString(),
//                 style: GoogleFonts.mulish(
//                   color: tBlack,
//                   fontWeight: FontWeight.w800,
//                   fontSize: isTab(context) ? 14.sp : 20.sp,
//                 ),
//               ),
//               Spacer(),
//               SizedBox(
//                 width: isTab(context) ? 22.w : 33.w,
//                 height: isTab(context) ? 5.h : 5.5.h,
//                 child: ButtonWidget(
//                   borderRadius: isTab(context) ? 40.0 : 30.0,
//                   color: tBlack,
//                   child: Text(
//                     'Pay now',
//                     style: GoogleFonts.mulish(
//                         color: tWhite,
//                         fontWeight: FontWeight.w700,
//                         fontSize: isTab(context) ? 9.sp : 16.sp),
//                   ),
//                   onTap: (startLoading, stopLoading, btnState) async {
//                     Map<String, String> param = {
//                       'ride_id': widget.rideData['ride_id'].toString(),
//                     };
//                     print(param);
//                     var res = await RideService().genrateToken(context, param);
//                     if (res != null && res['status'] == 'OK') {
//                       // setState(() {

//                       // });
//                       onPaymentClick(res['detils']['id']);
//                     } else {
//                       stopLoading();
//                       Twl.createAlert(context, 'Oops', res['error'].toString());
//                       stopLoading();
//                     }
//                   },
//                   borderSide: BorderSide(
//                     color: tPrimaryColor,
//                   ),
//                 ),
//               )
//             ])
//           : Container(
//               decoration: BoxDecoration(
//                   color: tBlack,
//                   boxShadow: [tBoxShadow],
//                   borderRadius: BorderRadiusDirectional.circular(40)),
//               // margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               child: Center(
//                 child: Text(
//                   "Don't press back until the payment is completed.",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.mulish(
//                       color: tWhite,
//                       fontWeight: FontWeight.bold,
//                       fontSize: isTab(context) ? 9.sp : 13.sp),
//                 ),
//               ),
//             ),
//     );
//   }


//     OpenPaymentPayload openPaymentPayload = OpenPaymentPayload(
//         accessToken: ACCESSTOKEN,
//         paymentToken: paymentToekn,
//         environment: PaymentEnvironment.live, //PaymentEnvironment.sandbox
//         logoUrl: "assets/images/mainlogo.png",
//         mainColor: "#83025c",
//         errorColor: "#ff0000");

//     await OpenPayment.initiatePayment(
//         openPaymentPayload: openPaymentPayload,
//         onTransactionComplete: (TransactionDetails transactionDetails) async {
//           // Handle transaction result
//           print('Sucessful completed trans..');
//           setState(() {
//             result = transactionDetails.status;
//           });
//           setState(() {
//             isLoading = false;
//           });

//           // Map<String, String> param = {
//           //   'ride_id': widget.rideData['ride_id'].toString(),
//           //   'payment_token': paymentToekn
//           // };
//           // print(param);
//           // if (transactionDetails.status != 'cancelled') {
//           //   var res = await RideService().paymentstatus(context, param);
//           //   if (res != null && res['status'] == 'OK') {
//           //     setState(() {
//           //       RideService().updatePaymentStatusSkipper(
//           //         uid: widget.rideData['driver']['id'],
//           //         status: PAYMENT_STATUS_PAID,
//           //       );
//           //       // widget.rideData['payment_status'] = PAYMENT_STATUS_PAID;
//           //       RideService().updatePaymentStatus(
//           //         uid: widget.rideData['userId'],
//           //         status: PAYMENT_STATUS_PAID,
//           //       );

//           //       res['payment_status'] == PAYMENT_STATUS_PAID
//           //           ? Twl.forceNavigateTo(
//           //               context,
//           //               AddRating(
//           //                 rideData: widget.rideData,
//           //               ))
//           //           : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           //               behavior: SnackBarBehavior.floating,
//           //               content: Text('Payment failed'),
//           //             ));
//           //       setState(() {
//           //         isLoading = false;
//           //       });
//           //     });
//             } else {
//               setState(() {
//                 // widget.rideData['payment_status'] = PAYMENT_STATUS_FAILED;
//                 // RideService().updatePaymentStatus(
//                 //   uid: widget.rideData['userId'],
//                 //   status: PAYMENT_STATUS_FAILED,
//                 // );
//                 // RideService().updatePaymentStatusSkipper(
//                 //   uid: widget.rideData['driver']['id'],
//                 //   status: PAYMENT_STATUS_PAID,
//                 // );
//                 isLoading = false;
//               });
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 behavior: SnackBarBehavior.floating,
//                 content: Text(res['error'].toString()),
//               ));
//             }
//             print(result);
//           }
//         },
//         onError: (String error) {
//           // Handle integration error
//           setState(() {
//             result = error;
//           });
//           // print('failed failed trans..');
//           Twl.createAlert(context, 'Payment failed', error.toString());
//           print(error.toString());
//         });
//   }
// }

// >>> START: CancelWidgetCard - screen/widget shell (the visible part is in its State class)
class CancelWidgetCard extends StatefulWidget {
  const CancelWidgetCard({Key? key, this.rideData, this.rideDetails})
      : super(key: key);
  final rideData;
  final rideDetails;
  @override
  State<CancelWidgetCard> createState() => _CancelWidgetCardState();
}
// <<< END: CancelWidgetCard - screen/widget shell (the visible part is in its State class)

// >>> START: _CancelWidgetCardState - the data and logic behind its screen
class _CancelWidgetCardState extends State<CancelWidgetCard> {
  String? result;
  bool isLoading = true;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: tWhite,
          boxShadow: [tBoxShadow],
          borderRadius: BorderRadiusDirectional.circular(40)),
      // margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: isLoading
          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                width: 4.w,
              ),
              Text(
                "Price",
                style: TextStyle(
                    fontSize: isTab(context) ? 8.sp : 12.sp,
                    fontWeight: FontWeight.w500,
                    color: tBlack),
              ),
              SizedBox(
                width: 1.5.w,
              ),
              Text(
                currencySymbol + widget.rideData['ride_fare'].toString(),
                style: GoogleFonts.mulish(
                  color: tBlack,
                  fontWeight: FontWeight.w800,
                  fontSize: isTab(context) ? 14.sp : 20.sp,
                ),
              ),
              Spacer(),
              SizedBox(
                width: isTab(context) ? 35.w : 45.w,
                height: isTab(context) ? 5.h : 5.5.h,
                child: ButtonWidget(
                  borderRadius: isTab(context) ? 40.0 : 30.0,
                  color: tPrimaryColor,
                  child: Text(
                    "Cancel ride",
                    style: GoogleFonts.mulish(
                        color: tWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: isTab(context) ? 9.sp : 16.sp),
                  ),
                  onTap: (startLoading, stopLoading, btnState) async {
                    startLoading();

                    Map<String, String> param = {
                      'ride_id': widget.rideData['ride_id'].toString(),
                    };
                    var res = await UserAPI().SkippercancelRide(context, param);
                    if (res != null && res['status'] == 'OK') {
                      RideService().removeMiddleSkipperRequest(
                          uid: widget.rideData['userId'],
                          skipperId: widget.rideData['driver']['id']);
                      Twl.navigateTo(
                          context,
                          BottomNavigation(
                            tabIndexId: 0,
                          ));
                    } else {
                      stopLoading();
                      Twl.createAlert(context, 'Oops', res['error'].toString());
                      stopLoading();
                    }

                    stopLoading();
                  },
                  borderSide: BorderSide(
                    color: tPrimaryColor,
                  ),
                ),
              )
            ])
          : Container(
              decoration: BoxDecoration(
                  color: tBlack,
                  boxShadow: [tBoxShadow],
                  borderRadius: BorderRadiusDirectional.circular(40)),
              // margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Center(
                child: Text(
                  "Don't press back until the payment is completed.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                      color: tWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: isTab(context) ? 9.sp : 13.sp),
                ),
              ),
            ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _CancelWidgetCardState - the data and logic behind its screen
