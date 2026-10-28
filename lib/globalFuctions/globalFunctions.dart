// =============================================================================
// WHAT : Shared helper functions (class Twl): open/close screens, show alerts
//        and pop-ups, pick a photo, format dates, cancellation-charge dialogs.
// NOTES: Think of it as the app's toolbox; many screens call it.
// =============================================================================
import 'dart:io';
import 'package:base_project_flutter/responsive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../constants/constants.dart';
import '../views/Bookings/components/rideDetailsView/components/rideInfo.dart';
import '../views/RideBooking/selectLocationPage.dart';
import '../views/bottomNavigation.dart/bottomNavigation.dart';



// >>> START: Twl - shared helper functions used by many screens
class Twl {
  bool isLoading = true;

  late String username;
  late String sessionId;
  late String deviceToken;
  late String authCode;



  static get androidUiSettings => null;
  static get iosUiSettings => null;

//getImage start

  // >>> START: getImage - lets the customer take or choose a photo and crop it
  static getImage(String type) async {
    late File? _image;

    bool _loading = true;
    late String url;
    final picker = ImagePicker();
    var pickedFile;
    if (type == 'camera') {
      pickedFile =
      await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 80);
    } else if (type == 'gallery') {
      pickedFile =
      await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 80);
    }
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: tPrimaryColor,
            toolbarWidgetColor: tWhite,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
          ),
        ]);
    File? croppedFile =
        croppedImage != null ? File(croppedImage.path) : null;
    // setState(() {
    _loading = false;
    if (croppedFile != null) {
      File _file = File(croppedFile.path);
      if (_file.lengthSync() < 20000000) {
        _image = File(croppedFile.path);
        return _image;
      } else {}
      _loading = true;
    } else {
    }
    // });

  }
  // <<< END: getImage - lets the customer take or choose a photo and crop it
