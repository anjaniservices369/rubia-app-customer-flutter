// =============================================================================
// WHAT : TAXI: wrapper that shows the ride screens while a ride is open and the
//        normal app otherwise.
// NOTES: Listens to RideService.rideStream.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';

import 'package:base_project_flutter/taxiservices/rideservices/riderServices.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/riderProvider.dart';
import '../searchingDriver.dart';

// >>> START: NewRideLayout - screen/widget shell (the visible part is in its State class)
class NewRideLayout extends StatefulWidget {
  final Widget child;

  NewRideLayout({required this.child});

  @override
  State<NewRideLayout> createState() => _NewRideLayoutState();
}
// <<< END: NewRideLayout - screen/widget shell (the visible part is in its State class)

// >>> START: _NewRideLayoutState - the data and logic behind its screen
class _NewRideLayoutState extends State<NewRideLayout> {
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  var userId;
  // >>> START: init - starts push notifications (asks permission, registers the phone)
  init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString('userId');
    });
  }
  // <<< END: init - starts push notifications (asks permission, registers the phone)

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return userId != null
        ? StreamBuilder<Map<String, dynamic>?>(
            stream: RideService().rideStream(uid: userId),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final data = snapshot.data!;
                // A ride is open: show it (searching, pickup, riding, rating).
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Provider.of<TripOptionsProvider>(context, listen: false)
                      .setRideData(data);
                });
                return SearchingDriverPage(rideData: data);
              } else {
                return widget.child;
              }
              //return child!;
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _NewRideLayoutState - the data and logic behind its screen
