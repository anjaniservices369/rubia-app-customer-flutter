// =============================================================================
// WHAT : Details of an ongoing or past booking with the driver card and rating.
// NOTES: Server: view-booking-details.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/imageConstant.dart';
import '../../../../globalWidgets/buttonIconWidget.dart';
import '../../../../globalWidgets/buttonWidget.dart';
import '../../../../providers/riderProvider.dart';
import '../../../../responsive.dart';
import '../../../bottomNavigation.dart/bottomNavigation.dart';
import 'components/amountCardWidget.dart';
import 'components/distanceAndDurationCard.dart';
import 'components/rideCardWidget.dart';

// import 'package:downloads_path_provider/downloads_path_provider.dart';

// >>> START: RideDetailsView - screen/widget shell (the visible part is in its State class)
class RideDetailsView extends StatefulWidget {
  const RideDetailsView({
    Key? key,
    this.rideId,
    this.rideDetails,
  }) : super(key: key);
  final rideId;
  final rideDetails;
  @override
  State<RideDetailsView> createState() => _RideDetailsViewState();
}
// <<< END: RideDetailsView - screen/widget shell (the visible part is in its State class)

// >>> START: _RideDetailsViewState - the data and logic behind its screen
class _RideDetailsViewState extends State<RideDetailsView> {
  double value = 5;
  int userRating = 0;