//getImage end

  // >>> START: createAlert - shows a simple message pop-up
  static createAlert(BuildContext context, error, errormsg) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(error),
            content: Text(errormsg),
          );
        });
  }
  // <<< END: createAlert - shows a simple message pop-up

  // >>> START: willpopAlert - asks "are you sure?" before leaving a screen
  static willpopAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to exit?'),
          // content: SingleChildScrollView(
          //     ],
          //   ),
          // ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    navigateBack(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      // gradient: tPrimaryGradientColor,
                        border: Border.all(width: 1, color: tPrimaryColor),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: tPrimaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: tPrimaryColor),

                        // gradient: tPrimaryGradientColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'Ok',
                      style: TextStyle(color: tPrimaryColor),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
  // <<< END: willpopAlert - asks "are you sure?" before leaving a screen

  // >>> START: navigateTo - opens another screen on top of the current one
  /// Answers false ("handled") so a screen can use it as `onWillPop: () => Twl.navigateTo(...)`: with no answer the system treated Back as
  /// "go ahead and close" and removed the screen that had just been opened, so the phone's Back key could close the app.
  static Future<bool> navigateTo(BuildContext context, page) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    return false;
  }
  // <<< END: navigateTo - opens another screen on top of the current one

  // >>> START: navigateBack - goes back to the previous screen
  static navigateBack(BuildContext context) async {
    Navigator.pop(context);
  }
  // <<< END: navigateBack - goes back to the previous screen

  // >>> START: errorHandler - shows a message for an HTTP error such as 404 or 500
  static errorHandler(BuildContext context, errorRes) async {
    switch (errorRes) {
      case 301:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Moved Permanently'),
        ));
        break;
      case 302:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Found'),
        ));
        break;
      case 401:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unauthorized'),
        ));
        break;
      case 403:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Forbidden'),
        ));

        break;
      case 404:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Not Found'),
        ));
        break;
      case 500:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Internal Server Error'),
        ));
        break;
      case 502:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Bad Gateway'),
        ));
        break;
      case 503:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Service Unavailable'),
        ));

        break;
      case 504:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gateway Timeout'),
        ));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Oops!...'),
        ));
    }
  }
  // <<< END: errorHandler - shows a message for an HTTP error such as 404 or 500

  // >>> START: forceNavigateTo - opens a screen and removes the ones behind it
  /// Answers false ("handled"), like navigateTo, so `onWillPop: () => Twl.forceNavigateTo(...)` does not close the new screen as well.
  static Future<bool> forceNavigateTo(BuildContext context, page) async {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => page));
    return false;
  }
  // <<< END: forceNavigateTo - opens a screen and removes the ones behind it

  // >>> START: backToTab - the phone's Back key: opens a tab of the bottom bar and says "handled"
  /// For `WillPopScope(onWillPop: () => Twl.backToTab(context, 2))`. The old screens returned the result of forceNavigateTo
  /// (nothing), which let the system close one more screen after the new one was opened, so Back could leave the app.
  /// Opens the tab (0 Home, 1 My Bookings, 2 Profile) with nothing left behind it and answers false (Back is handled).
  static Future<bool> backToTab(BuildContext context, int tabIndexId) async {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BottomNavigation(tabIndexId: tabIndexId)),
        (route) => false);
    return false;
  }
  // <<< END: backToTab - the phone's Back key: opens a tab of the bottom bar and says "handled"

  // >>> START: goHomeAfterRating - thanks the customer and returns to Home
  /// Called after a rating has been saved: shows a thank-you message and opens
  /// Home with no earlier screen left behind it, so Back never returns to the
  /// finished ride.
  static void goHomeAfterRating(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Thanks for your rating')));
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BottomNavigation(tabIndexId: 0)),
        (route) => false);
  }
  // <<< END: goHomeAfterRating - thanks the customer and returns to Home

  // >>> START: dateFormate - date formate
  static dateFormate(now) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final String formatted = formatter.format(DateTime.parse(now.toString()));
    return formatted;
  }
  // <<< END: dateFormate - date formate

  // >>> START: dateActualFormat - date actual format
  static String dateActualFormat(DateTime now) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }
  // <<< END: dateActualFormat - date actual format

  // >>> START: dateActualFormate - date actual formate
  static dateActualFormate(now) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    final String formatted = formatter.format(DateTime.parse(now.toString()));
    return formatted;
  }
  // <<< END: dateActualFormate - date actual formate

  // >>> START: dateActual - date actual
  static dateActual(now) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    // Formats the date it is given (it used to always print today's date, so
    // a booking for tomorrow was shown as today).
    final DateTime date = DateTime.tryParse(now.toString()) ?? DateTime.now();
    final String formatted = formatter.format(date);
    return formatted;
  }
  // <<< END: dateActual - date actual

  // >>> START: formatDate - format date
  static String formatDate(String dateString) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateTime dateTime;

    try {
      dateTime = formatter.parse(dateString);
    } catch (e) {
      return ''; // Return an empty string or handle the error as needed
    }

    return formatter.format(dateTime);
  }
  // <<< END: formatDate - format date

  // >>> START: convertDateFormat - convert date format
  String convertDateFormat(
      String inputDate, String inputFormat, String outputFormat) {
    final DateFormat inputFormatter = DateFormat(inputFormat);
    final DateFormat outputFormatter = DateFormat(outputFormat);

    final DateTime dateTime = inputFormatter.parse(inputDate);
    final String formattedDate = outputFormatter.format(dateTime);

    return formattedDate;
  }
  // <<< END: convertDateFormat - convert date format

  // >>> START: timeFormate - time formate
  static timeFormate(now) {
    final inputFormat = DateFormat('HH:mm:ss');
    final outputFormat = DateFormat('hh:mm a');
    final dateTime = inputFormat.parse(now);
    return outputFormat.format(dateTime);
  }
  // <<< END: timeFormate - time formate

  // Day Formate
  // >>> START: dayFormate - day formate
  static dayFormate(now) {
    final DateFormat formatter =
    DateFormat('EEEE, d MMM,').format(now) as DateFormat;

    final String formatted = formatter.format(DateTime.parse(now.toString()));
    return formatted;
  }
  // <<< END: dayFormate - day formate

  // >>> START: wallateShowDailogBox - wallate show dailog box
  static wallateShowDailogBox(context, dynamic walletAmount) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, set) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            backgroundColor: tWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.red,
                    size: 55.0,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Low Wallet Balance",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontSize: isTab(context) ? 12.sp : 14.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You have ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),
                          Text(
                            'Insufficient Balance',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tPrimaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),
                          Text(
                            ' to book rides.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),

                          // if (walletAmount == null)
                          //   Text(
                          //     currencySymbol + '0',
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.w400,
                          //         color: tPrimaryColor,
                          //         fontSize: isTab(context) ? 10.sp : 12.sp),
                          //     currencySymbol + walletAmount,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.w400,
                          //         color: tPrimaryColor,
                          //         fontSize: isTab(context) ? 10.sp : 12.sp),
                          //   ),
                          //     walletAmount != null && walletAmount < 0
                          //         ? Text(
                          //             " negative balance.",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w400,
                          //                 color: tSecondaryColor,
                          //                 fontSize: isTab(context) ? 10.sp : 12.sp),
                          //           )
                          //         : Text(
                          //             "  balance.",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w400,
                          //                 color: tSecondaryColor,
                          //                 fontSize: isTab(context) ? 10.sp : 12.sp),
                          //           ),
                        ],
                      ),
                      Text(
                        "Your wallet balance is low.",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 10.sp : 12.sp),
                      ),
                      Text(
                        "Add money to your wallet to continue.",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 10.sp : 12.sp),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Twl.navigateBack(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                      child: Text(
                                        "Go Back",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tSecondaryColor,
                                            fontSize:
                                            isTab(context) ? 10.sp : 12.sp),
                                      )),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Twl.forceNavigateTo(
                                      context,
                                      BottomNavigation(
                                        tabIndexId: 2,
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration:
                                  BoxDecoration(color: tPrimaryColor),
                                  child: Center(
                                      child: Text(
                                        "Recharge Now",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tSecondaryColor,
                                            fontSize:
                                            isTab(context) ? 10.sp : 12.sp),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
  // >>> START: CancellationChargesBox - shows the pending cancellation fee and asks to pay
  // <<< END: wallateShowDailogBox - wallate show dailog box
  // >>> START: CancellationChargesBox - shows the pending cancellation fee and asks to pay
  static CancellationChargesBox(context, dynamic walletAmount) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, set) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            backgroundColor: tWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Icon(
                    Icons.warning_outlined,
                    color: Colors.red,
                    size: 55.0,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Note",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontSize: isTab(context) ? 12.sp : 14.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your previous ride cancellation",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'charges ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 10.sp : 12.sp),
                              ),
                              Text(
                                currencySymbol + walletAmount.toString() +' will be added',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 10.sp : 12.sp),
                              ),

                            ],
                          ),
                          Text(
                            "in your upcoming Ride.",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SelectLocationPage()),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: tPrimaryColor,
                                  ),
                                  child: Center(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tWhite,
                                            fontSize:
                                            isTab(context) ? 10.sp : 12.sp),
                                      )),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
  // <<< END: CancellationChargesBox - shows the pending cancellation fee and asks to pay
  // >>> START: CancellationChargesAlert - warns about a cancellation fee
  // <<< END: CancellationChargesBox - shows the pending cancellation fee and asks to pay
  // >>> START: CancellationChargesAlert - warns about a cancellation fee
  static CancellationChargesAlert(context, dynamic walletAmount,{required bookingDetails}) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, set) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            backgroundColor: tWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Icon(
                    Icons.warning_outlined,
                    color: Colors.red,
                    size: 55.0,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Alert",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontSize: isTab(context) ? 12.sp : 14.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You will be charged",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),
                          Text(
                            currencySymbol + walletAmount.toString() +' in your upcoming ride',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),
                          Text(
                            "for cancellation",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 10.sp : 12.sp),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    // expand: false,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0),
                                        child: CancelRideBottomSheet(bookingDetails: bookingDetails)),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: tPrimaryColor,
                                  ),
                                  child: Center(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tWhite,
                                            fontSize:
                                            isTab(context) ? 10.sp : 12.sp),
                                      )),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
  // <<< END: CancellationChargesAlert - warns about a cancellation fee
  // <<< END: CancellationChargesAlert - warns about a cancellation fee
}
// <<< END: Twl - shared helper functions used by many screens

// >>> START: isWithinIndia - rough bounding-box check for a map-picked point, used to catch a reverse-geocoded result for a far-away point (the
/**
 * Rough bounding-box check for a map-picked point, used to catch a reverse-geocoded result for a far-away point (the
 * place-picker plugin can occasionally return one, a stale response for a different query winning an async race)
 * instead of trusting it and sending bogus coordinates to check-boundary.
 */
// >>> START: isWithinIndia - tells whether within india
bool isWithinIndia(double lat, double lng) {
  return lat >= 6.0 && lat <= 37.5 && lng >= 68.0 && lng <= 97.5;
}
// <<< END: isWithinIndia - tells whether within india
// <<< END: isWithinIndia
