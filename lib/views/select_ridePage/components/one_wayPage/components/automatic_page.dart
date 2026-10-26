// =============================================================================
// WHAT : Automatic-gear car list tab; loads the vehicle types from the server.
// NOTES: Server: vehicle-types.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../../api_services/userApi.dart';
import '../../../../../providers/riderProvider.dart';

// >>> START: AutomaticTabPage - screen/widget shell (the visible part is in its State class)
class AutomaticTabPage extends StatefulWidget {
  const AutomaticTabPage({Key? key, this.vehicleType}) : super(key: key);
  final vehicleType;

  @override
  State<AutomaticTabPage> createState() => _AutomaticTabPageState();
}
// <<< END: AutomaticTabPage - screen/widget shell (the visible part is in its State class)

// >>> START: _AutomaticTabPageState - the data and logic behind its screen
class _AutomaticTabPageState extends State<AutomaticTabPage> {
  // List<String> images = [Images.CAR, Images.CAR, Images.CAR, Images.CAR];
  // List<String> destinationText = ['Hatchback', 'Sedan', 'SUV', 'Luxury'];

  var rides;
  var vehicleStatus = 1;

  var vehicleTypeDetails;
  var serviceNOK;
  // >>> START: fetchVehicleType - fetches vehicle type
  fetchVehicleType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res =
        await UserAPI().vehicleType(context, widget.vehicleType.toString());
    // widget.vehicleType.toString(),

    if (res != null && res['status'] == 'OK') {
      if (mounted) {
        // Keep the car already chosen (the screen is rebuilt after the map
        // pickers); otherwise start on the first car.
        final provider =
            Provider.of<TripOptionsProvider>(context, listen: false);
        final list = res['details'] as List;
        var selected =
            list.indexWhere((v) => v['title'] == provider.carModel);
        if (selected < 0) {
          selected = 0;
          if (list.isNotEmpty) provider.setCarModel(list[0]['title']);
        }
        setState(() {
          vehicleTypeDetails = list;
          rides = selected;
        });
      }
    } else {
      setState(() {
        serviceNOK = res['status'];
      });
    }
  }
  // <<< END: fetchVehicleType - fetches vehicle type

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVehicleType();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return Column(
      children: [
        if (serviceNOK !=
            null) // Show error message if serviceNOK contains an error
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: tWhite,
              boxShadow: [tBoxShadow],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              "No vehicles found",
              style: TextStyle(color: Colors.red),
            ),
          )
        else if (vehicleTypeDetails ==
            null) // Show loading spinner if data is loading
          SpinKitThreeBounce(
            color: tPrimaryColor,
            size: 20.0,
          )
        else // Show the vehicle types list if data is available
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: tWhite,
              boxShadow: [tBoxShadow],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: 15.h,
              child: ListView.builder(
                itemCount: vehicleTypeDetails.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var vehicle = vehicleTypeDetails[index];
                  return GestureDetector(
                    onTap: () {
                      tripOptionsProvider.setCarModel(vehicle['title']);
                      setState(() {
                        rides = index; // This is the problematic part
                      });
                    },
                    child: Container(
                      width: 20.w,
                      // height: 5.h,
                      // padding: EdgeInsets.all(6),
                      margin: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                          color: rides == index ? tPrimaryColor : tWhite,
                          // boxShadow: [tBoxShadow],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: rides == index
                                  ? tPrimaryColor
                                  : tlightGrayColor,
                              width: 1.5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            vehicle['image'],
                            scale: isTab(context) ? 2 : 4,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(vehicle['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mulish(
                                  color:
                                      rides == index ? tWhite : tDarkNavyblue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: isTab(context) ? 8.sp : 7.sp)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _AutomaticTabPageState - the data and logic behind its screen
