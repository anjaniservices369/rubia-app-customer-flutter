// =============================================================================
// WHAT : One booking in the list (date, status, fare, car).
// NOTES: Tap opens the booking details.
// =============================================================================
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/views/Bookings/components/bookingcard.dart';
import 'package:base_project_flutter/views/Bookings/components/rideDetailsView/rideDetailsView.dart';
import 'package:base_project_flutter/views/Bookings/components/ridehistoryDetails.dart';
import 'package:base_project_flutter/views/Bookings/components/riderDetailsPayment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../responsive.dart';

// >>> START: BookingCardWidget - screen/widget shell (the visible part is in its State class)
class BookingCardWidget extends StatefulWidget {
  const BookingCardWidget({
    Key? key,
    this.bookingDetails,
    required this.selectedServiceTypeId,
  }) : super(key: key);
  final bookingDetails;
  final String selectedServiceTypeId;

  @override
  State<BookingCardWidget> createState() => _BookingCardWidgetState();
}
// <<< END: BookingCardWidget - screen/widget shell (the visible part is in its State class)

// >>> START: _BookingCardWidgetState - the data and logic behind its screen
class _BookingCardWidgetState extends State<BookingCardWidget> {
  var details;
  var rideDetails;
  var resNOK;
  bool isEstimationFareLoading = false;

  // >>> START: getRideInfo - gets ride info
  /// Loads this booking's extra details from the server for the card.
  /// The card can be closed (e.g. the customer switches tab) while the request
  /// is still running, so every setState is guarded with `mounted`.
  getRideInfo() async {
    if (!mounted) return;
    setState(() {
      isEstimationFareLoading = true;
    });

    // Ask the server for this booking's details.
    details = await UserAPI()
        .rideInfo(context, widget.bookingDetails['id'].toString());

    // The card may have been removed while waiting: do nothing then.
    if (!mounted) return;

    setState(() {
      isEstimationFareLoading = false;
      if (details != null && details['status'] == 'OK') {
        rideDetails = details['details'];
      } else {
        // No reply (timeout) or an error reply: remember it so the card can
        // still be drawn without the extra details.
        resNOK = details == null ? 'NOK' : details['status'];
      }
    });
  }
  // <<< END: getRideInfo - gets ride info

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    getRideInfo();

    // TODO: implement initState
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    double? usageHours = double.tryParse(widget.bookingDetails['usage_hours'] ?? '');

    String usageText;

