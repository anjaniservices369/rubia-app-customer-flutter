// =============================================================================
// WHAT : Despite the name this is LIVE: the date and time picker (class Clock)
//        used when booking a driver, plus the default pickup slot helper.
// NOTES: The booking screen pre-fills the next free quarter-hour slot
//        (applyDefaultPickupSlot); this sheet only edits it. OK stores the
//        choice and closes the sheet; the screen that opened it asks the
//        server for the fare. The file name 'dummy' is historic.
// =============================================================================
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

// >>> START: Clock - date and time picker sheet
/// The "Select date / Select time" sheet of the Drivers booking.
///
/// The customer picks today or tomorrow, then a time in 15-minute steps. The
/// OK button stores the choice in the booking in progress and closes the sheet
/// (it pops `true`).
class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}
// <<< END: Clock - date and time picker sheet

// >>> START: nextPickupSlot - next pickup slot
/// First quarter-hour slot that is at least 5 minutes ahead of now. The
/// spinner snaps to 15-minute steps, so starting from `DateTime.now()` would
/// open on a slot in the past (e.g. 17:13 -> 17:00).
DateTime nextPickupSlot() {
  // 1. Earliest acceptable moment = now + 5 minutes.
  final earliest = DateTime.now().add(const Duration(minutes: 5));
  // 2. Drop the seconds.
  final base = DateTime(earliest.year, earliest.month, earliest.day,
      earliest.hour, earliest.minute);
  // 3. Round UP to the next 00 / 15 / 30 / 45 minute mark.
  final rest = earliest.minute % 15;
  return rest == 0 ? base : base.add(Duration(minutes: 15 - rest));
}
// <<< END: nextPickupSlot - next pickup slot

// >>> START: pickupDateTimeOf - the pickup moment stored in the booking
/// The pickup date and time stored in [provider] as one DateTime, or null when
/// either is missing or cannot be read.
DateTime? pickupDateTimeOf(TripOptionsProvider provider) {
  if (provider.pickupDate.isEmpty || provider.pickupTime.isEmpty) return null;
  try {
    final day = DateTime.parse(provider.pickupDate);
    final parts = provider.pickupTime.split(':');
    return DateTime(day.year, day.month, day.day, int.parse(parts[0]),
        int.parse(parts[1]));
  } catch (_) {
    return null;
  }
}
// <<< END: pickupDateTimeOf - the pickup moment stored in the booking

// >>> START: applyDefaultPickupSlot - pre-fills the pickup date and time
/// Stores the next free slot as the pickup date/time when none is chosen yet
/// or the chosen one has already passed. Returns true when it changed it.
bool applyDefaultPickupSlot(TripOptionsProvider provider) {
  final current = pickupDateTimeOf(provider);
  if (current != null && current.isAfter(DateTime.now())) return false;
  final slot = nextPickupSlot();
  provider.setPickupDateTime(Twl.dateFormate(slot));
  provider.setPickupTime(DateFormat('HH:mm').format(slot));
  return true;
}
// <<< END: applyDefaultPickupSlot - pre-fills the pickup date and time

// >>> START: _ClockState - the data and logic behind its screen
class _ClockState extends State<Clock> {
  // The time the spinner opens on: the time already chosen for the booking, or
  // the next free slot (never in the past).
  DateTime _initialTime = nextPickupSlot();
  // The time the spinner currently shows (so a day change can re-check it).
  DateTime? _pickedTime;
  // True once the spinner start time and the day chip were read from the booking.
  bool _readFromBooking = false;

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

    // First build only: open on the date and time already chosen for the
    // booking (set by applyDefaultPickupSlot or an earlier edit).
    if (!_readFromBooking) {
      _readFromBooking = true;
      final chosen = pickupDateTimeOf(tripOptionsProvider);
      if (chosen != null && chosen.isAfter(DateTime.now())) {
        _initialTime = chosen;
        final today = DateTime.now();
        selectedIndex =
            (chosen.day == today.day && chosen.month == today.month) ? 0 : 1;
        isInitialized = true;
      }
    }

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
                      // Opens on the time already chosen (or the next slot).
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
                                    // The time is stored in the booking in
                                    // progress; the screen that opened this
                                    // sheet asks for the fare itself.
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.pop(context, true);
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
