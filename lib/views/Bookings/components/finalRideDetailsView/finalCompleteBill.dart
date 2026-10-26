// =============================================================================
// WHAT : Full bill of a completed ride.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/priceListWidget.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


// >>> START: FinalCompletedBill - screen/widget shell (the visible part is in its State class)
class FinalCompletedBill extends StatefulWidget {
  FinalCompletedBill({Key? key, this.vehicle, this.rideDetails, this.cancelCharges}) : super(key: key);

  final rideDetails;
  final vehicle;
  final cancelCharges;
  @override
  State<FinalCompletedBill> createState() => FinalCompletedBillState();
}
// <<< END: FinalCompletedBill - screen/widget shell (the visible part is in its State class)

// >>> START: FinalCompletedBillState - the data and logic behind its screen
class FinalCompletedBillState extends State<FinalCompletedBill> {
  var extraMin = 2;
  var nightCharges = 300;
  dynamic cancellationCharge = 100;
  late List<String> texts;

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cancellationCharge = widget.rideDetails['userCancellationCharge'];
    getCharges();
    texts = [
      'If the trip extends time,extra charges as $currencySymbol $extraMin per extra min applicable.',
      'Night Charge $currencySymbol $nightCharges on drives ending between 10:00PM & 05:59AM.',
      'Final Fare will be Charged on time basis.',
      'According to our Cancellation Policy,Charge of  $currencySymbol $cancellationCharge on Cancellation.',
      'Maximum driver\'s duty can be 12 hours.'
    ];

  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: getCharges - gets charges
  void getCharges() {
    if(widget.rideDetails['trip_type'] == TRIP_TYPE_INTERCITY && widget.rideDetails['rider_type'] == RIDER_TYPE_ROUNDTRIP){
      setState(() {
        extraMin = widget.rideDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.rideDetails['night_charge'];
      });
    }else if(widget.rideDetails['trip_type'] == TRIP_TYPE_INTERCITY && widget.rideDetails['rider_type'] == RIDER_TYPE_ONEWAY){
      setState(() {
        extraMin = widget.rideDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.rideDetails['night_charge'];
      });
    }else if(widget.rideDetails['trip_type'] == TRIP_TYPE_OUTSTATION && widget.rideDetails['rider_type'] == RIDER_TYPE_ROUNDTRIP){
      setState(() {
        extraMin = widget.rideDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.rideDetails['night_charge'];
      });
    }else if(widget.rideDetails['trip_type'] == TRIP_TYPE_OUTSTATION && widget.rideDetails['rider_type'] == RIDER_TYPE_ONEWAY){
      setState(() {
        extraMin = widget.rideDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.rideDetails['night_charge'];
      });
    }
  }
  // <<< END: getCharges - gets charges


  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    double? usageHours =
    double.tryParse(widget.rideDetails['usage_hours'] ?? '');

    String usageText;

