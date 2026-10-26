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
import '../api_services/userApi.dart';
import '../globalFuctions/globalFunctions.dart';
import '../providers/riderProvider.dart';
import '../responsive.dart';
import '../views/RideBooking/FavLocations.dart';
import 'dropGoogleMap.dart';
import 'pickupgoogleMap.dart';

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
  // >>> START: _openPicker - opens the favourites sheet, or the map when there are none
  /// [type] 1 = pickup, 2 = drop. A customer with saved favourites sees the
  /// favourites sheet (which also has "Select From Map"); a customer without
  /// any goes straight to the map, so no empty sheet has to be dismissed.
  Future<void> _openPicker(int type) async {
    final provider =
        Provider.of<TripOptionsProvider>(context, listen: false);
    provider.setLocationType(type);

    var hasFavourites = true;
    try {
      final res = await UserAPI().favoriteList(context);
      if (res is Map && res['status'] == 'OK') {
        final details = res['details'];
        hasFavourites = details is List && details.isNotEmpty;
      } else if (res is Map && res['status'] == 'NOK') {
        // "No Favourite Locations found"
        hasFavourites = false;
      }
      // Anything else (no answer) keeps the old behaviour: show the sheet.
    } catch (_) {
      hasFavourites = true;
    }
    if (!mounted) return;

    if (!hasFavourites) {
      if (type == 1) {
        Twl.navigateTo(context, PickupAddressGoogleMapPage());
      } else {
        Twl.forceNavigateTo(context, DropGoogleMap());
      }
      return;
    }
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: FavLocation());
        });
  }
  // <<< END: _openPicker - opens the favourites sheet, or the map when there are none

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
                onTap: () => _openPicker(1),
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
                  onTap: () => _openPicker(2),
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
                  onTap: () => _openPicker(1),
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
                    onTap: () => _openPicker(2),
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
