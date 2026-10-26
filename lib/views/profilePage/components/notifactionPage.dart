// =============================================================================
// WHAT : Notification list with clear-all.
// NOTES: Server: list-fcm-notifications, clear-notifications.
// =============================================================================
// import 'dart:developer';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../responsive.dart';
import '../../../../globalFuctions/globalFunctions.dart';

import '../../../globalWidgets/buttonIconWidget.dart';
import '../../../providers/notifactionProvider.dart';

// >>> START: Notifactionpage - screen/widget shell (the visible part is in its State class)
class Notifactionpage extends StatefulWidget {
  const Notifactionpage({Key? key, this.boolnotificationPage})
      : super(key: key);
  final bool? boolnotificationPage;

  @override
  State<Notifactionpage> createState() => _NotifactionpageState();
}
// <<< END: Notifactionpage - screen/widget shell (the visible part is in its State class)

// >>> START: _NotifactionpageState - the data and logic behind its screen
class _NotifactionpageState extends State<Notifactionpage> {
  late double scrollPosition;
  ScrollController scrollController = new ScrollController();

  MyNotifactionProvider myNotificationProvider = MyNotifactionProvider();

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    myNotificationProvider =
        Provider.of<MyNotifactionProvider>(context, listen: false);
    myNotificationProvider.myFavoritesList.clear();
    myNotificationProvider.currentPage = 0;
    myNotificationProvider.totalPages = 0;
    myNotificationProvider.getFavorites(
      context: context,
      page: '${myNotificationProvider.currentPage}',
    );
    scrollController.addListener(_scrollListener);
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: _scrollListener - scroll listener
  _scrollListener() {
    if (scrollController.position.extentAfter == 0) {
      if (myNotificationProvider.currentPage <
              myNotificationProvider.totalPages &&
          myNotificationProvider.myFavoritesGetting == false) {
        myNotificationProvider.getFavorites(
          context: context,
          page: '${myNotificationProvider.currentPage}',
        );
      }
    }
  }
  // <<< END: _scrollListener - scroll listener

  List<String> name = [
    'Start Your First Ride with Winter Offers.',
    'Hey! ',
  ];

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
          context,
          BottomNavigation(
            tabIndexId: widget.boolnotificationPage != true ? 2 : 0,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 7,
          backgroundColor: tDarkNavyblue,
          leading: GestureDetector(
            onTap: () {
              widget.boolnotificationPage != true
                  ? Twl.forceNavigateTo(
                      context,
                      BottomNavigation(
                        tabIndexId: 2,
                      ),
                    )
                  : Twl.forceNavigateTo(
                      context,
                      BottomNavigation(
                        tabIndexId: 0,
                      ),
                    );
            },
            child: Padding(
              padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
              child: BackIconWidget(),
            ),
          ),
          title: Text(
            'notifications'.tr,
            style: GoogleFonts.mulish(
              color: tWhite,
              fontWeight: FontWeight.w700,
              fontSize: isTab(context) ? 10.sp : 17.sp,
            ),
          ),
          actions: [
            PopupMenuButton<int>(
              onSelected: (value) async {
                var res = await UserAPI().getClearNotifaction(context);
                if (res != null && res['status'] == 'OK') {
                  Twl.forceNavigateTo(context, Notifactionpage());
                } else {
                  Twl.createAlert(context, 'Oops', res['error'].toString());
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: tDarkNavyblue,
              ),
              tooltip: "  ",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              offset: Offset(
                -40,
                -0,
              ),
              color: tWhite,
              itemBuilder: (context) => [
                PopupMenuItem(
                  height: 0.4.h,
                  child: Text(
                    'clear'.tr,
                    style: GoogleFonts.mulish(
                      color: tPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                    ),
                  ),
                  value: 1,
                ),
              ],
            ),
          ],
        ),
        body: Consumer<MyNotifactionProvider>(
          builder: (context, provider, child) {
            if (provider.myFavoritesGetting) {
              return Center(
                child: SpinKitThreeBounce(
                  color: tPrimaryColor,
                  size: 20.0,
                ),
              );
            } else if (provider.myFavoritesList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.h,
                      width: 50.w,
                      child: Image.asset(
                        Images.NO_NOTIFICATIONS,
                        scale: 2, // Replace with the path of your error image
                        // fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'No Notifications Yet',
                      style: GoogleFonts.mulish(
                        color: tDarkOrangeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: isTab(context) ? 11.sp : 15.sp,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'You have no notifications right now. Come back later',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mulish(
                          color: tlightGray,
                          fontWeight: FontWeight.w500,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: provider.myFavoritesList.length,
                physics: ScrollPhysics(),
                controller: scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var notificationDetails = provider.myFavoritesList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 0.6.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: tWhite,
                        boxShadow: [tBoxShadow],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: tPrimaryColor.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.notifications,
                                    color: tPrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 1,
                                      child: Text(
                                        notificationDetails['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.mulish(
                                          color: tDarkNavyblue,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              isTab(context) ? 8.sp : 12.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 1,
                                      child: Text(
                                        notificationDetails['description'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.mulish(
                                          color: tDarkOrangeColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              isTab(context) ? 7.sp : 8.5.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              Twl.dateFormate(
                                  notificationDetails['created_on']),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.mulish(
                                color: tDarkOrangeColor,
                                fontWeight: FontWeight.w500,
                                fontSize: isTab(context) ? 7.sp : 9.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _NotifactionpageState - the data and logic behind its screen


// class NotificationPagination extends StatefulWidget {
//   const NotificationPagination({
//     Key? key,

//   @override
//   State<NotificationPagination> createState() => _NotificationPaginationState();
// }

//         scrollController.position.maxScrollExtent - scrollController.offset <=
//             95) {
//         // currentPage = currentPage++;
//         if (val.details != null) {
//           setState(() {
//             // currentPage = currentPage + 1;
//             notificationList.addAll(val.details);
//           });
//         } else {
//           return Center(
//             child: Text('End of data'),
//           );
//         }


//   @override

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: notificationList.length,
//         physics: ScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         controller: scrollController,
//         itemBuilder: (BuildContext context, int index) {
//           var notificationDetails = notificationList[index];
//           return Container(
//               margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: tWhite,
//                   boxShadow: [tBoxShadow]),
//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: tPrimaryColor),
//                         child: Padding(
//                           padding: EdgeInsets.all(5.0),
//                           child: Image.asset(
//                             Images.CAR,
//                             color: tBlack,
//                             scale: isTab(context) ? 2.5 : 3.5,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 3.w,
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width / 1,
//                               child: Text(notificationDetails.title.toString(),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.mulish(
//                                       color: tBlack,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: isTab(context) ? 8.sp : 12.sp)),
//                             ),
//                             SizedBox(
//                               height: 0.5.h,
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width / 1,
//                               child: Text(
//                                   notificationDetails.description.toString(),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.mulish(
//                                       color: tBlack,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize:
//                                           isTab(context) ? 7.sp : 8.5.sp)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 1.5.h,
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(notificationDetails.createdDate.toString(),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.mulish(
//                             color: tGray,
//                             fontWeight: FontWeight.w500,
//                             fontSize: isTab(context) ? 7.sp : 9.sp)),
//                   )
//                 ],
//               ));
//         });
//   }
// }
