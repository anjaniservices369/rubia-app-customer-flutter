// =============================================================================
// WHAT : Notification list with clear-all.
// NOTES: Server: list-fcm-notifications, clear-notifications.
// =============================================================================
// import 'dart:developer';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';

import 'package:get/get_utils/get_utils.dart';
import 'package:provider/provider.dart';
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
        backgroundColor: tBackground,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 7,
          backgroundColor: tYellow,
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
            style: TextStyle(
              color: tDarkNavyblue,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          actions: [
            PopupMenuButton<int>(
              onSelected: (value) async {
                var res = await UserAPI().getClearNotifaction(context);
                if (res != null && res['status'] == 'OK') {
                  Twl.forceNavigateTo(context, Notifactionpage());
                } else {
                  Twl.createAlert(
                    context,
                    'Oops',
                    res == null
                        ? 'Please try again.'
                        : '${res['error'] ?? 'Please try again.'}',
                  );
                }
              },
              icon: Icon(Icons.more_vert, color: tDarkNavyblue),
              tooltip: 'More notification actions',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: tWhite,
              itemBuilder: (context) => [
                PopupMenuItem(
                  height: 48,
                  child: Text(
                    'clear'.tr,
                    style: TextStyle(
                      color: tPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
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
            if (provider.myFavoritesGetting &&
                provider.myFavoritesList.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: tPrimaryColor),
              );
            } else if (provider.myFavoritesList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: tPrimaryColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: tPrimaryColor,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'No Notifications Yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tDarkNavyblue,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You have no notifications right now. Come back later',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tGray,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: provider.myFavoritesList.length +
                    (provider.myFavoritesGetting ? 1 : 0),
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index == provider.myFavoritesList.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(color: tPrimaryColor),
                      ),
                    );
                  }
                  var notificationDetails = provider.myFavoritesList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: tWhite,
                      boxShadow: const [tBoxShadow],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tPrimaryColor.withValues(alpha: 0.12),
                          ),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: tPrimaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${notificationDetails['title'] ?? ''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: tDarkNavyblue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${notificationDetails['description'] ?? ''}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: tGray,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                Twl.dateFormate(
                                    notificationDetails['created_on']),
                                style: TextStyle(
                                  color: tDarkNavyblue.withValues(alpha: 0.65),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
