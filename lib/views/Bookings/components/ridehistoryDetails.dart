// =============================================================================
// WHAT : Details of a finished taxi ride.
// NOTES: Server: taxi ride info.
// =============================================================================
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../constants/imageConstant.dart';
import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonIconWidget.dart';
import '../../../responsive.dart';
import '../../../taxiservices/Ride/completedride/billDetails.dart';
import '../../../taxiservices/Ride/completedride/priceCard.dart';

// >>> START: RiderHistoryDetails - screen/widget shell (the visible part is in its State class)
class RiderHistoryDetails extends StatefulWidget {
  const RiderHistoryDetails({Key? key, this.rideData, this.bookingDetails}) : super(key: key);
  final bookingDetails;
  final rideData;

  @override
  State<RiderHistoryDetails> createState() => _RiderHistoryDetailsState();
}
// <<< END: RiderHistoryDetails - screen/widget shell (the visible part is in its State class)

// >>> START: _RiderHistoryDetailsState - the data and logic behind its screen
class _RiderHistoryDetailsState extends State<RiderHistoryDetails> {
  var rideDetails;
  var details;
  var resNOK;
  // >>> START: getTaxiInfo - gets taxi info
  getTaxiInfo() async {
    details = await UserAPI().taxiRideInfo(context, widget.bookingDetails['id'].toString());
    if (details != null) {
      if (details['status'] == 'OK') {
        if (mounted) {
          setState(() {
            rideDetails = details['detail'];
          });
        }
      } else {
        if (mounted) {
          setState(() {
            resNOK = details['status'];
          });
        }
      }
    }
  }
  // <<< END: getTaxiInfo - gets taxi info

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaxiInfo();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackground,
      appBar: AppBar(
          elevation: 0,
          titleSpacing: 7,
          backgroundColor: tPrimaryColor,
          centerTitle: true,
          // automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Twl.navigateBack(context);
              },
              child: Padding(
                padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                child: BackIconWidget(),
              )),
          title: Text(
            'Ride details',
            style: GoogleFonts.mulish(
              color: tDarkNavyblue,
              fontWeight: FontWeight.w700,
              fontSize: isTab(context) ? 10.sp : 17.sp,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await launchURL(CHAT_LINK);
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Text(
                      'Chat',
                      style: GoogleFonts.mulish(
                        color: tDarkNavyblue,
                        fontSize: isTab(context) ? 12.sp : 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
      body: rideDetails == null
          ? Align(
              alignment: Alignment.center,
              child: SpinKitThreeBounce(
                color: tPrimaryColor,
                size: 20.0,
              ))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        ' Driver details:',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: tBlack, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 9.sp : 12.sp),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: tPrimaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildDriverProfileImage(rideDetails),
                                SizedBox(width: 2.w),
                                buildDriverInfo(context, rideDetails),
                                Spacer(),
                                buildContactButton(
                                  context,
                                  iconPath: Images.CALL_ICON,
                                  onTap: () => callDriver(rideDetails),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            buildDriverVehicleInfo(context, rideDetails),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Text(
                        ' Address details:',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: tBlack, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 9.sp : 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      elevation: 4.0, // Add elevation (box shadow) to the card
                      shadowColor: Colors.grey.withOpacity(0.5), // Customize the shadow color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners for the card
                      ),
                      child: Row(
                        children: [
                          buildLocationIcon(context, rideDetails),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildAddressText(context, rideDetails['pickup_address'], rideDetails),
                                Divider(
                                  height: 4.h,
                                  thickness: 0.9,
                                  color: tDividerColor,
                                ),
                                buildAddressText(context, rideDetails['drop_address'], rideDetails),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Text(
                        ' Bill details:',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: tBlack, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 9.sp : 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  BillDetailsCardWidgt(rideData: rideDetails, rideDetails: rideDetails),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Text(
                        ' Ride status:',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: tBlack, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 9.sp : 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  RideStatusCardWidgt(rideData: rideDetails, rideDetails: rideDetails),
                  // GestureDetector(
                  //     // onTap: () {
                  //     //   Twl.navigateTo(context, BookRideView());
                  //     // },
                  //     child: PayAtDropCardWidget(rideData: rideDetails)),
                  rideDetails['status'] == TAXI_STATUS_COMPLETE_RIDE
                      // &&
                      //         rideDetails['payment_method'] == '4'
                      ? SizedBox(
                          height: 2.h,
                        )
                      : Container(),
                  rideDetails['status'] == TAXI_STATUS_COMPLETE_RIDE
                      // &&
                      //         rideDetails['payment_method'] == '4'
                      ? PriceWidgetCard(
                          rideData: rideDetails,
                          rideDetails: rideDetails,
                        )
                      : Container(),
                  // OTPCard(rideData:rideDetails),
                  SizedBox(
                    height: 5.h,
                  ),
                ]),
              ),
            ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  //       Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: tWhite,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [tBoxShadow],
  //           ),
  //           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.5.h),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 4),
  //                 child: Text(
  //                   'OTP : ',
  //                   style: GoogleFonts.mulish(
  //                     color: tBlack,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: isTab(context) ? 8.sp : 12.sp,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: 1.8.w),
  //               Text(
  //                 rideDetails['otp'].toString(),
  //                 style: GoogleFonts.mulish(
  //                   color: tBlack,
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: isTab(context) ? 10.sp : 17.sp,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  // >>> START: launchURL - launch url
  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
    }
  }
  // <<< END: launchURL - launch url

  // >>> START: _textMe - text me
  _textMe() async {
    // Android
    const uri = 'sms:+39 348 060 888?body=hello%20there';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:0039-222-060-888?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  // <<< END: _textMe - text me

  // >>> START: _buildDriverProfileImage - build driver profile image
  Widget _buildDriverProfileImage() {
    final profileImage = rideDetails['driver']['profile_image'];
    final isProfileImageAvailable = profileImage != null && profileImage.isNotEmpty;

    return Container(
      height: isProfileImageAvailable ? 5.h : 10.h,
      width: 10.w,
      decoration: BoxDecoration(
        border: Border.all(color: tBlack, width: 2),
        shape: BoxShape.circle,
        image: isProfileImageAvailable ? DecorationImage(image: NetworkImage(profileImage), fit: BoxFit.cover) : null,
      ),
      child: isProfileImageAvailable ? null : Icon(Icons.person, size: 20, color: tBlack),
    );
  }
  // <<< END: _buildDriverProfileImage - build driver profile image

  // >>> START: _buildDriverInfo - build driver info
  Widget _buildDriverInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rideDetails['driver']['name'] ?? '',
          style: TextStyle(
            color: tBlack,
            fontWeight: FontWeight.w600,
            fontSize: isTab(context) ? 10.sp : 14.sp,
          ),
        ),
        SizedBox(height: 0.6.h),
        Text(
          'Skipper',
          style: TextStyle(
            color: tBlack,
            fontWeight: FontWeight.w400,
            fontSize: isTab(context) ? 7.sp : 10.sp,
          ),
        ),
      ],
    );
  }
  // <<< END: _buildDriverInfo - build driver info

  // >>> START: _buildContactButton - build contact button
  Widget _buildContactButton({required String iconPath, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 5.h,
        decoration: BoxDecoration(
          color: tWhite,
          shape: BoxShape.circle,
        ),
        // padding: EdgeInsets.all(4.0),
        child: Image.asset(iconPath, scale: isTab(context) ? 3.6 : 4),
      ),
    );
  }
  // <<< END: _buildContactButton - build contact button

  // >>> START: _buildDriverVehicleInfo - build driver vehicle info
  Widget _buildDriverVehicleInfo() {
    return Row(
      children: [
        Image.asset(Images.VEHICLE, scale: isTab(context) ? 3 : 4.5),
        SizedBox(width: 1.w),
        Text(
          rideDetails['driver']['vehicle_type'] ?? '',
          style: GoogleFonts.mulish(
            color: tBlack,
            fontWeight: FontWeight.w500,
            fontSize: isTab(context) ? 7.sp : 10.sp,
          ),
        ),
        SizedBox(width: 5.w),
        Image.asset(Images.SELECTED_BIKE, scale: isTab(context) ? 3 : 4.5),
        SizedBox(width: 1.w),
        Text(
          rideDetails['driver']['vehicle_number'] ?? '',
          style: GoogleFonts.mulish(
            color: tBlack,
            fontWeight: FontWeight.w600,
            fontSize: isTab(context) ? 7.sp : 10.sp,
          ),
        ),
      ],
    );
  }
  // <<< END: _buildDriverVehicleInfo - build driver vehicle info

  // >>> START: _callDriver - call driver
  void _callDriver() {
    final driverContact = rideDetails['driver']['driver_contact'];
    if (driverContact != null && driverContact.isNotEmpty) {
      launch("tel://" + driverContact);
    } else {
      // Handle error: The phone number is not valid or empty.
    }
  }
  // <<< END: _callDriver - call driver

  // >>> START: _buildLocationIcon - build location icon
  Widget _buildLocationIcon(String iconPath) {
    return Padding(
      padding: EdgeInsets.all(8.0), // Adjust the padding as needed
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isTab(context) ? 12 : 8),
            decoration: BoxDecoration(
              color: tBackground,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              iconPath,
              scale: isTab(context) ? 2 : 3.5,
            ),
          ),
          DottedLine(
            direction: Axis.vertical,
            lineLength: 30,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: tDotted,
            dashGapLength: 4.0,
            dashGapRadius: 0.0,
          ),
          Container(
            padding: EdgeInsets.all(isTab(context) ? 12 : 8),
            decoration: BoxDecoration(
              color: tBackground,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              Images.REDLOCATIONICON,
              scale: isTab(context) ? 2 : 3.5,
            ),
          ),
        ],
      ),
    );
  }
  // <<< END: _buildLocationIcon - build location icon

  // >>> START: _buildAddressText - build address text
  Widget _buildAddressText(String address) {
    return Text(
      address,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.mulish(
        color: tDarkNavyblue,
        fontWeight: FontWeight.w600,
        fontSize: isTab(context) ? 9.sp : 11.sp,
      ),
    );
  }
  // <<< END: _buildAddressText - build address text

  // >>> START: getStatusMessage - gets status message
  String getStatusMessage(int status) {
    switch (status) {
      case TAXI_STATUS_NEW_REQUEST:
        return "New ride request";
      case TAXI_STATUS_RIDE_BOOKED:
        return "Ride booked";
      case TAXI_STATUS_CANCEL_BY_USER:
        return "Ride canceled by user";
      case TAXI_STATUS_ACCEPTED_BY_SKIPPER:
        return "Your Skipper has accepted the ride";
      case TAXI_STATUS_ON_THE_WAY:
        return "Your Skipper is on the way";
      case TAXI_STATUS_ARRIVED:
        return "Your Skipper has arrived";
      case TAXI_STATUS_CANCEL_BY_SKIPPER:
        return "Ride canceled by Skipper";
      case TAXI_STATUS_START_RIDE:
        return "Your ride has started";
      case TAXI_STATUS_COMPLETE_RIDE:
        return "Ride completed";
      case TAXI_STATUS_AMOUNT_COLLECTED:
        return "Amount collected";
      case TAXI_STATUS_RATING_COMPLETED:
        return "Rating completed";
      default:
        return "Unknown status";
    }
  }
  // <<< END: getStatusMessage - gets status message
}
// <<< END: _RiderHistoryDetailsState - the data and logic behind its screen

