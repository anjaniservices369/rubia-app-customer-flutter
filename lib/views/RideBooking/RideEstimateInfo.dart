// =============================================================================
// WHAT : Rental vehicle information and estimate details.
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

// >>> START: RentalVehicleInfo - screen/widget shell (the visible part is in its State class)
class RentalVehicleInfo extends StatefulWidget {
  RentalVehicleInfo({Key? key, this.vehicle}) : super(key: key);

  final vehicle;
  @override
  State<RentalVehicleInfo> createState() => RentalVehicleInfoState();
}
// <<< END: RentalVehicleInfo - screen/widget shell (the visible part is in its State class)

// >>> START: RentalVehicleInfoState - the data and logic behind its screen
class RentalVehicleInfoState extends State<RentalVehicleInfo> {
  var extraMin = 2;
  var nightCharges = 300;
  dynamic cancellationCharge = 100;
  late List<String> texts;

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  /// The night charge to quote: the rate card's charge per night when the
  /// server sent it, else the trip's night charge, else a default.
  int _nightQuote(TripOptionsProvider p, int fallback) {
    final perNight = int.tryParse(p.nightChargePerNight.toString()) ?? 0;
    if (perNight > 0) return perNight;
    final night = int.tryParse(p.nightCharge.toString()) ?? 0;
    return night > 0 ? night : fallback;
  }

  void getCharges() {
    final tripOptionsProvider =
    Provider.of<TripOptionsProvider>(context, listen: false);
    setState(() {
      cancellationCharge = tripOptionsProvider.userCancellationCharges;
    });

    if(tripOptionsProvider.tripType == TRIP_TYPE_INTERCITY && tripOptionsProvider.riderType == RIDER_TYPE_ROUNDTRIP){
      setState(() {
        extraMin = int.parse(tripOptionsProvider.extraMinCharge);
        nightCharges = _nightQuote(tripOptionsProvider, 300);
      });
    }else if(tripOptionsProvider.tripType == TRIP_TYPE_INTERCITY && tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY){
      setState(() {
        extraMin = int.parse(tripOptionsProvider.extraMinCharge);
        nightCharges = _nightQuote(tripOptionsProvider, 300);
      });
    }else if(tripOptionsProvider.tripType == TRIP_TYPE_OUTSTATION && tripOptionsProvider.riderType == RIDER_TYPE_ROUNDTRIP){
      setState(() {
        extraMin = int.parse(tripOptionsProvider.extraMinCharge);
        nightCharges = _nightQuote(tripOptionsProvider, 500);
      });
    }else if(tripOptionsProvider.tripType == TRIP_TYPE_OUTSTATION && tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY){
      setState(() {
        extraMin = int.parse(tripOptionsProvider.extraMinCharge);
        nightCharges = _nightQuote(tripOptionsProvider, 300);
      });
    }
  }
  // <<< END: getCharges - gets charges

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider =
        Provider.of<TripOptionsProvider>(context, listen: false);
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

    const baseChargeTitle = 'Base Charges';
        // isDayTime ? 'Base Charge (Day)' : 'Base Charge (Night)';
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
                Text(
                    'A fare estimate for your ${tripOptionsProvider.usageHours} Hrs Trip',
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
                if (tripOptionsProvider.baseFare != '0')
                  priceListWidget(
                      title: baseChargeTitle,
                      value: tripOptionsProvider.baseFare),

                if (tripOptionsProvider.additionalCharges != '0')
                  priceListWidget(
                      title: 'Additional Charges',
                      value: tripOptionsProvider.additionalCharges),
                if (tripOptionsProvider.cancellationCharges != '0')
                  priceListWidget(
                      title: 'Cancellation Charges',
                      value: tripOptionsProvider.cancellationCharges),
                if (tripOptionsProvider.outStationCharge != '0')
                  priceListWidget(
                      title: 'OutStation Charges',
                      value: tripOptionsProvider.outStationCharge),

                if (tripOptionsProvider.nightCharge != '0')
                  priceListWidget(
                      title: 'Night Charges',
                      value: tripOptionsProvider.nightCharge),
                if (tripOptionsProvider.gst != '0')
                  priceListWidget(title: 'GST', value: tripOptionsProvider.gst),
                if (tripOptionsProvider.securedFee != '0')
                  priceListWidget(
                      title: 'Secured Fee',
                      value: tripOptionsProvider.securedFee),
                if (tripOptionsProvider.platFormCharges != '0')
                  priceListWidget(
                      title: 'Platform Charges',
                      value: tripOptionsProvider.platFormCharges),

                priceListWidget(
                    title: "Coupon Discount",
                    value: '-' +
                        currencySymbol +
                        tripOptionsProvider.couponDiscount.toString()),

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
                      Text(currencySymbol + '${tripOptionsProvider.finalFare} ',
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
// <<< END: RentalVehicleInfoState - the data and logic behind its screen

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
