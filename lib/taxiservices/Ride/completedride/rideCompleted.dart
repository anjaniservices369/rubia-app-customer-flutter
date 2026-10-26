// =============================================================================
// WHAT : TAXI: ride-completed screen with the fare summary.
// NOTES: Loads the final bill from the server.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/buttonIconWidget.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/taxiservices/Ride/completedride/billDetails.dart';
import 'package:base_project_flutter/taxiservices/Ride/completedride/priceCard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/constants.dart';
import '../../rideDetails.dart';

// >>> START: RideCompletedScreen - screen/widget shell (the visible part is in its State class)
class RideCompletedScreen extends StatefulWidget {
  const RideCompletedScreen({Key? key, this.rideData}) : super(key: key);
  final rideData;

  @override
  State<RideCompletedScreen> createState() => _RideCompletedScreenState();
}
// <<< END: RideCompletedScreen - screen/widget shell (the visible part is in its State class)

// >>> START: _RideCompletedScreenState - the data and logic behind its screen
class _RideCompletedScreenState extends State<RideCompletedScreen> {
  var rideDetails;
  var resNOK;

  // >>> START: fetchrideDetails - fetchride details
  fetchrideDetails() async {
    var response = await UserAPI().rideCompletedDetails(context, widget.rideData['ride_id'].toString());
    if (response != null && response['status'] == 'OK') {
      setState(() {
        rideDetails = response['details'];
      });
    } else {
      resNOK = response['status'];
    }
  }
  // <<< END: fetchrideDetails - fetchride details

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    fetchrideDetails();
    // TODO: implement initState
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          titleSpacing: 7,
          backgroundColor: tPrimaryColor,
          centerTitle: true,
          // automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Twl.willpopAlert(context);
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
                                buildDriverProfileImage(widget.rideData),
                                SizedBox(width: 2.w),
                                buildDriverInfo(context, widget.rideData),
                                Spacer(),
                                buildContactButton(
                                  context,
                                  iconPath: Images.CALL_ICON,
                                  onTap: () => callDriver(widget.rideData),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            buildDriverVehicleInfo(context, widget.rideData),
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
                          buildLocationIcon(context, widget.rideData),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildAddressText(context, widget.rideData['pickup_address'], widget.rideData),
                                Divider(
                                  height: 4.h,
                                  thickness: 0.9,
                                  color: tDividerColor,
                                ),
                                buildAddressText(context, widget.rideData['drop_address'], widget.rideData),
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
                  BillDetailsCardWidgt(rideData: widget.rideData, rideDetails: rideDetails),
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
                  RideStatusCardWidgt(rideData: widget.rideData, rideDetails: rideDetails),
                  // GestureDetector(
                  //     // onTap: () {
                  //     //   Twl.navigateTo(context, BookRideView());
                  //     // },
                  //     child: PayAtDropCardWidget(rideData: widget.rideData)),
                  widget.rideData['status'] == TAXI_STATUS_COMPLETE_RIDE
                      // &&
                      //         widget.rideData['payment_method'] == '4'
                      ? SizedBox(
                          height: 2.h,
                        )
                      : Container(),
                  widget.rideData['status'] == TAXI_STATUS_COMPLETE_RIDE
                      // &&
                      //         widget.rideData['payment_method'] == '4'
                      ? PriceWidgetCard(
                          rideData: widget.rideData,
                          rideDetails: rideDetails,
                        )
                      : Container(),
                  // OTPCard(rideData:widget.rideData),
                  SizedBox(
                    height: 5.h,
                  ),
                ]),
              ),
            ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

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
}
// <<< END: _RideCompletedScreenState - the data and logic behind its screen
