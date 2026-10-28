// =============================================================================
// WHAT : Saved favourite addresses list.
// NOTES: Server: favourite-location APIs.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/imageConstant.dart';
import '../../../../globalFuctions/globalFunctions.dart';
import '../../../../globalWidgets/buttonIconWidget.dart';
import '../../../../globalWidgets/buttonWidget.dart';
import '../../../../responsive.dart';
import '../../../bottomNavigation.dart/bottomNavigation.dart';
import 'editgooglemapfavorites.dart';
import 'favAddressGoogleMap.dart';

// >>> START: FavouriteLocation - screen/widget shell (the visible part is in its State class)
class FavouriteLocation extends StatefulWidget {
  const FavouriteLocation({Key? key}) : super(key: key);

  @override
  State<FavouriteLocation> createState() => _FavouriteLocationState();
}
// <<< END: FavouriteLocation - screen/widget shell (the visible part is in its State class)

// >>> START: _FavouriteLocationState - the data and logic behind its screen
class _FavouriteLocationState extends State<FavouriteLocation> {
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // fetchFavLocation();
    super.initState();
    fetchFavLocation();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  var favLocationDetails;
  var resNOK;
  // >>> START: fetchFavLocation - fetches fav location
  fetchFavLocation() async {
    var response = await UserAPI().favoriteList(
      context,
    );
    if (response != null && response['status'] == 'OK') {
      setState(() {
        favLocationDetails = response['details'];
      });
    } else {
      setState(() {
        resNOK = response['status'];
      });
    }
  }
  // <<< END: fetchFavLocation - fetches fav location

