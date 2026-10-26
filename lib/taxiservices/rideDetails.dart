// =============================================================================
// WHAT : TAXI: ride details once a driver is assigned - driver, vehicle, OTP,
//        route.
// NOTES: Taxi service.
// =============================================================================
import 'package:base_project_flutter/taxiservices/searchlocation/components.dart/cancelcard.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';

// >>> START: Riderdetails - screen/widget shell (the visible part is in its State class)
class Riderdetails extends StatefulWidget {
  const Riderdetails({Key? key, this.rideData, this.rideDetails})
      : super(key: key);
  final rideData;
  final rideDetails;
  @override
  State<Riderdetails> createState() => _RiderdetailsState();
}
// <<< END: Riderdetails - screen/widget shell (the visible part is in its State class)

// >>> START: _RiderdetailsState - the data and logic behind its screen
class _RiderdetailsState extends State<Riderdetails> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: tWhite),
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.CLOCKTIMER,
                      scale: 4,
                    ),
                    SizedBox(width: tDefaultPadding / 2),
                    Text(
                      getStatusMessage(widget.rideData['status']),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // Add any other text styles you want
                      ),
                    ),
                  ],
                ),
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
                            _buildDriverProfileImage(),
                            SizedBox(width: 2.w),
                            _buildDriverInfo(),
                            Spacer(),
                            _buildContactButton(
                              iconPath: Images.CALL_ICON,
                              onTap: () => _callDriver(),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        _buildDriverVehicleInfo(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              _otpCard(context),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 4.0, // Add elevation (box shadow) to the card
                  shadowColor: Colors.grey
                      .withOpacity(0.5), // Customize the shadow color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Rounded corners for the card
                  ),
                  child: Row(
                    children: [
                      _buildLocationIcon(Images.GREENLOCATIONICON),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAddressText(
                              widget.rideData['pickup_address'].toString(),
                            ),
                            Divider(
                              height: 4.h,
                              thickness: 0.9,
                              color: tDividerColor,
                            ),
                            _buildAddressText(
                              widget.rideData['drop_address'].toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (widget.rideData['status'] != TAXI_STATUS_START_RIDE &&
                  widget.rideData['status'] !=
                      TAXI_STATUS_ACCEPTED_BY_SKIPPER &&
                  widget.rideData['status'] != TAXI_STATUS_COMPLETE_RIDE)
                CancelWidgetCard(
                  rideData: widget.rideData,
                  rideDetails: widget.rideDetails,
                )

              // : Container(),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: _otpCard - otp card
  Row _otpCard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: tWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [tBoxShadow],
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'OTP : ',
                    style: GoogleFonts.mulish(
                      color: tBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: isTab(context) ? 8.sp : 12.sp,
                    ),
                  ),
                ),
                SizedBox(width: 1.8.w),
                Text(
                  widget.rideData['otp'].toString(),
                  style: GoogleFonts.mulish(
                    color: tBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: isTab(context) ? 10.sp : 17.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // <<< END: _otpCard - otp card

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
    final profileImage = widget.rideData['driver']['profile_image'];
    final isProfileImageAvailable =
        profileImage != null && profileImage.isNotEmpty;

    return Container(
      height: isProfileImageAvailable ? 5.h : 10.h,
      width: 10.w,
      decoration: BoxDecoration(
        border: Border.all(color: tBlack, width: 2),
        shape: BoxShape.circle,
        image: isProfileImageAvailable
            ? DecorationImage(
                image: NetworkImage(profileImage), fit: BoxFit.cover)
            : null,
      ),
      child: isProfileImageAvailable
          ? null
          : Icon(Icons.person, size: 20, color: tBlack),
    );
  }
  // <<< END: _buildDriverProfileImage - build driver profile image

  // >>> START: _buildDriverInfo - build driver info
  Widget _buildDriverInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.rideData['driver']['name'] ?? '',
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
  Widget _buildContactButton(
      {required String iconPath, required Function() onTap}) {
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
          widget.rideData['driver']['vehicle_type'] ?? '',
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
          widget.rideData['driver']['vehicle_number'] ?? '',
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
    final driverContact = widget.rideData['driver']['driver_contact'];
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
// <<< END: _RiderdetailsState - the data and logic behind its screen

// >>> START: buildDriverProfileImage - build driver profile image
Widget buildDriverProfileImage(rideData) {
  final profileImage = rideData['driver']['profile_image'];
  final isProfileImageAvailable =
      profileImage != null && profileImage.isNotEmpty;

  return Container(
    height: isProfileImageAvailable ? 5.h : 10.h,
    width: 10.w,
    decoration: BoxDecoration(
      border: Border.all(color: tBlack, width: 2),
      shape: BoxShape.circle,
      image: isProfileImageAvailable
          ? DecorationImage(
              image: NetworkImage(profileImage), fit: BoxFit.cover)
          : null,
    ),
    child: isProfileImageAvailable
        ? null
        : Icon(Icons.person, size: 20, color: tBlack),
  );
}
// <<< END: buildDriverProfileImage - build driver profile image

// >>> START: buildDriverInfo - build driver info
Widget buildDriverInfo(context, rideData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        rideData['driver']['name'] ?? '',
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

Widget buildContactButton(context,
    {required String iconPath, required Function() onTap}) {
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
Widget buildDriverVehicleInfo(context, rideData) {
  return Row(
    children: [
      Image.asset(Images.VEHICLE, scale: isTab(context) ? 3 : 4.5),
      SizedBox(width: 1.w),
      Text(
        rideData['driver']['vehicle_type'] ?? '',
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
        rideData['driver']['vehicle_number'] ?? '',
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
void callDriver(rideData) {
  final driverContact = rideData['driver']['driver_contact'];
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
