// =============================================================================
// WHAT : A note at the top of a completed ride's bill while the driver has not yet confirmed the payment.
// NOTES: Shown only when the ride is completed and booking.payment_status is not 'paid' (collect-cash in the Partner app sets
//        it). The customer pays the driver; once the driver confirms, the app asks for the rating (see rateRide.dart).
// =============================================================================
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';

// >>> START: PaymentPendingNote - "pay the driver, then rate" note on an unpaid completed ride
class PaymentPendingNote extends StatelessWidget {
  const PaymentPendingNote({Key? key, required this.rideDetails}) : super(key: key);
  final rideDetails;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final completed = rideDetails['status'] == STATUS_RIDE_COMPLETED;
    final paid = (int.tryParse(rideDetails['payment_status'].toString()) ?? 0) == PAYMENT_STATUS_PAID;
    if (!completed || paid) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: tYellow.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
      child: Text(
        'Your ride is complete. Please pay the driver the amount below in cash. You can rate your driver once the driver confirms the payment.',
        style: TextStyle(color: tDarkNavyblue, fontSize: isTab(context) ? 9.sp : 11.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: PaymentPendingNote - "pay the driver, then rate" note on an unpaid completed ride
