// =============================================================================
// WHAT : A note on an outstation round trip's details and bill: the customer provides the driver's food and accommodation.
// NOTES: Shown only for an outstation (trip_type 2) round trip (rider_type 2). They are not part of the fare.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';

// >>> START: DriverFoodStayNote - "food and accommodation for the driver are provided by the customer"
class DriverFoodStayNote extends StatelessWidget {
  const DriverFoodStayNote({Key? key, required this.rideDetails}) : super(key: key);
  final rideDetails;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripType = int.tryParse(rideDetails['trip_type'].toString()) ?? 0;
    final riderType = int.tryParse(rideDetails['rider_type'].toString()) ?? 0;
    if (tripType != TRIP_TYPE_OUTSTATION || riderType != RIDER_TYPE_ROUNDTRIP) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: tPrimaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: tPrimaryColor.withOpacity(0.35), width: 0.8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.restaurant, size: 18, color: tPrimaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Food and accommodation for the driver are provided by the customer during the trip. They are not included in the fare.",
              style: TextStyle(color: tDarkNavyblue, fontSize: isTab(context) ? 7.sp : 9.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: DriverFoodStayNote - "food and accommodation for the driver are provided by the customer"
