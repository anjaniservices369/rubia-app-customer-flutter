// =============================================================================
// WHAT : TAXI: rate the driver after the ride.
// NOTES: Sends the rating to the server.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/buttonIconWidget.dart';
import 'package:base_project_flutter/globalWidgets/buttonWidget.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/taxiservices/rideDetails.dart';
import 'package:base_project_flutter/views/homePage/components/Rategratingcard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

// >>> START: AddRating - screen/widget shell (the visible part is in its State class)
class AddRating extends StatefulWidget {
  const AddRating({
    Key? key,
    this.lat,
    this.lng,
    this.rideData,
  }) : super(key: key);
  final lat;
  final lng;
  final rideData;

  @override
  State<AddRating> createState() => _AddRatingState();
}
// <<< END: AddRating - screen/widget shell (the visible part is in its State class)

// >>> START: _AddRatingState - the data and logic behind its screen
class _AddRatingState extends State<AddRating> {
  GoogleMapController? mapController;
  var selectedRating;
  final TextEditingController _descriptionController = TextEditingController();

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            // markers: markers,
            padding: EdgeInsets.only(
              top: 40.0,
            ),
            onTap: (tapped) {
              // markers;
            },
            initialCameraPosition: CameraPosition(
              //initial position in map
              target: LatLng(
                  double.parse(widget.rideData['drop_latitude']),
                  double.parse(
                      widget.rideData['drop_longitude'])), //initial position
              zoom: 17.0, //initial zoom level
            ),
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: null,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: tWhite,
                      boxShadow: [tBoxShadow],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10.w,
                                  child: GestureDetector(
                                      onTap: () async {
                                        Twl.willpopAlert(context);
                                      },
                                      child: BackIconWidget()),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Rate Your Experience To',
                                            style: TextStyle(
                                                color: tBlack,
                                                fontWeight: FontWeight.w600,
                                                fontSize: isTab(context)
                                                    ? 10.sp
                                                    : 14.sp),
                                          ),
                                          Text(
                                            'Skipper',
                                            style: TextStyle(
                                                color: tBlack,
                                                fontWeight: FontWeight.w600,
                                                fontSize: isTab(context)
                                                    ? 10.sp
                                                    : 14.sp),
                                          ),
                                        ],
                                      ),

                                      // Riderdetails(
                                      //   rideData: widget.rideData,
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: tPrimaryColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    buildDriverProfileImage(
                                                        widget.rideData),
                                                    SizedBox(width: 2.w),
                                                    buildDriverInfo(context,
                                                        widget.rideData),
                                                    Spacer(),
                                                    buildContactButton(
                                                      context,
                                                      iconPath:
                                                          Images.CALL_ICON,
                                                      onTap: () => callDriver(
                                                          widget.rideData),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 1.h),
                                                buildDriverVehicleInfo(
                                                    context, widget.rideData),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: 2.8.h,
                                      ),
                                      Text(
                                        'Are you satisfied with our service',
                                        style: GoogleFonts.mulish(
                                            color: tBlack,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                isTab(context) ? 10.sp : 14.sp),
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
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.4.h),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star_rounded,
                                          color: Colors.orange,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            selectedRating = rating;
                                          });
                                        },
                                      )),
                                      SizedBox(
                                        height: 2.7.h,
                                      ),
                                      // AddReveiwtextformfield(),
                                      Container(
                                          child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Add Reveiw',
                                                style: TextStyle(
                                                    color: tBlack,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: isTab(context)
                                                        ? 9.sp
                                                        : 12.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          TextFormField(
                                            controller: _descriptionController,
                                            maxLines: isTab(context) ? 3 : 2,
                                            decoration: InputDecoration(
                                                fillColor: tWhite,
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: BorderSide(
                                                        width: 1.5,
                                                        color: tBlack)),
                                                hintText:
                                                    'Write a review to rider',
                                                hintStyle: TextStyle(
                                                    fontFamily: "Barlow",
                                                    color: tGray,
                                                    fontSize: isTab(context)
                                                        ? 7.sp
                                                        : 10.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide: BorderSide(
                                                            color: tWhite,
                                                            width: 1.5))),
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        height: 2.2.h,
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: isTab(context) ? 60.w : 80.w,
                                          height: isTab(context) ? 6.h : 7.h,
                                          child: ButtonWidget(
                                              borderSide: BorderSide(
                                                color: tPrimaryColor,
                                              ),
                                              // borderRadius: BorderRadius.circular(15),
                                              borderRadius:
                                                  isTab(context) ? 40.0 : 30.0,
                                              color: tPrimaryColor,
                                              textcolor: tWhite,
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                    letterSpacing: 1,
                                                    color: tWhite,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: isTab(context)
                                                        ? 10.sp
                                                        : 14.sp),
                                              ),
                                              onTap: (startLoading, stopLoading,
                                                  btnState) async {
                                                // if (_formKey.currentState!
                                                //     .validate()) {
                                                startLoading();
                                                // Twl.navigateTo(context, RatingCard(rideData: widget.rideData));
                                                Map<String, String> param = {
                                                  'ride_id': widget
                                                      .rideData['ride_id']
                                                      .toString(),
                                                  // 'skipper_id':  widget.rideData['skipperId'].toString(),
                                                  'skipper_id': widget
                                                      .rideData['driver']['id']
                                                      .toString(),
                                                  'rating':
                                                      selectedRating.toString(),
                                                  'user_discription':
                                                      _descriptionController
                                                          .text
                                                };
                                                var res = await UserAPI()
                                                    .addSkipperRating(
                                                        context, param);
                                                if (res != null &&
                                                    res['status'] == 'OK') {
                                                  Twl.navigateTo(
                                                      context,
                                                      RatingCard(
                                                          rideData:
                                                              widget.rideData));
                                                } else {
                                                  Twl.createAlert(
                                                      context,
                                                      'Oops',
                                                      res['error'].toString());
                                                }
                                                stopLoading();
                                                // }
                                              }),
                                        ),
                                      ),
                                      SizedBox(
                                        height: isTab(context)
                                            ? tDefaultPadding
                                            : 1.h,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ))),
              //accepted ride  page
            ],
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _AddRatingState - the data and logic behind its screen
