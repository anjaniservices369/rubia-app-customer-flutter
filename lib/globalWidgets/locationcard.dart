// =============================================================================
// WHAT : Card showing pickup and drop addresses of a trip.
// NOTES: Visual component.
// =============================================================================
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../constants/constants.dart';
import '../constants/imageConstant.dart';
import '../providers/riderProvider.dart';
import '../responsive.dart';
import '../views/RideBooking/FavLocations.dart';

// >>> START: LocationCards - screen/widget shell (the visible part is in its State class)
class LocationCards extends StatefulWidget {
  const LocationCards(
      {Key? key,
      this.status,
      this.pickupAddress,
      this.dropAddress,
      this.tripStatus,
      this.rideDetails})
      : super(key: key);
  final tripStatus;
  final status;
  final pickupAddress;
  final dropAddress;
  final rideDetails;
  @override
  State<LocationCards> createState() => _LocationCardsState();
}
// <<< END: LocationCards - screen/widget shell (the visible part is in its State class)

// >>> START: _LocationCardsState - the data and logic behind its screen
class _LocationCardsState extends State<LocationCards> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

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
              if (tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY)
                DottedLine(
                  direction: Axis.vertical,
                  lineLength: 30,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: tDotted,
                  dashGapLength: 4.0,
                  dashGapRadius: 0.0,
                ),
              if (tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY)
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
                      widget.pickupAddress.isNotEmpty
                          ? widget.pickupAddress.toString()
                          : 'pick_up_location'.tr,
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
                if (tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY)
                  Divider(
                    height: 4.h,
                    thickness: 0.9,
                    color: tDividerColor,
                  ),
                if (tripOptionsProvider.riderType == RIDER_TYPE_ONEWAY)
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
// <<< END: _LocationCardsState - the data and logic behind its screen
