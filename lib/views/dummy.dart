// =============================================================================
// WHAT : Despite the name this is LIVE: the date and time picker (class Clock)
//        used when booking a driver, with the fare estimate button.
// NOTES: The time spinner opens on the next quarter-hour that is at least 5
//        minutes ahead. The file name 'dummy' is historic and could be renamed.
// =============================================================================
import 'package:base_project_flutter/api_services/servicesApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../globalFuctions/globalFunctions.dart';
import '../globalWidgets/buttonWidget.dart';
import '../providers/riderProvider.dart';
import 'homePage/components/OneWay.dart';

// >>> START: Clock - date and time picker with the fare estimate button
/// The "Select date / Select time" sheet of the Drivers booking.
///
/// The customer picks today or tomorrow, then a time in 15-minute steps. The
/// OK button asks the server for the fare estimate and, on success, opens the
/// estimate screen (OneWay).
class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}
// <<< END: Clock - date and time picker with the fare estimate button

// >>> START: _nextPickupSlot - next pickup slot
/// First quarter-hour slot that is at least 5 minutes ahead of now. The
/// spinner snaps to 15-minute steps, so starting from `DateTime.now()` would
/// open on a slot in the past (e.g. 17:13 -> 17:00).
DateTime _nextPickupSlot() {
  // 1. Earliest acceptable moment = now + 5 minutes.
  final earliest = DateTime.now().add(const Duration(minutes: 5));
  // 2. Drop the seconds.
  final base = DateTime(earliest.year, earliest.month, earliest.day,
      earliest.hour, earliest.minute);
  // 3. Round UP to the next 00 / 15 / 30 / 45 minute mark.
  final rest = earliest.minute % 15;
  return rest == 0 ? base : base.add(Duration(minutes: 15 - rest));
}
// <<< END: _nextPickupSlot - next pickup slot

// >>> START: _ClockState - the data and logic behind its screen
class _ClockState extends State<Clock> {
  // The time the spinner opens on (never in the past).
  final DateTime _initialTime = _nextPickupSlot();
  // The time the spinner currently shows (so a day change can re-check it).
  DateTime? _pickedTime;

  // Which day chip is selected: 0 = today, 1 = tomorrow.
  var selectedIndex;
  // Scroll position of the two day chips.
  ScrollController scrollController = ScrollController();
  // True after the default date (today) has been stored in the provider.
  bool isInitialized = false;

  final _formKey = new GlobalKey<FormState>();