// >>> START: buildDriverProfileImage - build driver profile image
Widget buildDriverProfileImage(rideDetails) {
  final profileImage = rideDetails['driver']['profile_image'];
  final isProfileImageAvailable = profileImage != null && profileImage.isNotEmpty;

  return Container(
    height: isProfileImageAvailable ? 5.h : 10.h,
    width: 10.w,
    decoration: BoxDecoration(
      border: Border.all(color: tBlack, width: 2),
      shape: BoxShape.circle,
      image: isProfileImageAvailable ? DecorationImage(image: NetworkImage(profileImage), fit: BoxFit.cover) : null,
    ),
    child: isProfileImageAvailable ? null : Icon(Icons.person, size: 20, color: tBlack),
  );
}
// <<< END: buildDriverProfileImage - build driver profile image

// >>> START: buildDriverInfo - build driver info
Widget buildDriverInfo(context, rideDetails) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        rideDetails['driver']['name'] ?? '',
        style: TextStyle(
          color: tBlack,
          fontWeight: FontWeight.w600,
          fontSize: isTab(context) ? 10.sp : 14.sp,
        ),
      ),
      SizedBox(height: 0.6.h),
      Text(
        'Skipper',
        style: TextStyle(
          color: tBlack,
          fontWeight: FontWeight.w400,
          fontSize: isTab(context) ? 7.sp : 10.sp,
        ),
      ),
    ],
  );
}
// <<< END: buildDriverInfo - build driver info

