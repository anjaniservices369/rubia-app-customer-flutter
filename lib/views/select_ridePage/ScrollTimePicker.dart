// =============================================================================
// WHAT : Scrolling time picker widget.
// NOTES: Visual component.
// =============================================================================
import 'package:flutter/material.dart';

// >>> START: ScrollableTimePicker - screen/widget shell (the visible part is in its State class)
class ScrollableTimePicker extends StatefulWidget {
  final ValueChanged<TimeOfDay>? onTimeChanged;

  ScrollableTimePicker({this.onTimeChanged});

  @override
  _ScrollableTimePickerState createState() => _ScrollableTimePickerState();
}
// <<< END: ScrollableTimePicker - screen/widget shell (the visible part is in its State class)

// >>> START: _ScrollableTimePickerState - the data and logic behind its screen
class _ScrollableTimePickerState extends State<ScrollableTimePicker> {
  ScrollController _hourScrollController = ScrollController();
  ScrollController _minuteScrollController = ScrollController();
  int _selectedHour = 0;
  int _selectedMinute = 0;
  final int _visibleHours = 3; // Number of visible hours in the picker

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    _scrollToCurrentTime();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: _scrollToCurrentTime - scroll to current time
  void _scrollToCurrentTime() {
    DateTime now = DateTime.now();
    setState(() {
      _selectedHour = now.hour;
      _selectedMinute = now.minute;
    });
    _hourScrollController.animateTo(
      _selectedHour * 80.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _minuteScrollController.animateTo(
      _selectedMinute * 80.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  // <<< END: _scrollToCurrentTime - scroll to current time

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 200.0,
          width: 80.0,
          child: ListView.builder(
            controller: _hourScrollController,
            itemExtent: 80.0,
            itemCount: 24,
            itemBuilder: (context, index) {
              int hour = index % 24;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedHour = hour;
                  });
                  widget.onTimeChanged?.call(TimeOfDay(
                    hour: _selectedHour,
                    minute: _selectedMinute,
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    hour.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 24.0,
                      color: _selectedHour == hour ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 200.0,
          width: 80.0,
          child: ListView.builder(
            controller: _minuteScrollController,
            itemExtent: 80.0,
            itemCount: 60,
            itemBuilder: (context, index) {
              int minute = index % 60;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMinute = minute;
                  });
                  widget.onTimeChanged?.call(TimeOfDay(
                    hour: _selectedHour,
                    minute: _selectedMinute,
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    minute.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 24.0,
                      color:
                          _selectedMinute == minute ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _ScrollableTimePickerState - the data and logic behind its screen