    if (usageHours != null) {
      if (usageHours >= 1) {
        int wholeHours = usageHours.toInt();
        int wholeMinutes = ((usageHours - wholeHours) * 60).toInt();
        if (wholeMinutes > 0) {
          usageText = '$wholeHours hrs $wholeMinutes mins usage';
        } else {
          usageText = '$wholeHours hrs usage';
        }
      } else {
        int usageMinutes = (usageHours * 60).toInt();
        usageText = '$usageMinutes mins usage';
      }
    } else {
      usageText = 'Usage hours not available'; // Handle the case where 'usage_hours' is null
    }
    return widget.selectedServiceTypeId == '1'
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.5.w),
            child: GestureDetector(
                onTap: () {
                  widget.bookingDetails['status'] == STATUS_RIDE_COMPLETED ||
                          widget.bookingDetails['status'] == STATUS_USER_CANCELLED ||
                          widget.bookingDetails['status'] == STATUS_DRIVER_CANCELLED ||
                          widget.bookingDetails['status'] == STATUS_BOOKING_AUTO_CANCELLED ||
                          widget.bookingDetails['status'] == STATUS_DRIVER_REJECTED
                      ? Twl.navigateTo(
                          context,
                          RideDetailsView(
                            rideDetails: rideDetails,
                          ))
                      : Twl.navigateTo(
                          context,
                          RideDetailsPayment(
                            bookingDetails: widget.bookingDetails,
                          ));
                },
                child: Container(
                    decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h, bottom: 1.h, left: 2.w, right: 2.w),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: getStatusColor(widget.bookingDetails['status']),
                                boxShadow: [tBoxShadow],
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              getStatus(widget.bookingDetails['status']),
                              // bookingDetails['otp']
                              // 'Waiting for Driver',
                              style: GoogleFonts.mulish(
                                color: tDarkNavyblue,
                                fontWeight: FontWeight.w600,
                                fontSize: isTab(context) ? 8.sp : 10.sp,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: 1.h, left: 1.w, right: 1.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Images.CALENDER,
                                    scale: isTab(context) ? 2.5 : 3.5,
                                  ),
                                  SizedBox(
                                    width: 0.5.w,
                                  ),
                                  widget.bookingDetails['pickup_date'] == null || widget.bookingDetails['pickup_date'] == ""
                                      ? Container()
                                      : Text(
                                          Twl.dateActualFormate(widget.bookingDetails['pickup_date']) + ",",
                                          style: GoogleFonts.mulish(
                                            color: tSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: isTab(context) ? 9.sp : 13.sp,
                                          ),
                                        ),
                                  Text(
                                    widget.bookingDetails['pickup_time'].toString(),
                                    style: GoogleFonts.mulish(
                                      color: tSecondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  if (widget.bookingDetails['status'] == STATUS_RIDE_COMPLETED && isEstimationFareLoading)
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(tPrimaryColor),
                                    )
                                  else
                                    Text(
                                      currencySymbol +
                                          (widget.bookingDetails['status'] == STATUS_RIDE_COMPLETED
                                              ? ((widget.bookingDetails['price_detail']['estimatePrice'] + (widget.bookingDetails['cancellation_charges'] ?? 0)).toString())
                                              : ((widget.bookingDetails['price_detail']['estimatePrice']+ (widget.bookingDetails['price_detail']['cancellation_charges'] ?? 0)).toString()?? '0')),
                                      style: GoogleFonts.mulish(
                                        color: tPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isTab(context) ? 16.sp : 15.sp,
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: 1.h, left: 1.w, right: 1.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    Images.TIMER,
                                    scale: isTab(context) ? 2.9 : 4,
                                  ),
                                  SizedBox(
                                    width: 0.8.w,
                                  ),
                                  Container(
                                    width: 30.w,
                                    child: Text(
                                      usageText,
                                      style: GoogleFonts.mulish(
                                        color: tSecondaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: isTab(context) ? 9.sp : 11.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.bookingDetails['car_model'].toString(),
                                    style: GoogleFonts.mulish(
                                      color: tSecondaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 9.sp : 11.sp,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    widget.bookingDetails['car_type'].toString() == '1' ? '(Automatic)' : '(Manual)',
                                    style: GoogleFonts.mulish(
                                      color: tSecondaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 9.sp : 11.sp,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: 1.h, left: 1.w, right: 1.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  widget.bookingDetails['trip_type'] == TRIP_TYPE_INTERCITY
                                      ? Image.asset(
                                          Images.IN_CITY,
                                          scale: isTab(context) ? 5 : 7,
                                        )
                                      : Image.asset(
                                          Images.OUT_STATION,
                                          scale: isTab(context) ? 5 : 7,
                                        ),
                                  SizedBox(
                                    width: 0.5.w,
                                  ),
                                  Text(
                                    getTripTypeText(widget.bookingDetails['trip_type']),
                                    style: GoogleFonts.mulish(
                                      color: tPrimaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 9.sp : 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  widget.bookingDetails['rider_type'] == RIDER_TYPE_ONEWAY
                                      ? Image.asset(
                                          Images.ONEWAY,
                                          scale: isTab(context) ? 100 : 105,
                                        )
                                      : Image.asset(
                                          Images.OUTSTATION_ICON,
                                          scale: isTab(context) ? 2.9 : 4,
                                        ),
                                  SizedBox(
                                    width: 0.5.w,
                                  ),
                                  Text(
                                    getRiderTypeText(widget.bookingDetails['rider_type']),
                                    style: GoogleFonts.mulish(
                                      color: tPrimaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 9.sp : 11.sp,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Center(
                          child: Text(
                            'click here to view full details ---->>',
                            style: GoogleFonts.mulish(
                              color: tPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: isTab(context) ? 9.sp : 11.sp,
                            ),
                          ),
                        ),
                      ]),
                    ))),
          )
        : GestureDetector(
            onTap: () {
              Twl.navigateTo(context, RiderHistoryDetails(bookingDetails: widget.bookingDetails));
            },
            child: BookingCard(bookingDetails: widget.bookingDetails));
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _BookingCardWidgetState - the data and logic behind its screen

getRiderTypeText(riderType) {
  switch (riderType) {
    case RIDER_TYPE_ONEWAY:
      return 'One-way trip';
    case RIDER_TYPE_ROUNDTRIP:
      return 'Round trip';
    default:
      return 'Unknown';
  }
}

getTripTypeText(int tripType) {
  switch (tripType) {
    case TRIP_TYPE_INTERCITY:
      return 'InCity';
    case TRIP_TYPE_OUTSTATION:
      return 'Outstation';
    default:
      return 'Unknown';
  }
}

// >>> START: getStatus - gets status
String getStatus(int status) {
  switch (status) {
    case STATUS_WAITING_FOR_DRIVER:
      return 'Waiting for Driver';
    case STATUS_DRIVER_ACCEPTED:
      return 'Driver Accepted';
    case STATUS_DRIVER_REJECTED:
      return 'Driver Rejected';
    case STATUS_GO_FOR_PICKUP:
      return 'Driver arriving Location';
    case STATUS_ARRIVED_LOCATION:
      return 'Arrived at Location';
    case STATUS_START_RIDE:
      return 'Started Ride';
    case STATUS_RIDE_COMPLETED:
      return 'Ride Completed';
    case STATUS_USER_CANCELLED:
      return 'User Cancelled';
    case STATUS_BOOKING_AUTO_CANCELLED:
      return 'Booking Auto Cancelled';
    case STATUS_DRIVER_CANCELLED:
      return 'Driver Cancelled';
    case STATUS_CANCELLED:
      return 'Cancelled';
    case STATUS_ACCEPTED_RIDES:
      return 'Accepted Rides';
    default:
      return 'Unknown';
  }
}
// <<< END: getStatus - gets status

const Color tappbarclr = Color.fromARGB(255, 76, 231, 231);
const Color tCancelRidebtn = Color(0xFFDC143C);
const Color tskippergreen = Color(0xFF008000);

getStatusColor(int status) {
  switch (status) {
    case STATUS_WAITING_FOR_DRIVER:
      return tappbarclr;
    case STATUS_DRIVER_ACCEPTED:
      return tappbarclr;
    case STATUS_DRIVER_REJECTED:
      return tCancelRidebtn;
    case STATUS_GO_FOR_PICKUP:
      return Colors.red;
    case STATUS_ARRIVED_LOCATION:
      return Colors.blue;
    case STATUS_START_RIDE:
      return tappbarclr;
    case STATUS_RIDE_COMPLETED:
      return tgreen;
    case STATUS_USER_CANCELLED:
      return tCancelRidebtn;
    case STATUS_BOOKING_AUTO_CANCELLED:
      return Colors.orange;
    case STATUS_DRIVER_CANCELLED:
      return Colors.purple;
    case STATUS_CANCELLED:
      return Colors.grey;
    case STATUS_ACCEPTED_RIDES:
      return Colors.yellow;
    default:
      return tappbarclr;
  }
}