Widget buildContactButton(context, {required String iconPath, required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 5.h,
      decoration: BoxDecoration(
        color: tWhite,
        shape: BoxShape.circle,
      ),
      // padding: EdgeInsets.all(4.0),
      child: Image.asset(iconPath, scale: isTab(context) ? 3.6 : 4),
    ),
  );
}

// >>> START: buildDriverVehicleInfo - build driver vehicle info
Widget buildDriverVehicleInfo(context, rideDetails) {
  return Row(
    children: [
      Image.asset(Images.VEHICLE, scale: isTab(context) ? 3 : 4.5),
      SizedBox(width: 1.w),
      Text(
        rideDetails['driver']['vehicle_type'] ?? '',
        style: GoogleFonts.mulish(
          color: tBlack,
          fontWeight: FontWeight.w500,
          fontSize: isTab(context) ? 7.sp : 10.sp,
        ),
      ),
      SizedBox(width: 5.w),
      Image.asset(Images.SELECTED_BIKE, scale: isTab(context) ? 3 : 4.5),
      SizedBox(width: 1.w),
      Text(
        rideDetails['driver']['vehicle_number'] ?? '',
        style: GoogleFonts.mulish(
          color: tBlack,
          fontWeight: FontWeight.w600,
          fontSize: isTab(context) ? 7.sp : 10.sp,
        ),
      ),
    ],
  );
}
// <<< END: buildDriverVehicleInfo - build driver vehicle info

