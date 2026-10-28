// =============================================================================
// WHAT : Booking summary card used in lists.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:base_project_flutter/globalWidgets/viewDetailsButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// >>> START: BookingCard - screen/widget shell (the visible part is in its State class)
class BookingCard extends StatefulWidget {
  BookingCard({Key? key, this.bookingDetails}) : super(key: key);
  final bookingDetails;

  @override
  State<BookingCard> createState() => _BookingCardState();
}
// <<< END: BookingCard - screen/widget shell (the visible part is in its State class)

// >>> START: _BookingCardState - the data and logic behind its screen
class _BookingCardState extends State<BookingCard> {
  //         rideDetails = details['details'];
  //         print("Taxi Ride Details");
  //         print(rideDetails);
  //         resNok = details['status'];

  // @override
  // void initState() {
  //   // TODO: implement initState

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.5.w),
      child: Container(
        decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(top: 2.h, bottom: 1.h, left: 2.w, right: 2.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: getSkipperStatusColor(widget.bookingDetails['status']), boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    getSkipperStatus(widget.bookingDetails['status']),
                    style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontWeight: FontWeight.w600,
                      fontSize: isTab(context) ? 8.sp : 10.sp,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(isTab(context) ? 12 : 8),
                            decoration: BoxDecoration(color: tBackground, shape: BoxShape.circle),
                            child: Image.asset(
                              Images.GREENLOCATIONICON,
                              scale: isTab(context) ? 2 : 3.5,
                            )),
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
                            decoration: BoxDecoration(color: tBackground, shape: BoxShape.circle),
                            child: Image.asset(
                              Images.REDLOCATIONICON,
                              scale: isTab(context) ? 2 : 3.5,
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bookingDetails['pickup_address'].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.mulish(
                              color: tDarkNavyblue,
                              fontWeight: FontWeight.w600,
                              fontSize: isTab(context) ? 9.sp : 11.sp,
                            ),
                          ),
                          Divider(
                            height: 4.h,
                            thickness: 0.9,
                            color: tDividerColor,
                          ),
                          Text(
                            widget.bookingDetails['drop_address'].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.mulish(
                              color: tDarkNavyblue,
                              fontWeight: FontWeight.w600,
                              fontSize: isTab(context) ? 9.sp : 11.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const ViewDetailsButton(),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _BookingCardState - the data and logic behind its screen

// >>> START: getSkipperStatus - gets skipper status
String getSkipperStatus(int status) {
  switch (status) {
    case TAXI_STATUS_NEW_REQUEST:
      return 'New Request';
    case TAXI_STATUS_RIDE_BOOKED:
      return 'Ride Booked';
    case TAXI_STATUS_CANCEL_BY_USER:
      return 'Cancelled by User';
    case TAXI_STATUS_ACCEPTED_BY_SKIPPER:
      return 'Accepted by Driver';
    case TAXI_STATUS_ON_THE_WAY:
      return 'On the Way';
    case TAXI_STATUS_ARRIVED:
      return 'Arrived';
    case TAXI_STATUS_CANCEL_BY_SKIPPER:
      return 'Cancelled by Driver';
    case TAXI_STATUS_START_RIDE:
      return 'Started Ride';
    case TAXI_STATUS_COMPLETE_RIDE:
      return 'Completed Ride';
    case TAXI_STATUS_AMOUNT_COLLECTED:
      return 'Amount Collected';
    case TAXI_STATUS_RATING_COMPLETED:
      return 'Rating Completed';
    default:
      return 'Unknown';
  }
}
// <<< END: getSkipperStatus - gets skipper status

// Define your color constants here
const Color tappbarclr = Color(0xFF008080);
const Color tCancelRidebtn = Color(0xFFDC143C);
const Color tskippergreen = Color(0xFF008000);

// >>> START: getSkipperStatusColor - gets skipper status color
Color getSkipperStatusColor(int status) {
  switch (status) {
    case TAXI_STATUS_NEW_REQUEST:
      return tappbarclr;
    case TAXI_STATUS_RIDE_BOOKED:
      return tappbarclr;
    case TAXI_STATUS_CANCEL_BY_USER:
      return tCancelRidebtn;
    case TAXI_STATUS_ACCEPTED_BY_SKIPPER:
      return tappbarclr;
    case TAXI_STATUS_ON_THE_WAY:
      // Define the color for TAXI_STATUS_ON_THE_WAY here
      return Colors.red;
    case TAXI_STATUS_ARRIVED:
      // Define the color for TAXI_STATUS_ARRIVED here
      return Colors.blue;
    case TAXI_STATUS_CANCEL_BY_SKIPPER:
      // Define the color for TAXI_STATUS_CANCEL_BY_SKIPPER here
      return Colors.purple;
    case TAXI_STATUS_START_RIDE:
      return tappbarclr;
    case TAXI_STATUS_COMPLETE_RIDE:
      return tskippergreen;
    case TAXI_STATUS_AMOUNT_COLLECTED:
      // Define the color for TAXI_STATUS_AMOUNT_COLLECTED here
      return Colors.orange;
    case TAXI_STATUS_RATING_COMPLETED:
      // Define the color for TAXI_STATUS_RATING_COMPLETED here
      return Colors.yellow;
    default:
      return tappbarclr;
  }
}
// <<< END: getSkipperStatusColor - gets skipper status color
