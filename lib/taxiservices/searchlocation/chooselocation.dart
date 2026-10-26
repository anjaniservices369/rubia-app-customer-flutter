// =============================================================================
// WHAT : TAXI: list of suggested places to pick from.
// NOTES: Taxi service.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/RideBooking/FavLocations.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// >>> START: ChooseLocation - screen/widget shell (the visible part is in its State class)
class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key, this.pickupAddress, this.dropAddress})
      : super(key: key);
  final pickupAddress;
  final dropAddress;

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}
// <<< END: ChooseLocation - screen/widget shell (the visible part is in its State class)

// >>> START: _ChooseLocationState - the data and logic behind its screen
class _ChooseLocationState extends State<ChooseLocation> {
  // bool isLocationFetched = false;
  // @override
  //         Provider.of<TripOptionsProvider>(context, listen: false);

  //     // Check if the current location has already been fetched
  //     if (!isLocationFetched) {
  //       tripOptionsProvider.getCurrentLocation();
  //       isLocationFetched =
  //           true; // Set the flag to true to indicate that the location has been fetched

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    //  String currentLocation = tripOptionsProvider.;
    // Get the polyline coordinates from the provider

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  //set Lcoation Type here whether pickup or drop
                  tripOptionsProvider.setLocationType(1);
                  await showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: FavLocation());
                      });
                },
                child: Container(
                    padding: EdgeInsets.all(isTab(context) ? 12 : 8),
                    decoration: BoxDecoration(
                        color: tBackground, shape: BoxShape.circle),
                    child: Image.asset(
                      Images.GREENLOCATIONICON,
                      scale: isTab(context) ? 2 : 3.5,
                    )),
              ),
              DottedLine(
                direction: Axis.vertical,
                lineLength: 30,
                lineThickness: 1.0,
                dashLength: 4.0,
                dashColor: tDotted,
                dashGapLength: 4.0,
                dashGapRadius: 0.0,
              ),
              GestureDetector(
                onTap: () async {
                  tripOptionsProvider.setLocationType(2);
                  await showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: FavLocation());
                      });
                },
                child: Image.asset(
                  Images.REDLOCATIONICON,
                  scale: isTab(context) ? 2 : 3.5,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    //set Lcoation Type here whether pickup or drop
                    tripOptionsProvider.setLocationType(1);
                    await showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: FavLocation(),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 100.w,
                    child: Consumer<TripOptionsProvider>(
                        builder: (context, provider, _) {
                      return Text(
                        tripOptionsProvider.pickupAddress.isNotEmpty
                            ? tripOptionsProvider.pickupAddress
                            : 'Current Location',
                        style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: isTab(context) ? 12.0 : 14.0,
                          fontWeight: FontWeight.w600,
                          color: tDarkNavyblue,
                        ),
                        maxLines: 2,
                      );
                    }),
                  ),
                ),
                Divider(
                  height: 4.h,
                  thickness: 0.9,
                  color: tDividerColor,
                ),
                GestureDetector(
                  onTap: () async {
                    tripOptionsProvider.setLocationType(2);
                    await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) {
                          return Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: FavLocation());
                        });
                  },
                  child: Container(
                    width: 100.w,
                    child: Text(
                      widget.dropAddress.isNotEmpty
                          ? widget.dropAddress.toString()
                          : 'drop_location'.tr,
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        fontSize: isTab(context) ? 12.0 : 14.0,
                        fontWeight: FontWeight.w600,
                        color: tDarkNavyblue,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _ChooseLocationState - the data and logic behind its screen
