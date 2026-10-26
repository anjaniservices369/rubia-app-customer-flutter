// =============================================================================
// WHAT : Date-range picker for the transaction filter.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// >>> START: PickCustomDate - screen/widget shell (the visible part is in its State class)
class PickCustomDate extends StatefulWidget {
  String filterValue;

  PickCustomDate({
    Key? key,
    required this.filterValue,
    this.isEarningPage,
  }) : super(key: key);
  final isEarningPage;

  @override
  State<PickCustomDate> createState() => _PickCustomDateState();
}
// <<< END: PickCustomDate - screen/widget shell (the visible part is in its State class)

// >>> START: _PickCustomDateState - the data and logic behind its screen
class _PickCustomDateState extends State<PickCustomDate> {
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  var startDate;
  var endDate;
  // >>> START: _onSelectionChanged - reacts to selection changed
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
    debugPrint(args.value.startDate.toString().substring(0, 10));
    debugPrint(args.value.endDate.toString());
    setState(() {
      startDate = formatter.format(args.value.startDate);
      endDate = formatter.format(args.value.endDate);
    });
  }
  // <<< END: _onSelectionChanged - reacts to selection changed

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300,
            width: 400,
            child: SfDateRangePicker(
              rangeSelectionColor: tPrimaryColor.withOpacity(0.4),
              startRangeSelectionColor: tPrimaryColor,
              endRangeSelectionColor: tPrimaryColor,
              rangeTextStyle: TextStyle(
                decorationColor: tWhite,
                color: tWhite,
              ),
              selectionColor: tWhite,
              yearCellStyle: DateRangePickerYearCellStyle(),
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: TextStyle(color: tBlack),
                todayTextStyle: TextStyle(color: tPrimaryColor),
                disabledDatesTextStyle: TextStyle(color: tGray),
              ),
              selectionTextStyle: TextStyle(color: tWhite),
              maxDate: DateTime.now(),
              headerStyle: DateRangePickerHeaderStyle(
                textStyle: TextStyle(
                  color: tWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                backgroundColor: tPrimaryColor.withOpacity(0.7),
              ),
              backgroundColor: tWhite,
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              confirmText: 'Ok',
              cancelText: 'Cancel',
              onSubmit: (dateTime) {
                debugPrint(dateTime.toString());
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Twl.navigateBack(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: tPrimaryColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('filteredEarnigs');
                  sharedPreferences.setString('filteredEarnigs', 'Custom');
                  var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
                  sharedPreferences.remove('customFilter');
                  sharedPreferences.setString('startDate', startDate);
                  sharedPreferences.setString('endDate', endDate);
                  setState(() {
                    widget.filterValue = 'Custom';
                    widget.isEarningPage == true
                        ? Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BottomNavigation(
                                      tabIndexId: 2,
                                      selectedType: 'Custom',
                                    )),
                            (Route<dynamic> route) => false)
                        : Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BottomNavigation(
                                      tabIndexId: 2,
                                      selectedType: 'Custom',
                                    )),
                            (Route<dynamic> route) => false);
                  });
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: tPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _PickCustomDateState - the data and logic behind its screen
