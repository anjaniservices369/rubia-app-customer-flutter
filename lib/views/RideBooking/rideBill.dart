// =============================================================================
// WHAT : Bill breakdown shown for the estimate.
// NOTES: Visual component.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/priceListWidget.dart';
import '../../providers/riderProvider.dart';
import '../../responsive.dart';
import 'package:intl/intl.dart';

// >>> START: RideBill - screen/widget shell (the visible part is in its State class)
class RideBill extends StatefulWidget {
  RideBill({Key? key, this.vehicle, this.viewbookingDetails}) : super(key: key);
  final viewbookingDetails;
  final vehicle;
  @override
  State<RideBill> createState() => RideBillState();
}
// <<< END: RideBill - screen/widget shell (the visible part is in its State class)

// >>> START: RideBillState - the data and logic behind its screen
class RideBillState extends State<RideBill> {
  var extraMin = 2;
  var nightCharges = 300;
  dynamic cancellationCharge = 100;
  late List<String> texts;

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cancellationCharge = widget.viewbookingDetails['userCancellationCharge'];
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
    if(widget.viewbookingDetails['trip_type'] == TRIP_TYPE_INTERCITY && widget.viewbookingDetails['rider_type'] == RIDER_TYPE_ROUNDTRIP){
      setState(() {
        extraMin = widget.viewbookingDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.viewbookingDetails['night_charge'];
      });
    }else if(widget.viewbookingDetails['trip_type'] == TRIP_TYPE_INTERCITY && widget.viewbookingDetails['rider_type'] == RIDER_TYPE_ONEWAY){
      setState(() {
        extraMin = widget.viewbookingDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.viewbookingDetails['night_charge'];
      });
    }else if(widget.viewbookingDetails['trip_type'] == TRIP_TYPE_OUTSTATION && widget.viewbookingDetails['rider_type'] == RIDER_TYPE_ROUNDTRIP){
      setState(() {
        extraMin = widget.viewbookingDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.viewbookingDetails['night_charge'];
      });
    }else if(widget.viewbookingDetails['trip_type'] == TRIP_TYPE_OUTSTATION && widget.viewbookingDetails['rider_type'] == RIDER_TYPE_ONEWAY){
      setState(() {
        extraMin = widget.viewbookingDetails['price_detail']['extraMinCharge'];
        nightCharges = widget.viewbookingDetails['night_charge'];
      });
    }
  }
  // <<< END: getCharges - gets charges

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);
    final pickupTimeFormat = DateFormat('HH:mm');

    final pickupTime = tripOptionsProvider.pickupTime;
    DateTime? parsedPickupTime;

    if (pickupTime != null && pickupTime.isNotEmpty) {
      parsedPickupTime = pickupTimeFormat.parse(pickupTime);
    }

// Check if the pickup time is not null and falls between 6:00 am and 10:00 pm
    final isDayTime = parsedPickupTime != null &&
        parsedPickupTime.hour >= 6 &&
        parsedPickupTime.hour < 22;

    final baseChargeTitle = 'Base Charges';
    // final coupondiscount = tripOptionsProvider.couponDiscount;

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
            height: MediaQuery.of(context).size.height / 1.1,
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
                Text(
                    'A fare estimate for your ${widget.viewbookingDetails['price_detail']['usageHours'].toString()} Hrs Trip',
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
                      Text('Estimated Fare Details',
                          style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 8.sp : 13.sp,
                          )),
                    ],
                  ),
                ),
                if (widget.viewbookingDetails['price_detail']['baseFare'] !=
                    '0')
                  priceListWidget(
                      title: baseChargeTitle,
                      value: currencySymbol +
                          widget.viewbookingDetails['price_detail']['baseFare']
                              .toString()),

                if (widget.viewbookingDetails['price_detail']
                        ['additionalCharges'] !=
                    '0')
                  priceListWidget(
                      title: 'Additional Charges',
                      value: currencySymbol +
                          widget.viewbookingDetails['price_detail']
                                  ['additionalCharges']
                              .toString()),
                if (widget.viewbookingDetails['price_detail']['cancellation_charges'] != null &&
                    widget.viewbookingDetails['price_detail']['cancellation_charges'] > 0)
                  priceListWidget(
                      title: "Cancellation charges",
                      value: currencySymbol +
                          widget.viewbookingDetails['price_detail']['cancellation_charges'].toString()
                  ),

                if (widget.viewbookingDetails['price_detail']
                        ['outStationCharge'] !=
                    0)
                  priceListWidget(
                      title: 'OutStation Charges',
                      value: currencySymbol +
                          widget.viewbookingDetails['price_detail']
                                  ['outStationCharge']
                              .toString()),
                if (widget.viewbookingDetails['price_detail']['nightCharge'] !=
                    0)
                  priceListWidget(
                      title: 'Night Charges',
                      value: currencySymbol +
                          (widget.viewbookingDetails['price_detail']
                                  ['nightCharge'])
                              .toString()),
                if (widget.viewbookingDetails['price_detail']['gst'] != 0)
                  priceListWidget(
                      title: 'GST',
                      value: currencySymbol +
                          widget.viewbookingDetails['price_detail']['gst']
                              .toString()),
                if (widget.viewbookingDetails['price_detail']['securedFee'] !=
                    0)
                  priceListWidget(
                      title: 'Secured Fee',
                      value: currencySymbol +
                          widget.viewbookingDetails['price_detail']
                                  ['securedFee']
                              .toString()),
                if (widget.viewbookingDetails['price_detail']
                        ['platformCharges'] !=
                    0)
                  priceListWidget(
                      title: 'Platform Charges',
                      value: currencySymbol +
                          widget.viewbookingDetails['price_detail']
                                  ['platformCharges']
                              .toString()),
                if (widget.viewbookingDetails['coupon_discount'] != null &&
                    widget.viewbookingDetails['coupon_discount'] > 0)
                  priceListWidget(
                      title: "Coupon Discount",
                      value: '-' +
                          currencySymbol +
                          widget.viewbookingDetails['coupon_discount']
                              .toString()),

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
                      Text('Estimated Final Fare',
                          style: GoogleFonts.mulish(
                            color: tSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          )),
                      Spacer(),
                      Text(
                          currencySymbol +
                              ' ${((widget.viewbookingDetails['price_detail']['estimatePrice'] + (widget.viewbookingDetails['price_detail']['cancellation_charges'] ?? 0)).toString())}',
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
// <<< END: RideBillState - the data and logic behind its screen

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
              'Driver\'s Estimation Bill',
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