  List<String> name = ['Home', 'Office', 'Other'];
  List<String> images = [
    Images.HOUSEICON,
    Images.BUILDINGLOCATION,
    Images.LIKEMORE
  ];
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
            context,
            BottomNavigation(
              tabIndexId: 2,
            ));
      },
      child: Scaffold(
          backgroundColor: tWhite,
          appBar: AppBar(
            elevation: 1,
            titleSpacing: 7,
            backgroundColor: tappbarclr,
            leading: GestureDetector(
                onTap: () {
                  Twl.forceNavigateTo(
                      context,
                      BottomNavigation(
                        tabIndexId: 2,
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                  child: BackIconWidget(),
                )),
            title: Text(
              'Favorites_Location'.tr,
              style: TextStyle(
                  color: tSecondaryColor,
                  fontFamily: "mulish",
                  fontSize: isTab(context) ? 10.sp : 17.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 1.5.h,
                ),
                favLocationDetails == null
                    ? resNOK == 'NOK'
                        ? Align(
                            alignment: Alignment.center,
                            child: Text('No favorite location found',
                                style: GoogleFonts.mulish(
                                    color: tDarkNavyblue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: isTab(context) ? 9.sp : 12.sp)),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: tPrimaryColor,
                            ),
                          )
                    : ListView.builder(
                        itemCount: favLocationDetails.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var favLocationData = favLocationDetails[index];
                          return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 0.6.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.5.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: tWhite,
                                  boxShadow: [tBackbtnBoxShadow]),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: tReferColor),
                                        child: Padding(
                                            padding: EdgeInsets.all(
                                                isTab(context) ? 10 : 8.0),
                                            child: Image.asset(
                                              favLocationData['address_type'] ==
                                                      'Home'
                                                  ? Images.HOUSEICON
                                                  : favLocationData[
                                                              'address_type'] ==
                                                          'Office'
                                                      ? Images.BUILDINGLOCATION
                                                      : Images.LIKEMORE,
                                              scale: isTab(context) ? 4 : 5,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    favLocationData[
                                                        'address_type'],
                                                    // name[index],
                                                    style: GoogleFonts.mulish(
                                                        color: tSecondaryColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: isTab(context)
                                                            ? 10.sp
                                                            : 13.sp),
                                                  ),
                                                  Spacer(),
                                                  PopupMenuButton<int>(

                                                      // },
                                                      icon: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.more_vert,
                                                            color:
                                                                tPrimaryColor,
                                                            // size: isTab(context) ? 20 : 30,
                                                          )
                                                          //  Icon(
                                                          //            isChargesSelected
                                                          //                 ? Icons.keyboard_arrow_down
                                                          //                 : Icons.keyboard_arrow_up,
                                                          //             size: 35,
                                                          //             color: tGreencolor,
                                                          //           ),
                                                        ],
                                                      ),
                                                      tooltip: "  ",
                                                      // icon: Image.asset(Images.),

                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4.0),
                                                        ),
                                                      ),
                                                      offset: Offset(
                                                        -40,
                                                        -0,
                                                      ),
                                                      color: tWhite,
                                                      itemBuilder:
                                                          (context) => [
                                                                PopupMenuItem(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,

                                                                  // height: 0.6.h,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Twl.forceNavigateTo(
                                                                          context,
                                                                          editfavAddressGoogleMapPage(
                                                                            editfavoriteData:
                                                                                favLocationData,
                                                                          ));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          5.h,
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            'edit'
                                                                                .tr,
                                                                            style: GoogleFonts.mulish(
                                                                                color: tPrimaryColor,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: isTab(context) ? 9.sp : 12.sp)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  value: 1,
                                                                ),
                                                                PopupMenuDivider(

                                                                    // height: 20,
                                                                    ),
                                                                PopupMenuItem(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  // height: 0.6.h,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      // close the Edit / Delete menu first, so it is not left on screen behind the confirmation
                                                                      Navigator.of(context).pop();
                                                                      showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Container(
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              child: Stack(
                                                                                clipBehavior: Clip.none,
                                                                                children: [
                                                                                  Container(
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: 5.h,
                                                                                          ),
                                                                                          Center(
                                                                                            child: Text(
                                                                                              'Delete_Address'.tr,
                                                                                              style: TextStyle(color: tSecondaryColor, fontSize: isTab(context) ? 11.sp : 14.sp, fontWeight: FontWeight.w600),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 3.5.h,
                                                                                          ),
                                                                                          Center(
                                                                                            child: Text(
                                                                                              'Are_you_sure_you_want_to_delete_this_address'.tr,
                                                                                              style: TextStyle(color: tDarkOrangeColor, fontSize: isTab(context) ? 9.sp : 12.sp, fontWeight: FontWeight.w600),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 2.5.h,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  // Twl.forceNavigateTo(context, LoginScreen());
                                                                                                },
                                                                                                child: Container(
                                                                                                    width: isTab(context) ? 50.w : 40.w,
                                                                                                    height: isTab(context) ? 6.h : 7.h,
                                                                                                    // padding: EdgeInsets.symmetric(vertical: isTab(context) ? 12 : 10, horizontal: isTab(context) ? 18.5.w : 16.5.w),
                                                                                                    decoration: BoxDecoration(color: tWhite, border: Border.all(color: tCancelRidebtn, width: 2), borderRadius: BorderRadius.circular(12)),
                                                                                                    child: Center(
                                                                                                      child: Text(
                                                                                                        'Cancel'.tr,
                                                                                                        style: TextStyle(color: tCancelRidebtn, fontSize: isTab(context) ? 10.sp : 13.sp, fontWeight: FontWeight.w700),
                                                                                                      ),
                                                                                                    )),
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  var res = await UserAPI().deleteFavLocations(context, favLocationData['id'].toString());
                                                                                                  if (res != null && res['status'] == 'OK') {
                                                                                                    Twl.forceNavigateTo(context, FavouriteLocation());
                                                                                                  } else {
                                                                                                    Twl.createAlert(context, 'Oops', res['error'].toString());
                                                                                                  }
                                                                                                },
                                                                                                child: Container(
                                                                                                    width: isTab(context) ? 50.w : 40.w,
                                                                                                    height: isTab(context) ? 6.h : 7.h,
                                                                                                    // padding: EdgeInsets.symmetric(vertical: isTab(context) ? 12.5 : 10, horizontal: isTab(context) ? 18.5.w : 16.5.w),
                                                                                                    decoration: BoxDecoration(color: tPrimaryColor, border: Border.all(color: tPrimaryColor, width: 1.5), borderRadius: BorderRadius.circular(12)),
                                                                                                    child: Center(
                                                                                                      child: Text(
                                                                                                        'Delete'.tr,
                                                                                                        style: TextStyle(color: tWhite, fontSize: isTab(context) ? 10.sp : 13.sp, fontWeight: FontWeight.w600),
                                                                                                      ),
                                                                                                    )),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 4.h,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    top: -20,
                                                                                    left: isTab(context) ? 47.w : 45.w,
                                                                                    child: Container(
                                                                                      height: 6.h,
                                                                                      width: 6.h,
                                                                                      decoration: BoxDecoration(
                                                                                          ),
                                                                                      child: Container(
                                                                                        height: 6.h,
                                                                                        width: 6.h,
                                                                                        decoration: BoxDecoration(
                                                                                            //     color: tPrimaryColor,
                                                                                            //     borderRadius:
                                                                                            //         BorderRadius.circular(30)
                                                                                            ),
                                                                                        child: Image.asset(
                                                                                          Images.DELETE,
                                                                                          scale: isTab(context) ? 2 : 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      height:
                                                                          5.h,
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            'Delete'
                                                                                .tr,
                                                                            style: GoogleFonts.mulish(
                                                                                color: tPrimaryColor,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: isTab(context) ? 9.sp : 12.sp)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  value: 1,
                                                                ),
                                                              ]),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              favLocationData['address'],
                                              // '102 Spline Arcade, Aayyappa Soci..',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.mulish(
                                                  color: tDarkOrangeColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: isTab(context)
                                                      ? 8.sp
                                                      : 10.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: isTab(context) ? 28.w : 50.w,
                  height: isTab(context) ? 6.h : 7.h,
                  child: ButtonWidget(
                    borderSide: BorderSide(color: tPrimaryColor),
                    color: tPrimaryColor,
                    borderRadius: isTab(context) ? 40.0 : 30.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: tWhite, width: 2),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.add,
                            size: isTab(context) ? 35 : 23,
                            color: tWhite,
                          ),
                        ),
                        SizedBox(
                          width: isTab(context) ? 1.w : 2.w,
                        ),
                        Text('Add_New'.tr,
                            style: GoogleFonts.mulish(
                                color: tWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: isTab(context) ? 9.sp : 14.sp)),
                      ],
                    ),
                    onTap: (startLoading, stopLoading, btnState) {
                      startLoading();
                      setState(() {
                        // Twl.navigateTo(context, SaveFavLocation());
                        Twl.navigateTo(context, favAddressGoogleMapPage());
                      });
                      stopLoading();
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: _showDialog - shows dialog
  void _showDialog(BuildContext context, favLocationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          iconColor: tBlack,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: [
            // DeleteAddressPopUp(
            //   favLocationId: favLocationId,
            // )
          ],
        );
      },
    );
  }
  // <<< END: _showDialog - shows dialog
}
// <<< END: _FavouriteLocationState - the data and logic behind its screen