  // >>> START: launchURL - launch url
  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
    }
  }
  // <<< END: launchURL - launch url
  // var rideDetails;
  // var resNOK;

  var selectedRating;
  final TextEditingController _rateTextController = TextEditingController();

  final _formKey = new GlobalKey<FormState>();
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return WillPopScope(
      onWillPop: () {
        return Twl.navigateTo(
            context,
            BottomNavigation(
              tabIndexId: 1,
            ));
      },
      child: Scaffold(
        backgroundColor: tBackground,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 7,
          title: Text(
            'ride_details'.tr,
            style: TextStyle(
              color: tDarkNavyblue,
              fontSize: isTab(context) ? 10.sp : 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: tYellow,
          leading: GestureDetector(
              onTap: () {
                Twl.navigateBack(context);
                // Twl.forceNavigateTo(
                //     context,
                //     BottomNavigation(
                //       tabIndexId: 1,
                //     ));
              },
              child: Padding(
                padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                child: BackIconWidget(),
              )),
          //   actions: [
          //     GestureDetector(
          //       onTap: widget.rideDetails['status'] == STATUS_RIDE_COMPLETED
          //           ? () async {
          //               var headers = await ApiHelper().getHeader(context);
          //               print(
          //                 apiBaseUrl +
          //                     DOWNLOAD_INNVOICE +
          //                     headers['auth_code'] +
          //                     '&ride_id=' +
          //                     widget.rideDetails['id'].toString(),
          //               );
          //               launch(
          //                 apiBaseUrl +
          //                     DOWNLOAD_INNVOICE +
          //                     headers['auth_code'] +
          //                     '&ride_id=' +
          //                     widget.rideDetails['id'].toString(),
          //               );
          //             }
          //           : () async {
          //               Twl.createAlert(context, 'Oops',
          //                   'Invoice available after ride completed');
          //             },
          //       child: Container(
          //         margin: EdgeInsets.all(10),
          //         padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(6),
          //             color: tWhite,
          //             boxShadow: [tBoxShadow]),
          //         child: Row(
          //           children: [
          //             Image.asset(
          //               Images.INVOICE,
          //               scale: isTab(context) ? 1 : 2,
          //             ),
          //             SizedBox(
          //               width: 2.w,
          //             ),
          //             Text(
          //               'invoice'.tr,
          //               style: TextStyle(
          //                   color: tPrimaryColor,
          //                   fontSize: isTab(context) ? 11.sp : 12.sp,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
        ),
        body: widget.rideDetails == null
            ? Center(
                child: Container(
                  child: SpinKitThreeBounce(
                    color: tPrimaryColor,
                    size: 20.0,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      RideCardWidget(
                        rideDetails: widget.rideDetails,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      if (widget.rideDetails['status'] == STATUS_RIDE_COMPLETED) DistanceAndDurationCardWidget(rideDetails: widget.rideDetails),
                      SizedBox(
                        height: 2.h,
                      ),

                      // Container(
                      //     decoration: BoxDecoration(
                      //         color: tWhite,
                      //         boxShadow: [tBoxShadow],
                      //         borderRadius: BorderRadius.circular(8)),
                      //     child: LocationCards()),
                      Container(
                        //  margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(color: tWhite, borderRadius: BorderRadius.circular(8), boxShadow: [tBoxShadow]),
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: (widget.rideDetails['rider_type'] == RIDER_TYPE_ONEWAY)
                                ? Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(isTab(context) ? 12 : 8),
                                              decoration: BoxDecoration(color: tBackground, shape: BoxShape.circle),
                                              child: Image.asset(
                                                Images.GREENLOCATIONICON,
                                                scale: isTab(context) ? 2 : 3.5,
                                              )),
                                          // if (tripOptionsProvider.riderType ==
                                          //     RIDER_TYPE_ONEWAY)
                                          DottedLine(
                                            direction: Axis.vertical,
                                            lineLength: 30,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor: tDotted,
                                            dashGapLength: 4.0,
                                            dashGapRadius: 0.0,
                                          ),
                                          // if (tripOptionsProvider.riderType ==
                                          //     RIDER_TYPE_ONEWAY)
                                          Image.asset(
                                            Images.REDLOCATIONICON,
                                            scale: isTab(context) ? 2 : 3.5,
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
                                              child: Container(
                                                child: Text(
                                                  widget.rideDetails.isNotEmpty
                                                      ? widget.rideDetails['pickup_address'].toString()
                                                      : 'Select Pickup Location',
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

                                            // if (tripOptionsProvider.riderType ==
                                            //     RIDER_TYPE_ONEWAY)
                                            Divider(
                                              height: 4.h,
                                              thickness: 0.9,
                                              color: tDividerColor,
                                            ),

                                            GestureDetector(
                                              child: Container(
                                                child: Text(
                                                  widget.rideDetails.isNotEmpty ? widget.rideDetails['drop_address'] : 'Select Drop Location',
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
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      Container(
                                          child: Image.asset(
                                        Images.GREENLOCATIONICON,
                                        scale: isTab(context) ? 2 : 3.5,
                                      )),
                                      SizedBox(width: 3.w),
                                      Container(
                                        width: 70.w,
                                        child: Text(
                                          widget.rideDetails.isNotEmpty ? widget.rideDetails['pickup_address'].toString() : 'Select Pickup Location',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.mulish(
                                            color: tSecondaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isTab(context) ? 9.sp : 11.sp,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]))),
                      ),

                      SizedBox(
                        height: 1.5.h,
                      ),
                      // rideDetails['driver_rating'] == null
                      //     ? giveRatingCard(rideDetails: rideDetails)
                      //     : rideDetails['driver']['rating'] == ""
                      //         ? Container()
                      //         :
                      if (widget.rideDetails['status'] == STATUS_RIDE_COMPLETED) AmountCardWidget(rideDetails: widget.rideDetails),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      widget.rideDetails['status'] == STATUS_RIDE_COMPLETED &&
                              (widget.rideDetails['user_my_ratings'] == null || widget.rideDetails['user_my_ratings'] == '')
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Row(
                                            children: [
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tDarkNavyblue, width: 2)),
                                                        child: CircleAvatar(
                                                          backgroundColor: tWhite,
                                                          backgroundImage: widget.rideDetails['driver_image'] == ""
                                                              ? NetworkImage(Images.UNKNOWN_IMAGE)
                                                              : NetworkImage(widget.rideDetails['driver_image']),
                                                          radius: isTab(context) ? 20 : 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints(maxWidth: 58.w),
                                                        child: Text(
                                                        widget.rideDetails['driver_name'].toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: tDarkNavyblue,
                                                            fontSize: isTab(context) ? 10.sp : 14.sp,
                                                            fontWeight: FontWeight.w600),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: isTab(context) ? 1.h : 0.8.h,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'give_rating'.tr,
                                    // rideDetails['driver']
                                    //         ['name']
                                    //     .toString(),
                                    style: TextStyle(color: tDarkNavyblue, fontSize: isTab(context) ? 7.sp : 11.sp, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
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
                                      setState(() {
                                        selectedRating = rating;
                                        //rating = selectedRating;
                                      });
                                    },
                                  )),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      //        focusNode: _focusNode,
                                      // textInputAction: TextInputAction.done,

                                      style: TextStyle(color: tDarkNavyblue, fontSize: isTab(context) ? 9.sp : 12.sp, fontWeight: FontWeight.w600),
                                      controller: _rateTextController,
                                      maxLines: isTab(context) ? 3 : 2,
                                      decoration: InputDecoration(
                                          fillColor: tWhite,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12), borderSide: BorderSide(width: 1.5, color: tBackground)),
                                          hintText: 'write_a_review_to'.tr,
                                          hintStyle: TextStyle(
                                              fontFamily: "Barlow",
                                              color: tGray,
                                              fontSize: isTab(context) ? 7.sp : 10.sp,
                                              fontWeight: FontWeight.w400),
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: tBackground, width: 1.5))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
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
                                            'submit'.tr,
                                            style: TextStyle(
                                                letterSpacing: 1,
                                                color: tWhite,
                                                fontWeight: FontWeight.w700,
                                                fontSize: isTab(context) ? 10.sp : 14.sp),
                                          ),
                                          onTap: (startLoading, stopLoading, btnState) async {
                                            // Twl.forceNavigateTo(context, RatingCard());

                                            if (_formKey.currentState!.validate()) {
                                              startLoading();
                                              // Twl.navigateTo(context, RatingCard(rideData: widget.rideData));
                                              Map<String, String> param = {
                                                'booking_id': widget.rideDetails['id'].toString(),
                                                'rating': selectedRating.toString(),
                                                'review': _rateTextController.text,
                                              };

                                              var res = await UserAPI().myAddReview(context, param);
                                              if (res != null && res['status'] == 'OK') {
                                                Text('Successfully updated');
                                                Twl.forceNavigateTo(
                                                    context,
                                                    BottomNavigation(
                                                      tabIndexId: 0,
                                                    ));
                                                // Twl.navigateTo(context,
                                                //     RatingCard(rideData: widget.rideData));
                                              } else {
                                                Twl.createAlert(context, 'Oops', res['error'].toString());
                                              }
                                              stopLoading();
                                            }
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : widget.rideDetails['status'] == STATUS_RIDE_COMPLETED && widget.rideDetails['user_my_ratings'] != null ||
                                  widget.rideDetails['user_my_ratings']!= ''
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tDarkNavyblue, width: 2)),
                                        child: CircleAvatar(
                                          backgroundColor: tWhite,
                                          backgroundImage: widget.rideDetails['driver_image'] == ""
                                              ? NetworkImage(Images.UNKNOWN_IMAGE)
                                              : NetworkImage(widget.rideDetails['driver_image']),
                                          radius: isTab(context) ? 20 : 30,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: 58.w),
                                            child: Text(
                                            widget.rideDetails['driver_name'].toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: tDarkNavyblue, fontSize: isTab(context) ? 10.sp : 14.sp, fontWeight: FontWeight.w600),
                                          )),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: Colors.orange,
                                              ),
                                              Text(
                                                widget.rideDetails['user_my_ratings']['rating'].toString(),
                                                style: TextStyle(
                                                    color: tPrimaryColor, fontSize: isTab(context) ? 10.sp : 14.sp, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              :

                              // : Container(),

                              SizedBox(
                                  height: 1.5.h,
                                ),
                      widget.rideDetails['status'] == STATUS_RIDE_COMPLETED
                          ? GestureDetector(
                              onTap: () async {
                                await launchURL(CHAT_LINK);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: tWhite,
                                        boxShadow: [tBoxShadow],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tDarkOrangeColor, width: 1)),
                                            child: Text(
                                              '?',
                                              style: TextStyle(
                                                  color: tDarkOrangeColor, fontSize: isTab(context) ? 11.sp : 14.sp, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            'need_help'.tr,
                                            style: TextStyle(
                                                color: tDarkOrangeColor, fontSize: isTab(context) ? 11.sp : 14.sp, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _RideDetailsViewState - the data and logic behind its screen

// >>> START: giveRatingCard - screen/widget
class giveRatingCard extends StatelessWidget {
  const giveRatingCard({
    Key? key,
    this.rideDetails,
  }) : super(key: key);
  final rideDetails;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Row(
                      children: [
                        //     radius: 25,
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          rideDetails['driver']['name'].toString(),
                          style: TextStyle(color: tBlack, fontSize: isTab(context) ? 10.sp : 12.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Give_Rating'.tr,
                style: GoogleFonts.mulish(color: tBlack, fontWeight: FontWeight.w700, fontSize: isTab(context) ? 8.sp : 12.sp),
              ),
              SizedBox(
                width: 1.w,
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Center(
              child: RatingBar.builder(
            initialRating: 1,
            minRating: 0,
            unratedColor: tlightGray,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: isTab(context) ? 50 : 45,
            itemPadding: EdgeInsets.symmetric(horizontal: 0.4.h),
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: Colors.orange,
            ),
            onRatingUpdate: (rating) {
              createAlert(context, 'Submit_your_rating'.tr, '', rideDetails['id'].toString(), rideDetails['driver']['driver_id'], rating);
            },
          )),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: createAlert - shows a simple message pop-up
  static createAlert(BuildContext context, error, errormsg, rideId, skipperId, rating) async {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: AlertDialog(
              actions: [
                GestureDetector(
                  //         context,
                  //         RideDetailsView(
                  //           rideId: rideId,
                  //         ));
                  // },
                  child: Container(
                    width: 18.w,
                    height: 4.h,
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                        // gradient: tPrimaryGradientColor,
                        border: Border.all(width: 1, color: tSecondaryColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Yes'.tr,
                      style: TextStyle(color: tlightGray, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 10.sp : 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    // Twl.navigateBack(context);
                  },
                  child: Container(
                    width: 18.w,
                    height: 4.h,
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                        // gradient: tPrimaryGradientColor,
                        border: Border.all(width: 1, color: tRed),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'No'.tr,
                      style: TextStyle(color: tRed, fontWeight: FontWeight.w600, fontSize: isTab(context) ? 10.sp : 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              title: Text(error),
              content: Text(errormsg),
            ),
          );
        });
  }
  // <<< END: createAlert - shows a simple message pop-up
}
// <<< END: giveRatingCard - screen/widget

// >>> START: RideDetailsLocationCard - screen/widget
class RideDetailsLocationCard extends StatelessWidget {
  const RideDetailsLocationCard({
    Key? key,
    this.rideDetails,
  }) : super(key: key);
  final rideDetails;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: tWhite, boxShadow: [tBoxShadow], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(isTab(context) ? 15 : 8),
                        decoration: BoxDecoration(
                            // color: tbackground,
                            shape: BoxShape.circle),
                        child: Image.asset(
                          Images.GREENLOCATIONICON,
                          scale: isTab(context) ? 2 : 4,
                          // color: tGray,
                        )),
                    Column(
                      children: [
                        Container(
                          height: 0.6.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: tdividerGray, shape: BoxShape.rectangle),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                          height: 0.6.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: tdividerGray, shape: BoxShape.rectangle),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                          height: 0.6.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: tdividerGray, shape: BoxShape.rectangle),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                          height: 0.6.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: tdividerGray, shape: BoxShape.rectangle),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                          height: 0.6.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: tdividerGray, shape: BoxShape.rectangle),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                          height: 0.6.h,
                          width: 0.5.w,
                          decoration: BoxDecoration(color: tdividerGray, shape: BoxShape.rectangle),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(isTab(context) ? 15 : 8),
                        decoration: BoxDecoration(
                            // color: tlocationbgtwo,
                            shape: BoxShape.circle),
                        child: Image.asset(
                          Images.REDLOCATIONICON,
                          scale: isTab(context) ? 2 : 4,
                          color: tRed,
                        )),
                  ],
                ),
                SizedBox(
                  width: isTab(context) ? 2.w : 3.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Spline Arcade, Aayyappa Society, Madhapur, Telangana (500081)',
                          // rideDetails['pickup_address'].toString(),
                          style: GoogleFonts.mulish(
                            color: tDarkNavyblue,
                            fontSize: isTab(context) ? 9.sp : 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Divider(
                        color: tlightGray,
                        thickness: 1,
                      ),
                      Container(
                          child: Text(
                        'Secunderabad Railway Station, Secunderabad, Telangana (500081)',
                        // rideDetails['drop_address'].toString(),
                        style: GoogleFonts.mulish(
                          color: tDarkNavyblue,
                          fontSize: isTab(context) ? 9.sp : 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: RideDetailsLocationCard - screen/widget