// >>> START: callDriver - call driver
void callDriver(rideDetails) {
  final driverContact = rideDetails['driver']['driver_contact'];
  if (driverContact != null && driverContact.isNotEmpty) {
    launch("tel://" + driverContact);
  } else {
    // Handle error: The phone number is not valid or empty.
  }
}
// <<< END: callDriver - call driver

// >>> START: buildLocationIcon - build location icon
Widget buildLocationIcon(context, rideData) {
  return Padding(
    padding: EdgeInsets.all(8.0), // Adjust the padding as needed
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTab(context) ? 12 : 8),
          decoration: BoxDecoration(
            color: tBackground,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            Images.GREENLOCATIONICON,
            scale: isTab(context) ? 2 : 3.5,
          ),
        ),
        DottedLine(
          direction: Axis.vertical,
          lineLength: 30,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: tDotted,
          dashGapLength: 4.0,
          dashGapRadius: 0.0,
        ),
        Container(
          padding: EdgeInsets.all(isTab(context) ? 12 : 8),
          decoration: BoxDecoration(
            color: tBackground,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            Images.REDLOCATIONICON,
            scale: isTab(context) ? 2 : 3.5,
          ),
        ),
      ],
    ),
  );
}
// <<< END: buildLocationIcon - build location icon

// >>> START: buildAddressText - build address text
Widget buildAddressText(context, String address, rideData) {
  return Text(
    address,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.mulish(
      color: tDarkNavyblue,
      fontWeight: FontWeight.w600,
      fontSize: isTab(context) ? 9.sp : 11.sp,
    ),
  );
}
// <<< END: buildAddressText - build address text
