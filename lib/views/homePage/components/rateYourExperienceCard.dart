// =============================================================================
// WHAT : Detailed 'rate your experience' card (stars + comment).
// NOTES: Calls add-review.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonWidget.dart';

import '../../../responsive.dart';
import 'Rategratingcard.dart';

// >>> START: RateYourExperienceCardWidget - screen/widget shell (the visible part is in its State class)
class RateYourExperienceCardWidget extends StatefulWidget {
  const RateYourExperienceCardWidget({
    Key? key,
    this.bookingId,
  }) : super(key: key);
  final bookingId;

  @override
  State<RateYourExperienceCardWidget> createState() =>
      _RateYourExperienceCardWidgetState();
}
// <<< END: RateYourExperienceCardWidget - screen/widget shell (the visible part is in its State class)

// >>> START: _RateYourExperienceCardWidgetState - the data and logic behind its screen
class _RateYourExperienceCardWidgetState
    extends State<RateYourExperienceCardWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedRating;
  TextEditingController controller = TextEditingController();
  final TextEditingController _rateTextController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  //     },
  //   );
  // }

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
                padding: MediaQuery.of(context).viewInsets,
                decoration: BoxDecoration(
                    color: tWhite,
                    boxShadow: [tBoxShadow],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        //       'Rate_your_exp'.tr,
                        //       style: TextStyle(
                        //           color: tDarkNavyblue,
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: isTab(context) ? 10.sp : 14.sp),
                        //     ),
                        //     Text(
                        //       'Skipper'.tr,
                        //       style: TextStyle(
                        //           color: tDarkNavyblue,
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: isTab(context) ? 10.sp : 14.sp),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 1.h,
                        ),
                        // riderdetails(rideData: widget.rideData),

                        SizedBox(
                          height: 2.8.h,
                        ),
                        Text(
                          'Are_you_Satisfied'.tr,
                          style: GoogleFonts.mulish(
                              color: tDarkNavyblue,
                              fontWeight: FontWeight.w700,
                              fontSize: isTab(context) ? 10.sp : 14.sp),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Center(
                            child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          unratedColor: tlightGray,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: isTab(context) ? 60 : 40,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.4.h),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rounded,
                            color: Colors.orange,
                          ),
                          onRatingUpdate: (rating) {
                            // print(rating);
                            setState(() {
                              // print(selectedRating);
                              selectedRating = rating;
                              //rating = selectedRating;
                            });
                          },
                        )),
                        SizedBox(
                          height: 4.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Add_Review'.tr,
                            style: TextStyle(
                                color: tDarkNavyblue,
                                fontWeight: FontWeight.w700,
                                fontSize: isTab(context) ? 10.sp : 14.sp),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: tDarkNavyblue,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w600),
                          controller: _rateTextController,
                          maxLines: isTab(context) ? 3 : 2,
                          decoration: InputDecoration(
                              fillColor: tWhite,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      width: 1.5, color: tBackground)),
                              hintText: 'Write_a_review_to'.tr,
                              hintStyle: TextStyle(
                                  fontFamily: "Barlow",
                                  color: tGray,
                                  fontSize: isTab(context) ? 7.sp : 10.sp,
                                  fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: tBackground, width: 1.5))),
                        ),
                        // AddReveiwtextformfield(),
                        SizedBox(
                          height: 3.h,
                        ),
                        Center(
                          child: SizedBox(
                            width: isTab(context) ? 50.w : 50.w,
                            height: isTab(context) ? 6.h : 7.h,
                            child: ButtonWidget(
                                borderSide: BorderSide(
                                  color: tPrimaryColor,
                                ),
                                // borderRadius: BorderRadius.circular(15),
                                borderRadius: isTab(context) ? 20.0 : 14.0,
                                color: tPrimaryColor,
                                textcolor: tWhite,
                                child: Text(
                                  'Submit'.tr,
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: tWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: isTab(context) ? 10.sp : 14.sp),
                                ),
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  // Twl.forceNavigateTo(context, RatingCard());

                                  if (_formKey.currentState!.validate()) {
                                    startLoading();
                                    // Twl.navigateTo(context, RatingCard(rideData: widget.rideData));
                                    Map<String, String> param = {
                                      'booking_id': widget.bookingId.toString(),
                                      'rating': selectedRating.toString(),
                                      'review': _rateTextController.text,
                                    };

                                    var res = await UserAPI()
                                        .myAddReview(context, param);
                                    if (res != null && res['status'] == 'OK') {
                                      Twl.forceNavigateTo(
                                          context, RatingCard());
                                      // Twl.navigateTo(context,
                                      //     RatingCard(rideData: widget.rideData));
                                    } else {
                                      Twl.createAlert(context, 'Oops',
                                          res['error'].toString());
                                    }
                                    stopLoading();
                                  }
                                }),
                          ),
                        ),
                        SizedBox(
                          height: isTab(context) ? tDefaultPadding : 1.h,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _RateYourExperienceCardWidgetState - the data and logic behind its screen
