// =============================================================================
// WHAT : Asks the customer to rate the driver once a ride is completed AND paid
//        (the driver has confirmed the payment in the Partner app), wherever
//        they are in the app. Until then the customer sees the final bill.
//        The rating and a written review are COMPULSORY: the sheet cannot be
//        closed or skipped, and the server refuses a new booking until the
//        previous ride is rated.
// NOTES: Server: view-booking (status), add-review. The active booking id is
//        kept in the phone's saved data ('booking_id', written when the booking
//        is confirmed). A completed, paid ride is asked again on every check
//        until it is rated; 'ride_resolved_id' remembers rides that need
//        nothing more (rated, or cancelled).
// =============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonWidget.dart';
import '../../../globalWidgets/driverAvatar.dart';
import '../../../responsive.dart';

// >>> START: RideRatingPrompt - finds a completed, unrated ride and asks for the rating
class RideRatingPrompt {
  static bool _showing = false;
  static bool _checking = false;
  // The open rating sheet, so a second caller can wait for it to close.
  static Future<dynamic>? _sheet;

  // >>> START: _isFinished - true when the booking can no longer change
  static bool _isFinished(int status) =>
      status == STATUS_RIDE_COMPLETED ||
      status == STATUS_USER_CANCELLED ||
      status == STATUS_BOOKING_AUTO_CANCELLED ||
      status == STATUS_DRIVER_CANCELLED ||
      status == STATUS_CANCELLED;
  // <<< END: _isFinished - true when the booking can no longer change

  // >>> START: check - looks at the active booking and prompts if it just completed
  /// Quietly asks the server for the status of the booking placed from this
  /// phone. When it has just been completed and not rated, the rating sheet
  /// opens on top of whatever screen is showing. Does nothing when there is no
  /// active booking, or it was already handled.
  static Future<void> check(BuildContext context) async {
    if (_showing || _checking) return;
    _checking = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('booking_id');
      if (id == null || id.isEmpty || id == prefs.getString('ride_resolved_id')) {
        return;
      }
      final res = await UserAPI().viewBookingBG(id);
      if (res == null || res['status'] != 'OK') return;
      final details = res['details'];
      final status = int.tryParse(details['status'].toString()) ?? 0;
      if (!_isFinished(status)) return;
      if (status == STATUS_RIDE_COMPLETED) {
        // A completed ride waits for the driver to confirm the payment: the customer sees the bill meanwhile, and the
        // rating is asked on a later tick.
        if (!_isPaid(details)) return;
        // Paid but not rated: the rating is compulsory, so it is asked again until it is given.
        if (_isUnrated(details)) {
          if (context.mounted) await _show(context, details);
          return;
        }
      }
      // Nothing more to do for this ride (rated, or cancelled).
      await prefs.setString('ride_resolved_id', id);
    } catch (_) {
      // A failed check is retried on the next tick.
    } finally {
      _checking = false;
    }
  }
  // <<< END: check - looks at the active booking and prompts if it just completed

  // >>> START: promptForBooking - asks for the rating of a given ride (the server refused a new booking until it is rated)
  /// Used when the server answers that the previous ride must be rated first (`rate_booking_id`).
  static Future<void> promptForBooking(BuildContext context, String bookingId) async {
    if (_showing || bookingId.isEmpty) return;
    final res = await UserAPI().viewBookingBG(bookingId);
    if (res == null || res['status'] != 'OK') return;
    final details = res['details'];
    if ((int.tryParse(details['status'].toString()) ?? 0) == STATUS_RIDE_COMPLETED &&
        _isUnrated(details) &&
        context.mounted) {
      await _show(context, details);
    }
  }
  // <<< END: promptForBooking - asks for the rating of a given ride (the server refused a new booking until it is rated)

  // >>> START: promptCompleted - asks for the rating of a ride the screen has just seen complete
  /// Used by the live ride screen, which already knows the ride is completed.
  /// Returns after the sheet closes (rated, or 'Later'). A rating sends the
  /// customer Home, which closes the calling screen as well.
  static Future<void> promptCompleted(BuildContext context, details) async {
    // Not paid yet: the bill is shown and the app-wide check asks for the rating when the driver confirms the payment.
    if (!_isPaid(details)) return;
    // The app-wide check may have opened the sheet a moment earlier: wait for
    // it, so the bill is not pushed on top of an open sheet.
    if (_showing) {
      await _sheet;
      return;
    }
    if (!_isUnrated(details) || !context.mounted) return;
    await _show(context, details);
  }
  // <<< END: promptCompleted - asks for the rating of a ride the screen has just seen complete

  // >>> START: _isPaid - true once the driver has confirmed the payment
  static bool _isPaid(details) =>
      (int.tryParse(details['payment_status'].toString()) ?? 0) == PAYMENT_STATUS_PAID;
  // <<< END: _isPaid - true once the driver has confirmed the payment

  // >>> START: _isUnrated - true when the customer has not rated this ride yet
  static bool _isUnrated(details) =>
      details['user_my_ratings'] == null || details['user_my_ratings'] == '';
  // <<< END: _isUnrated - true when the customer has not rated this ride yet

  // >>> START: _show - opens the rating sheet
  static Future<void> _show(BuildContext context, details) async {
    _showing = true;
    try {
      // Compulsory: it cannot be dragged away, tapped away or closed with Back.
      _sheet = showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (_) => PopScope(canPop: false, child: _RateRideSheet(details: details)),
      );
      await _sheet;
    } finally {
      _showing = false;
      _sheet = null;
    }
  }
  // <<< END: _show - opens the rating sheet
}
// <<< END: RideRatingPrompt - finds a completed, unrated ride and asks for the rating