    if (usageHours != null) {
      if (usageHours >= 1) {
        int wholeHours = usageHours.toInt();
        int wholeMinutes = ((usageHours - wholeHours) * 60).toInt();
        if (wholeMinutes > 0) {
          usageText = '$wholeHours hrs $wholeMinutes mins ';
        } else {
          usageText = '$wholeHours hrs';
        }
      } else {
        int usageMinutes = (usageHours * 60).toInt();
        usageText = '$usageMinutes mins ';
      }
    } else {
      usageText = ''; // Handle the case where 'usage_hours' is null
    }
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return SingleChildScrollView(
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [tBoxShadow]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 1,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // tripOptionsProvider.resetProviderValues();
                    Twl.navigateBack(context);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      color: tDarkNavyblue,
                      size: 24.0,
                    ),
                  ),
                ),
                EstimatePriceHeadWidget(),
                Divider(
                  color: tGray,
                ),
                SizedBox(height: 1.h),
                Text('Fare for your ${usageText} Trip',
                    style: GoogleFonts.mulish(
                      color: tSecondaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: isTab(context) ? 6.sp : 10.sp,
                    )),
                SizedBox(height: 1.h),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text('Completed Ride Fare Details',
                          style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 8.sp : 13.sp,
                          )),
                    ],
                  ),
                ),

                if (widget.rideDetails['price_detail']['baseFare'] != null &&
                    widget.rideDetails['price_detail']['baseFare'] > 0)
                  priceListWidget(
                    title: 'Base Fare',
                    value: currencySymbol +
                        widget.rideDetails['price_detail']['baseFare']
                            .toString(),
                  ),
                if (widget.cancelCharges != null &&
                    widget.cancelCharges> 0)
                  priceListWidget(
                    title: 'Cancellation charges',
                    value: currencySymbol +
                        widget.cancelCharges.toString(),
                  ),
                if (widget.rideDetails['price_detail']['nightCharge'] != null &&
                    widget.rideDetails['price_detail']['nightCharge'] > 0)
                  priceListWidget(
                    title: 'Night Charge',
                    value: currencySymbol +
                        widget.rideDetails['price_detail']['nightCharge']
                            .toString(),
                  ),
                if (widget.rideDetails['price_detail']['outStationCharge'] !=
                    null &&
                    widget.rideDetails['price_detail']['outStationCharge'] > 0)
                  priceListWidget(
                    title: 'Outstation Charge',
                    value: currencySymbol +
                        widget.rideDetails['price_detail']['outStationCharge']
                            .toString(),
                  ),
                if (widget.rideDetails['price_detail']['additionalCharges'] !=
                    null &&
                    widget.rideDetails['price_detail']['additionalCharges'] > 0)
                  priceListWidget(
                    title: 'Additional Charges',
                    value: currencySymbol +
                        widget.rideDetails['price_detail']['additionalCharges']
                            .toString(),
                  ),
                if (widget.rideDetails['price_detail']['gst'] != null &&
                    widget.rideDetails['price_detail']['gst'] > 0)
                  priceListWidget(
                    title: 'GST',
                    value: currencySymbol +
                        widget.rideDetails['price_detail']['gst'].toString(),
                  ),

                if (widget.rideDetails['price_detail']['securedFee'] != '0')
                  priceListWidget(
                    title: 'Secured Fee',
                    value: currencySymbol +
                        widget.rideDetails['price_detail']['securedFee'],
                  ),
                if (widget.rideDetails['price_detail']['platformCharges'] !=
                    '0')
                  priceListWidget(
                    title: 'Platform Charges',
                    value: currencySymbol +
                        widget.rideDetails['price_detail']['platformCharges'],
                  ),
                if (widget.rideDetails['coupon_discount'] != null &&
                    widget.rideDetails['coupon_discount'] > 0)
                  priceListWidget(
                    title: "Coupon Discount",
                    value: '-' +
                        currencySymbol +
                        widget.rideDetails['coupon_discount'].toString(),
                  ),
                //

                SizedBox(
                  height: 1.h,
                ),
                Divider(
                  color: tGray,
                ),
                // SizedBox(height: 1.h),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text('Completed Ride Fare',
                          style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          )),
                      Spacer(),
                      Text(
                          currencySymbol +
                              ' ${((widget.rideDetails['price_detail']['estimatePrice'] + widget.cancelCharges).toString())}',
                          style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          )),
                    ],
                  ),
                ),
                Divider(
                  color: tGray,
                ),
                Expanded(
                  child: Container(
                    // height: 20.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 15.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: tDarkNavyblue,
                                    width: 0.3.w,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    texts[index],
                                    style: TextStyle(
                                      color: tDarkNavyblue,
                                      fontWeight: FontWeight.w400,
                                      fontSize: isTab(context) ? 6.sp : 9.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // tripOptionsProvider.resetProviderValues();
                    Twl.navigateBack(context);
                  },
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: tPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('Got It',
                          style: GoogleFonts.mulish(
                            color: tWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: isTab(context) ? 8.sp : 14.sp,
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
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
// <<< END: FinalCompletedBillState - the data and logic behind its screen

// >>> START: EstimatePriceHeadWidget - screen/widget
class EstimatePriceHeadWidget extends StatelessWidget {
  const EstimatePriceHeadWidget({
    Key? key,
  }) : super(key: key);

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Driver\'s Final Bill',
              style: GoogleFonts.mulish(
                color: tSecondaryColor,
                fontWeight: FontWeight.w700,
                fontSize: isTab(context) ? 10.sp : 16.sp,
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Center(
              child: Container(
                child: Text('Professional,background-',
                    style: GoogleFonts.mulish(
                      color: tSecondaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: isTab(context) ? 8.sp : 12.sp,
                    )),
              ),
            ),
            Text('verified,trained and tested drivers',
                style: GoogleFonts.mulish(
                  color: tSecondaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: isTab(context) ? 8.sp : 12.sp,
                )),
          ],
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: EstimatePriceHeadWidget - screen/widget
