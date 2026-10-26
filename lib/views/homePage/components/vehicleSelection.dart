// =============================================================================
// WHAT : Card to choose the car type (SUV+, SUV, Sedan, Hatchback).
// NOTES: Choice is kept in TripOptionsProvider.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/constants.dart';
import '../../../../responsive.dart';
import '../../../constants/imageConstant.dart';

// >>> START: VehicleSelectionCard - screen/widget shell (the visible part is in its State class)
class VehicleSelectionCard extends StatefulWidget {
  const VehicleSelectionCard({
    Key? key,
    this.getVechileDetails,
  }) : super(key: key);
  final getVechileDetails;

  @override
  State<VehicleSelectionCard> createState() => _VehicleSelectionCardState();
}
// <<< END: VehicleSelectionCard - screen/widget shell (the visible part is in its State class)

// >>> START: _VehicleSelectionCardState - the data and logic behind its screen
class _VehicleSelectionCardState extends State<VehicleSelectionCard> {
  List<String> vehicle = ["Auto", "Bike"];
  List<String> amount = ["₹100", "₹30"];
  List<String> person = ["3+1 Person", "1 Person"];

  var rides;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      height: isTab(context) ? 25.h : 28.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Rides',
            style: GoogleFonts.mulish(
              color: tBlack,
              fontWeight: FontWeight.w700,
              fontSize: isTab(context) ? 13.sp : 16.sp,
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              // itemCount: widget.getVechileDetails.length,
              itemCount: 2,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      rides = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [tBoxShadow],
                          color: rides == index ? tPrimaryColor : tWhite,
                          borderRadius: BorderRadius.all(
                              Radius.circular(isTab(context) ? 20 : 14))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 1.h),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: rides == index
                                          ? tPrimaryColor
                                          : tBackground,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(
                                          color: rides == index
                                              ? tBlack
                                              : tPrimaryColor,
                                          width: 1)),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      index == 0
                                          ? Images.Logo
                                          : index == 1
                                              ? Images.Logo
                                              : '',
                                      scale: isTab(context) ? 2 : 2.5,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vehicle[index],
                                    style: TextStyle(
                                        color: tBlack,
                                        fontSize:
                                            isTab(context) ? 11.sp : 14.sp,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      person[index],
                                      style: GoogleFonts.mulish(
                                        color: rides == index ? tBlack : tGray,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTab(context) ? 8.sp : 11.sp,
                                      ),
                                      // style: TextStyle(
                                      //     color:
                                      //
                                      //     fontSize:
                                      //
                                      //     fontWeight: FontWeight.w500)
                                    ),
                                    index == 0
                                        ? SizedBox(
                                            width: isTab(context) ? 11.w : 10.w,
                                          )
                                        : index == 1
                                            ? SizedBox(
                                                width: 14.w,
                                              )
                                            : Container(),
                                    Image.asset(Images.Logo,
                                        scale: isTab(context) ? 3.5 : 7,
                                        color: rides == index ? tBlack : tGray),
                                    SizedBox(
                                      width: 0.8.w,
                                    ),
                                    Text(
                                      '6 mins',
                                      style: GoogleFonts.mulish(
                                        color: rides == index ? tBlack : tGray,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTab(context) ? 8.sp : 11.sp,
                                      ),
                                      // style: TextStyle(
                                      //     color:
                                      //         rides == index ? tBlack : tGray,
                                      //     fontSize:
                                      //         isTab(context) ? 8.sp : 11.sp,
                                      //     fontWeight: FontWeight.w500)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  index == 0
                                      ? Text(
                                          '₹120',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: rides == index
                                                  ? tBlack
                                                  : tGray,
                                              fontSize:
                                                  isTab(context) ? 6.sp : 9.sp,
                                              fontWeight: FontWeight.w400),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Text(
                                    amount[index],
                                    style: TextStyle(
                                        color: tBlack,
                                        fontSize:
                                            isTab(context) ? 10.sp : 13.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _VehicleSelectionCardState - the data and logic behind its screen
