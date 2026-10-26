// =============================================================================
// WHAT : Card that shows a saved address with its title (Home, Work...).
// NOTES: Used in the favourites and address lists.
// =============================================================================
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

import '../constants/constants.dart';
import '../constants/imageConstant.dart';
import '../responsive.dart';

// >>> START: AddressLocationCard - screen/widget shell (the visible part is in its State class)
class AddressLocationCard extends StatefulWidget {
  const AddressLocationCard({
    Key? key,
    this.locationData,
  }) : super(key: key);
  final locationData;
  @override
  State<AddressLocationCard> createState() => _AddressLocationCardState();
}
// <<< END: AddressLocationCard - screen/widget shell (the visible part is in its State class)

// >>> START: _AddressLocationCardState - the data and logic behind its screen
class _AddressLocationCardState extends State<AddressLocationCard> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                  padding: EdgeInsets.all(isTab(context) ? 12 : 8),
                  decoration:
                      BoxDecoration(color: tBackground, shape: BoxShape.circle),
                  child: Image.asset(
                    Images.GREENLOCATIONICON,
                    scale: isTab(context) ? 2 : 3.5,
                  )),
              if (widget.locationData['rider_type'] == RIDER_TYPE_ONEWAY)
                DottedLine(
                  direction: Axis.vertical,
                  lineLength: 30,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: tDotted,
                  dashGapLength: 4.0,
                  dashGapRadius: 0.0,
                ),
              if (widget.locationData['rider_type'] == RIDER_TYPE_ONEWAY)
                Container(
                    padding: EdgeInsets.all(isTab(context) ? 12 : 8),
                    decoration: BoxDecoration(
                        color: tBackground, shape: BoxShape.circle),
                    child: Image.asset(
                      Images.REDLOCATIONICON,
                      scale: isTab(context) ? 2 : 3.5,
                    )),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.locationData['pickup_address'].toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.mulish(
                    color: tDarkNavyblue,
                    fontWeight: FontWeight.w600,
                    fontSize: isTab(context) ? 9.sp : 11.sp,
                  ),
                ),
                if (widget.locationData['rider_type'] == RIDER_TYPE_ONEWAY)
                  Divider(
                    height: 4.h,
                    thickness: 0.9,
                    color: tDividerColor,
                  ),
                if (widget.locationData['rider_type'] == RIDER_TYPE_ONEWAY)
                  Text(
                    widget.locationData['drop_address'].toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontWeight: FontWeight.w600,
                      fontSize: isTab(context) ? 9.sp : 11.sp,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _AddressLocationCardState - the data and logic behind its screen