// >>> START: _RateRideSheet - the rating sheet: stars and a review (both compulsory), Submit
class _RateRideSheet extends StatefulWidget {
  const _RateRideSheet({Key? key, required this.details}) : super(key: key);
  final details;

  @override
  State<_RateRideSheet> createState() => _RateRideSheetState();
}

// >>> START: _RateRideSheetState - the data and logic behind its screen
class _RateRideSheetState extends State<_RateRideSheet> {
  double _rating = 5;
  final TextEditingController _review = TextEditingController();

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: _submit - saves the rating, thanks the customer and opens Home
  Future<void> _submit(void Function() stopLoading) async {
    // Stars and a written review are both compulsory.
    if (_rating < 1 || _review.text.trim().isEmpty) {
      stopLoading();
      Twl.createAlert(context, 'Review needed', 'Please give a rating and write a review for your driver to continue.');
      return;
    }
    final res = await UserAPI().myAddReview(context, {
      'booking_id': widget.details['id'].toString(),
      'rating': _rating.toString(),
      'review': _review.text.trim(),
    });
    if (!mounted) return;
    if (res != null && res['status'] == 'OK') {
      Twl.goHomeAfterRating(context);
    } else {
      stopLoading();
      Twl.createAlert(context, 'Oops',
          (res is Map && res['error'] != null) ? res['error'].toString() : 'Please try again.');
    }
  }
  // <<< END: _submit - saves the rating, thanks the customer and opens Home

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final driverName = (widget.details['driver_name'] ?? '').toString();
    final driverImage = (widget.details['driver_image'] ?? '').toString();
    return SingleChildScrollView(
      child: Container(
        // Keep the sheet above the keyboard while writing the review, and above the phone's own navigation bar.
        padding: MediaQuery.of(context).viewInsets +
            EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
        decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ride_completed'.tr,
                  style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontWeight: FontWeight.w800,
                      fontSize: isTab(context) ? 12.sp : 18.sp)),
              SizedBox(height: 1.5.h),
              DriverAvatar(imageUrl: driverImage, radius: isTab(context) ? 30 : 34),
              SizedBox(height: 1.h),
              if (driverName.isNotEmpty)
                Text(driverName,
                    style: TextStyle(
                        color: tDarkNavyblue,
                        fontWeight: FontWeight.w600,
                        fontSize: isTab(context) ? 10.sp : 14.sp)),
              SizedBox(height: 1.h),
              Text('Rate your driver',
                  style: GoogleFonts.mulish(
                      color: tBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: isTab(context) ? 8.sp : 12.sp)),
              SizedBox(height: 1.h),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                unratedColor: tlightGray,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: isTab(context) ? 60 : 40,
                itemPadding: EdgeInsets.symmetric(horizontal: 0.4.h),
                itemBuilder: (context, _) =>
                    Icon(Icons.star_rounded, color: Colors.orange),
                onRatingUpdate: (r) => setState(() => _rating = r),
              ),
              SizedBox(height: 1.5.h),
              TextFormField(
                controller: _review,
                maxLines: 2,
                style: TextStyle(
                    color: tDarkNavyblue,
                    fontSize: isTab(context) ? 9.sp : 12.sp,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    hintText: 'write_a_review_to'.tr + ' *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: tBackground, width: 1.5))),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: 50.w,
                height: isTab(context) ? 6.h : 7.h,
                child: ButtonWidget(
                    borderSide: BorderSide(color: tPrimaryColor),
                    borderRadius: isTab(context) ? 20.0 : 14.0,
                    color: tPrimaryColor,
                    textcolor: tWhite,
                    child: Text('submit'.tr,
                        style: TextStyle(
                            letterSpacing: 1,
                            color: tWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: isTab(context) ? 10.sp : 14.sp)),
                    onTap: (startLoading, stopLoading, btnState) async {
                      startLoading();
                      await _submit(stopLoading);
                    }),
              ),
              SizedBox(height: 1.h),
              Text('Rating and review are required to continue.',
                  style: TextStyle(
                      color: tGray,
                      fontSize: isTab(context) ? 8.sp : 11.sp,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _RateRideSheetState - the data and logic behind its screen
// <<< END: _RateRideSheet - the rating sheet: stars and a review (both compulsory), Submit
