// =============================================================================
// WHAT : The customer's ratings and reviews.
// NOTES: Server: my-reviews.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../responsive.dart';
import '../../bottomNavigation.dart/bottomNavigation.dart';

// >>> START: ReviewsView - screen/widget shell (the visible part is in its State class)
class ReviewsView extends StatefulWidget {
  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}
// <<< END: ReviewsView - screen/widget shell (the visible part is in its State class)

// >>> START: _ReviewsViewState - the data and logic behind its screen
class _ReviewsViewState extends State<ReviewsView> {
  //     '0',
  //   );
  // }
  UserAPI userAPI = UserAPI();
  List<dynamic> ratingAndreviewData = [];
  bool isLoading = false;
  bool descTextShowFlag = false;
  int currentPage = 0;
  ScrollController _scrollController = ScrollController();

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    fetchratingBar();
    fetchRatingAndReview();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchRatingAndReview();
      }
    });
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  List<String> name = ['Shravan Prajapati', 'Manikanta chemiti'];
  List<String> ratingNo = ['5', '4', '3', '2', '1'];
  // >>> START: fetchRatingAndReview - fetches rating and review
  Future<void> fetchRatingAndReview() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      dynamic response =
          await userAPI.reviewAndRating(context, currentPage.toString());
      List<dynamic> newRatingData = response['details'] ?? [];
      setState(() {
        ratingAndreviewData.addAll(newRatingData);
        currentPage++;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }
  // <<< END: fetchRatingAndReview - fetches rating and review

  var ratingBar;
  // >>> START: fetchratingBar - fetchrating bar
  fetchratingBar() async {
    var res = await userAPI.reviewAndRating(context, '0');
    if (res != null && res['status'] == 'OK') {
      setState(() {
        ratingBar = res;
      });
    }
  }
  // <<< END: fetchratingBar - fetchrating bar


  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

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
          appBar: AppBar(
            elevation: 0.5,
            backgroundColor: tYellow,
            leading: GestureDetector(
              onTap: () {
                Twl.forceNavigateTo(
                    context,
                    BottomNavigation(
                      tabIndexId: 2,
                    ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                decoration: BoxDecoration(
                    boxShadow: [tBoxShadow],
                    color: tWhite,
                    borderRadius: BorderRadius.circular(6)),
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: tBlack,
                  size: 20,
                ),
              ),
            ),
            centerTitle: false,
            title: Text('rating_reviews'.tr,
                style: TextStyle(
                    // fontFamily: 'Plus Jakarta Sans',
                    fontSize: isTab(context) ? 10.sp : 14.sp,
                    color: tDarkNavyblue,
                    fontWeight: FontWeight.w700)),
          ),
          body: isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: SpinKitThreeBounce(
                    color: tPrimaryColor,
                    size: 30.0,
                  ))
              : ratingBar == null
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(" No ratings found"),
                    )
                  // CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: tWhite,
                                // borderRadius: BorderRadius.circular(12),
                                boxShadow: [tBoxShadow]),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Rating : ',
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize: isTab(context)
                                                  ? 11.sp
                                                  : 13.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          ratingBar['total_rating'].toString(),
                                          // '87K',
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize: isTab(context)
                                                  ? 11.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: tPrimaryColor,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 0.3.w,
                                        ),
                                        Text(
                                          '5',
                                          // ratingNo[index],
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          width: 46.w,
                                          height: 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: reviewTotal(
                                                      double.parse(ratingBar[
                                                              'rating_five']
                                                          .toString()),
                                                      double.parse(ratingBar[
                                                              'total_rating']
                                                          .toString())) /
                                                  100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      tDarkNavyblue),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          // '45K',
                                          ratingBar['rating_five'].toString(),
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: tPrimaryColor,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 0.3.w,
                                        ),
                                        Text(
                                          '4',
                                          // ratingNo[index],
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          width: 46.w,
                                          height: 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: reviewTotal(
                                                      double.parse(ratingBar[
                                                              'rating_four']
                                                          .toString()),
                                                      double.parse(ratingBar[
                                                              'total_rating']
                                                          .toString())) /
                                                  100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      tDarkNavyblue),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          // '45K',
                                          ratingBar['rating_four'].toString(),
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: tPrimaryColor,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 0.3.w,
                                        ),
                                        Text(
                                          '3',
                                          // ratingNo[index],
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          width: 46.w,
                                          height: 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: reviewTotal(
                                                      double.parse(ratingBar[
                                                              'rating_three']
                                                          .toString()),
                                                      double.parse(ratingBar[
                                                              'total_rating']
                                                          .toString())) /
                                                  100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      tDarkNavyblue),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          // '45K',
                                          ratingBar['rating_three'].toString(),
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: tPrimaryColor,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 0.3.w,
                                        ),
                                        Text(
                                          '2',
                                          // ratingNo[index],
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          width: 46.w,
                                          height: 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: reviewTotal(
                                                      double.parse(ratingBar[
                                                              'rating_two']
                                                          .toString()),
                                                      double.parse(ratingBar[
                                                              'total_rating']
                                                          .toString())) /
                                                  100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      tDarkNavyblue),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          // '45K',
                                          ratingBar['rating_two'].toString(),
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: tPrimaryColor,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 0.3.w,
                                        ),
                                        Text(
                                          '1',
                                          // ratingNo[index],
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          width: 46.w,
                                          height: 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: reviewTotal(
                                                      double.parse(ratingBar[
                                                              'rating_one']
                                                          .toString()),
                                                      double.parse(ratingBar[
                                                              'total_rating']
                                                          .toString())) /
                                                  100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      tDarkNavyblue),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          // '45K',
                                          ratingBar['rating_one'].toString(),
                                          // reviewDetail.user.name.toString(),
                                          style: TextStyle(
                                              fontFamily: 'mulish',
                                              color: tDarkNavyblue,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          ListView.builder(
                              itemCount: ratingAndreviewData.length + 1,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              controller: _scrollController,
                              // controller: scrollController,
                              physics: ScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                if (index == ratingAndreviewData.length) {
                                  if (isLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                }
                                var reviewDetail = ratingAndreviewData[index];
                                return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 3.5.w, vertical: 1.h),
                                    padding: EdgeInsets.only(
                                        left: 14,
                                        right: 14,
                                        top: 9,
                                        bottom: 14),
                                    decoration: BoxDecoration(
                                        color: tWhite,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x23000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 1),
                                          ),
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: tDarkNavyblue,
                                                        width: 2)),
                                                child: reviewDetail[
                                                                'driver_details']
                                                            ['profile_image'] !=
                                                        null
                                                    ? CircleAvatar(
                                                        backgroundColor: tWhite,
                                                        backgroundImage: AssetImage(
                                                            reviewDetail[
                                                                        'driver_details']
                                                                    [
                                                                    'profile_image']
                                                                .toString()),
                                                        radius: isTab(context)
                                                            ? 20
                                                            : 25)
                                                    : CircleAvatar(
                                                        backgroundImage:
                                                            AssetImage(
                                                                Images.IMAAGE),
                                                        backgroundColor: tWhite,
                                                        radius: isTab(context)
                                                            ? 20
                                                            : 25,
                                                      )
                                                //   CircleAvatar
                                                //     backgroundImage:
                                                //         AssetImage(Images.IMAAGE),
                                                //     backgroundColor: tWhite,
                                                //     radius: isTab(context) ? 20 : 25,
                                                //   ),
                                                ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reviewDetail['driver_details']
                                                              ['first_name']
                                                          .toString() +
                                                      reviewDetail[
                                                                  'driver_details']
                                                              ['last_name']
                                                          .toString(),
                                                  // name[index],
                                                  // reviewDetail.user.name.toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'mulish',
                                                      color: tDarkNavyblue,
                                                      fontSize: isTab(context)
                                                          ? 11.sp
                                                          : 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: tPrimaryColor,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      // '4.5',
                                                      reviewDetail['rating']
                                                          .toString(),
                                                      // reviewDetail.rating.toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color: tDarkNavyblue,
                                                          fontSize:
                                                              isTab(context)
                                                                  ? 10.sp
                                                                  : 12.sp,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Text(
                                                  // '11:00 AM',
                                                  reviewDetail['driver_details']
                                                          ['created_at']
                                                      .toString(),
                                                  // Twl.dateFormate(reviewDetail['created_at'])
                                                  //     .toString(),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: tDarkOrangeColor,
                                                      fontSize: isTab(context)
                                                          ? 7.sp
                                                          : 9.5.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                // Text(
                                                //   '23-08-23',
                                                //       fontFamily: 'Plus Jakarta Sans',
                                                //       color: tGray,
                                                //       fontSize:
                                                //           isTab(context) ? 7.sp : 9.sp,
                                                //       fontWeight: FontWeight.w400),
                                                // ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            reviewDetail['review'].toString(),
                                            // reviewDetail.userDiscription.toString(),
                                            // textAlign: TextAlign.start,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: tDarkOrangeColor,
                                                fontSize: isTab(context)
                                                    ? 7.sp
                                                    : 9.5.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                      ],
                                    ));
                              }),
                        ],
                      ),
                    )),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: reviewTotal - review total
  static reviewTotal(var actualValue, var totalValue) {
    final totalPrecentage = (actualValue / totalValue) * 100;
    return totalPrecentage;
  }
  // <<< END: reviewTotal - review total
}
// <<< END: _ReviewsViewState - the data and logic behind its screen