  // Short names used on the day chips.
  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  List<String> listOfDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thr',
    'Fri',
    'Sat',
    'Sun',
  ];

  // >>> START: _applyTime - checks a time for the chosen day and stores it
  /// Combines the chosen DAY with [time]. In the past: the stored time is
  /// cleared (and, when [warn] is true, a pop-up asks for a future time).
  /// Otherwise it is stored as "HH:mm".
  void _applyTime(TripOptionsProvider provider, DateTime time,
      {required bool warn}) {
    final now = DateTime.now();
    final day = DateTime.parse(provider.pickupDate);
    final chosen = DateTime(day.year, day.month, day.day, time.hour, time.minute);
    if (chosen.isBefore(now)) {
      provider.setPickupTime('');
      if (warn) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('please_select_future_time'.tr),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                ),
                child: Text('ok'.tr),
              ),
            ],
          ),
        );
      }
    } else {
      provider.setPickupTime(DateFormat('HH:mm').format(time));
      setState(() {});
    }
  }
  // <<< END: _applyTime - checks a time for the chosen day and stores it

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    // The booking in progress; this sheet writes the date and time into it.
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 1.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.h),
            decoration: BoxDecoration(
                boxShadow: [tBackbtnBoxShadow],
                color: tWhite,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  // -----------------------------------------------------
                  // PART 1 - "Select Date": two chips, today and tomorrow.
                  // -----------------------------------------------------
                  Row(
                    children: [
                      Text(
                        'select_date'.tr,
                        style: TextStyle(
                            fontSize: isTab(context) ? 8.sp : 12.sp,
                            fontWeight: FontWeight.w700,
                            color: tSecondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                      height: isTab(context) ? 15.h : 120,
                      child: Consumer<TripOptionsProvider>(
                        builder: (context, tripOptionsProvider, _) {
                          // First time only: preselect TODAY.
                          if (!isInitialized) {
                            // Just before midnight the first free slot is
                            // already tomorrow: then start on tomorrow.
                            final today = DateTime.now();
                            final startsTomorrow =
                                _initialTime.day != today.day ||
                                    _initialTime.month != today.month;
                            DateTime selectedDate =
                                startsTomorrow ? _initialTime : today;
                            String formattedDate =
                                Twl.dateFormate(selectedDate);
                            tripOptionsProvider
                                .setPickupDateTime(formattedDate);
                            selectedIndex = startsTomorrow ? 1 : 0;
                            isInitialized = true;
                          }
                          return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(width: 1);
                            },
                            // Only two days can be booked: today, tomorrow.
                            itemCount: 2,
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                // Tapping a chip stores that date and clears
                                // the time (it must be picked again).
                                onTap: () {
                                  tripOptionsProvider.setPickupTime('');
                                  DateTime selectedDate =
                                      DateTime.now().add(Duration(days: index));
                                  String formattedDate =
                                      Twl.dateFormate(selectedDate);
                                  tripOptionsProvider
                                      .setPickupDateTime(formattedDate);
                                  // The spinner keeps its time: check it for
                                  // the new day (no warning pop-up here).
                                  _applyTime(tripOptionsProvider,
                                      _pickedTime ?? _initialTime,
                                      warn: false);

                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                // One chip: month, day number, weekday and a
                                // dot under the selected one.
                                child: Column(
                                  children: [
                                    Container(
                                      width: isTab(context) ? 18.w : 17.w,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: selectedIndex == index
                                            ? tPrimaryColor
                                            : tGray.withOpacity(0.1),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:
                                                isTab(context) ? 2.h : 0.6.h,
                                          ),
                                          // Month, e.g. "Oct"
                                          Text(
                                            listOfMonths[DateTime.now()
                                                        .add(Duration(
                                                            days: index))
                                                        .month -
                                                    1]
                                                .toString(),
                                            style: TextStyle(
                                              fontSize:
                                                  isTab(context) ? 9.sp : 11.sp,
                                              fontWeight: FontWeight.w500,
                                              color: selectedIndex == index
                                                  ? tWhite
                                                  : tSecondaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.2.h,
                                          ),
                                          // Day number, e.g. "14"
                                          Text(
                                            DateTime.now()
                                                .add(Duration(days: index))
                                                .day
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 15.sp
                                                  : 17.sp,
                                              fontWeight: FontWeight.w600,
                                              color: selectedIndex == index
                                                  ? tWhite
                                                  : tSecondaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.2.h,
                                          ),
                                          // Weekday, e.g. "Wed"
                                          Text(
                                            listOfDays[DateTime.now()
                                                        .add(Duration(
                                                            days: index))
                                                        .weekday -
                                                    1]
                                                .toString(),
                                            style: TextStyle(
                                              fontSize:
                                                  isTab(context) ? 8.sp : 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: selectedIndex == index
                                                  ? tWhite
                                                  : tSecondaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.8.h,
                                          ),
                                          // Dot marking the selected day.
                                          Container(
                                            child: selectedIndex == index
                                                ? Icon(
                                                    Icons.circle,
                                                    size: isTab(context)
                                                        ? 20
                                                        : 10,
                                                    color: tSecondaryColor,
                                                  )
                                                : null,
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  // -----------------------------------------------------
                  // PART 2 - "Select Time": scrolling hours and minutes
                  // (24-hour clock, 15-minute steps).
                  // -----------------------------------------------------
                  Row(
                    children: [
                      Text(
                        'select_time'.tr,
                        style: TextStyle(
                            fontSize: isTab(context) ? 8.sp : 12.sp,
                            fontWeight: FontWeight.w700,
                            color: tSecondaryColor),
                      ),
                    ],
                  ),
                  new TimePickerSpinner(
                      // Opens on the next valid slot (see _nextPickupSlot).
                      time: _initialTime,
                      is24HourMode: true,
                      normalTextStyle: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          color: tSecondaryColor),
                      highlightedTextStyle: TextStyle(
                          fontSize: 24,
                          color: tSecondaryColor,
                          fontWeight: FontWeight.w700),
                      itemHeight: 80,
                      isForce2Digits: false,
                      minutesInterval: 15,
                      // Called whenever the customer scrolls the time.
                      onTimeChange: (time) {
                        _pickedTime = time;
                        _applyTime(tripOptionsProvider, time, warn: true);
                      }),
                  // -----------------------------------------------------
                  // PART 3 - "OK": ask the server for the fare estimate.
                  // Until a date exists, a hint is shown instead.
                  // -----------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: tripOptionsProvider.pickupDate.isNotEmpty
                        ? Center(
                            child: SizedBox(
                              width: isTab(context) ? 60.w : 55.w,
                              height: isTab(context) ? 8.h : 7.h,
                              child: ButtonWidget(
                                  borderSide: BorderSide(
                                    color: tPrimaryColor,
                                  ),
                                  borderRadius: 14.0,
                                  color: tPrimaryColor,
                                  textcolor: Colors.black,
                                  child: Text(
                                    'OK'.tr,
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        color: tWhite,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            isTab(context) ? 10.sp : 16.sp),
                                  ),
                                  onTap: (startLoading, stopLoading,
                                      btnState) async {
                                    // No valid future time yet: say so.
                                    if (tripOptionsProvider.pickupTime.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'please_select_future_time'
                                                      .tr)));
                                      return;
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      startLoading();
                                      // 1. Everything the server needs to
                                      //    price the booking.
                                      Map<String, String> param = {
                                        // one-way (1) or round trip (2)
                                        'rider_type': tripOptionsProvider
                                            .riderType
                                            .toString(),
                                        // in-city (1) or out-station (2)
                                        'trip_type': tripOptionsProvider
                                            .tripType
                                            .toString(),
                                        // where from / where to
                                        'pickup_latitude':
                                            tripOptionsProvider.pickupLatitude,
                                        'pickup_longitude':
                                            tripOptionsProvider.pickupLongitude,
                                        'drop_latitude':
                                            tripOptionsProvider.dropLatitude,
                                        'drop_longitude':
                                            tripOptionsProvider.dropLongitude,
                                        'pickup_address':
                                            tripOptionsProvider.pickupAddress,
                                        'drop_address':
                                            tripOptionsProvider.dropAddress,
                                        // the customer's car
                                        'car_type': tripOptionsProvider.carType
                                            .toString(),
                                        'car_model': tripOptionsProvider
                                            .carModel
                                            .toString(),
                                        // when, and for how long
                                        'pickup_date': tripOptionsProvider
                                            .pickupDate
                                            .toString(),
                                        'pickup_time': tripOptionsProvider
                                            .pickupTime
                                            .toString(),
                                        'usage_hours': tripOptionsProvider
                                            .usageHours
                                            .toString(),
                                        // money options
                                        'coupon_code':
                                            tripOptionsProvider.couponCode,
                                        'is_vehicle_damage_protection':
                                            tripOptionsProvider
                                                .isVehicleDamageProtection,
                                        'payment_method':
                                            tripOptionsProvider.paymentMethod,
                                        // the city's rate card to use
                                        'city_id': tripOptionsProvider
                                            .selectedCityId
                                            .toString()
                                      };
                                      // 2. Ask the server (this does NOT save
                                      //    the booking unless isSaveBooking).
                                      var res = await ServicesAPI().getEstimate(
                                          context,
                                          param,
                                          tripOptionsProvider.isSaveBooking);
                                      if (res != null && res['status'] == 'OK') {
                                        // 3a. Price = estimate + any pending
                                        //     cancellation fee of the customer.
                                        tripOptionsProvider.setEstimatePrice(
                                            (res['estimate'] +
                                                    res['calculateEstimate'][
                                                        'cancellation_charges'])
                                                .toString());
                                        // 3b. Keep the full breakdown (base
                                        //     fare, GST, extras...) for the bill.
                                        tripOptionsProvider.setEstimate(
                                            res['calculateEstimate']);
                                        stopLoading();
                                        // 3c. Show the estimate screen.
                                        Twl.navigateTo(context, OneWay());
                                      } else {
                                        // 3'. Failed: show the server's
                                        //     reason (or a general message).
                                        stopLoading();
                                        final reason = (res is Map &&
                                                res['error'] != null)
                                            ? res['error'].toString()
                                            : 'Could not get the fare estimate. Please try again.';
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(reason)));
                                        }
                                      }
                                    }
                                  }),
                            ),
                          )
                        : Center(
                            child: Text("Please select Date and Time"),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _ClockState - the data and logic behind its screen
