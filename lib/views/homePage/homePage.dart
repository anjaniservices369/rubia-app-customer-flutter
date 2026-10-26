// =============================================================================
// WHAT : HOME: shows the live services, banners and the current address.
// NOTES: Shows the live services (Driver and Taxi, from the server's list; see
//        AppScreens). Other tiles stay hidden until showComingSoonServices is
//        turned on.
// =============================================================================
import 'package:base_project_flutter/api_services/servicesApi.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/providers/notifactionProvider.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/responsive.dart';

import 'package:base_project_flutter/views/profilePage/components/notifactionPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import 'package:super_banners/super_banners.dart';

import '../../constants/appScreens.dart';
import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';

import '../RideBooking/selectLocationPage.dart';
import '../../taxi/taxiServicesPage.dart';

// >>> START: HomePage - home screen: services, banners and address
class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
// <<< END: HomePage - home screen: services, banners and address

// >>> START: _HomePageState - the data and logic behind its screen
class _HomePageState extends State<HomePage> {
  var homeServicesStatus;
  var checkDetails;
  bool isOthersServiceAvailable = true;

  // >>> START: checkLoginApi - checks login api
  checkLoginApi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var check =
        await UserAPI().checkApi(sharedPreferences.getString('authCode')!);
    if (check != null && check['status'] == 'OK') {
      if (mounted) {
        setState(() {
          checkDetails = check['detail'];
        });
      }
    }
  }
  // <<< END: checkLoginApi - checks login api

  var homeServices;
  var serviceNOK;

  // >>> START: fetchServices - fetches services
  fetchServices() async {
    var res = await ServicesAPI().getServices(context);
    if (res != null && res['status'] == 'OK') {
      if (mounted) {
        final details = (res['details'] as List?) ?? [];
        setState(() {
          homeServices = AppScreens.showComingSoonServices
              ? details
              : details
                  .where((s) => AppScreens.isLiveService(s['type']))
                  .toList();
        });
      }
    } else {
      serviceNOK = res != null ? res['status'] : 'NOK';
    }
  }
  // <<< END: fetchServices - fetches services

  var banners;

  // >>> START: fetchBanner - fetches banner
  fetchBanner() async {
    var res = await UserAPI().getBanners(context);
    if (res != null && res['status'] == 'OK') {
      if (mounted) {
        setState(() {
          banners = res['details'] ?? [];
        });
      }
    } else if (mounted) {
      setState(() {
        banners = [];
      });
    }
  }
  // <<< END: fetchBanner - fetches banner

  var cancellationDetails;
  var penalty = false;

  // >>> START: getCancellationCharges - asks whether a cancellation fee is pending for this customer
  getCancellationCharges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await ServicesAPI().getCancellationCharges(context);
    if (res != null && res['status'] == 'OK') {
      setState(() {
        cancellationDetails = res['details'];
        penalty = res['details']['cancellation'];
        if (cancellationDetails['cancel_charges'] == null) {
          prefs.setInt('cancel_charges', 0);
        } else {
          prefs.setInt('cancel_charges', cancellationDetails['cancel_charges']);
        }
        // print("sett cancellation: ${cancellationDetails['cancel_charges']}");
      });
    }
  }
  // <<< END: getCancellationCharges - asks whether a cancellation fee is pending for this customer

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    fetchBanner();
    checkLoginApi();
    fetchServices();
    getCancellationCharges();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final tripOptionsProvider =
          Provider.of<TripOptionsProvider>(context, listen: false);
      if (tripOptionsProvider.pickupAddress.isEmpty) {
        tripOptionsProvider.getCurrentLocation(context);
      }
      Provider.of<MyNotifactionProvider>(context, listen: false)
          .getFavorites(context: context, page: 1);
    });
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final myNotificationProvider =
        Provider.of<MyNotifactionProvider>(context);
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);
    return checkDetails == null
        ? SpinKitThreeBounce(
            color: tPrimaryColor,
            size: 20.0,
          )
        : Scaffold(
            backgroundColor: tWhite,
            appBar: isDesktop(context)
                ? null
                : AppBar(
                    backgroundColor: tDarkNavyblue,
                    elevation: 0,

                    leading: Builder(builder: (BuildContext context) {
                      return Row(
                        children: [
                          SizedBox(width: 3.w),
                          Container(
                            // height: 45.0,
                            // width: 45.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: checkDetails['selfie'] == null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(Images.UNKNOWN_IMAGE),
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      checkDetails['selfie'],
                                    ),
                                    // Old Firebase image links return 404:
                                    // treat a failed load as "missing".
                                    onBackgroundImageError: (_, __) {},
                                  ),
                          ),
                        ],
                      );
                    }),

                    centerTitle: true,
                    title: GestureDetector(
                        onTap: () async {
                          // await Twl.navigateTo(context, SelectRidePage());
                        },
                        child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'home'.tr,
                                  style: TextStyle(
                                      color: tWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: isTab(context) ? 10.sp : 11.sp),
                                ),
                                tripOptionsProvider.pickupAddress.isEmpty
                                    ? Container(
                                        child: Text(
                                          'fetching for current location',
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              color: tWhite,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isTab(context)
                                                  ? 10.sp
                                                  : 12.sp),
                                          maxLines: 2,
                                        ),
                                      )
                                    : Container(
                                        width: 100.w,
                                        child: Text(
                                          tripOptionsProvider.pickupAddress,
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              color: tWhite,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isTab(context)
                                                  ? 10.sp
                                                  : 12.sp),
                                          maxLines: 2,
                                        ),
                                      ),
                              ],
                            ))),
                    //   title: GestureDetector(
                    // // onTap: () async {
                    // //   Twl.navigateTo(context, GoogleMapPage());
                    // // },
                    //         ? Row(
                    //             children: [
                    //               Container(
                    //                 width: 42.w,
                    //                 child: Text(
                    //                   addressLine != null ? addressLine: '',
                    //                   overflow: TextOverflow.ellipsis,
                    //                   maxLines: 2,
                    //                   style: TextStyle(
                    //                     fontSize: isTab(context) ? 8.sp : 10.sp,
                    //                     fontWeight: FontWeight.w500,
                    //                     color: tDarkNavyblue,
                    //                   ),
                    //                 ),
                    //               ),
                    //               // Image.asset(
                    //               //   Images.DownArrowIcon,
                    //               //   width: isTab(context) ? 25 : 20,
                    //               // )
                    //             ],
                    //           )
                    //         : Row(
                    //             children: [
                    //               Container(
                    //                 width: 42.w,
                    //                 child: Text(
                    //                   formattedAddress != null
                    //                       ? formattedAddress: '',
                    //                   overflow: TextOverflow.ellipsis,
                    //                   maxLines: 2,
                    //                   style: TextStyle(
                    //                       fontSize: 10.sp,
                    //                       fontWeight: FontWeight.w500,
                    //                       color: tDarkNavyblue),
                    //                 ),
                    //               ),
                    //               // Image.asset(
                    //               //   Images.DownArrowIcon,
                    //               //   width: 20,
                    //               // )
                    //             ],
                    //
                    //          ))),

                    actions: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: GestureDetector(
                            onTap: () {
                              Twl.forceNavigateTo(context,
                                  Notifactionpage(boolnotificationPage: true));
                            },
                            child:
                                myNotificationProvider.myFavoritesList.isEmpty
                                    ? Image.asset(
                                        Images.NOTIFICATION,
                                        scale: 3,
                                      )
                                    : Badge(
                                        isLabelVisible: true,
                                        backgroundColor: tRed,
                                        child: Image.asset(
                                          Images.NOTIFICATION,
                                          scale: 3,
                                        ))),
                      )
                    ],
                  ),
            body: SingleChildScrollView(
              child: banners == null || homeServices == null
                  ? Container(
                      child: Align(
                          alignment: Alignment.center,
                          child: SpinKitThreeBounce(
                            color: tPrimaryColor,
                            size: 20.0,
                          )),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        serviceNOK == 'NOK'
                            ? Container(
                                alignment: Alignment.center,
                                child: Text('No data found'))
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: GridView.builder(
                                  itemCount: homeServices.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: homeServices.length ==
                                                  1
                                              ? 1
                                              : isDesktop(context)
                                                  ? 2
                                                  : 3,
                                          crossAxisSpacing: 4.w,
                                          mainAxisSpacing: 2.h,
                                          childAspectRatio: homeServices
                                                      .length ==
                                                  1
                                              ? 2.4
                                              : isDesktop(context)
                                                  ? 0.2.w
                                                  : isTab(context)
                                                      ? 4
                                                      : 0.9),
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var services = homeServices[index];
                                    if (!AppScreens.isLiveService(
                                        services['type'])) {
                                      return buildOthersServiceWidget(services);
                                    } else {
                                      return GestureDetector(
                                        onTap: () async {
                                          navigateBasedOnConstant(
                                              services['type'], context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(05),
                                              border: Border.all(
                                                color: tPrimaryColor,
                                              )),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Image.network(
                                                  services['image'].toString(),
                                                  width: 40,
                                                  scale:
                                                      isTab(context) ? 2 : 4.5,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  services['title'].toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: isDesktop(context)
                                                        ? 3.sp
                                                        : isTab(context)
                                                            ? 9.sp
                                                            : 10.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: tDarkNavyblue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                        SizedBox(
                          height: 2.h,
                        ),
                        banners != null
                            ? Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // height: MediaQuery.of(context)
                                    //     .size
                                    //     .height, // Adjust the height as needed
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: banners.length,
                                      // Number of outer items
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var details = banners[index];
                                        return Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  details['title'],
                                                  style: TextStyle(
                                                      color: tDarkNavyblue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: isTab(context)
                                                          ? 10.sp
                                                          : 14.sp),
                                                ),
                                                // Text(
                                                //   details['title'],
                                                // ),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                                child: ListView.builder(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: banners[index]
                                                          ['banner']
                                                      .length, // Number of inner items
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int secoundIndex) {
                                                    var bannerDetails =
                                                        banners[index]['banner']
                                                            [secoundIndex];

                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Image.network(
                                                            bannerDetails[
                                                                'image'],
                                                            height: 5.h,
                                                            width: 80.w,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )

                                  //         physics: NeverScrollableScrollPhysics(),
                                  //         itemCount: 10, // Number of outer items
                                  //         itemBuilder: (BuildContext context, int index) {
                                  //           return Column(
                                  //             children: [
                                  //               ListTile(
                                  //                 title: Text(
                                  //                   'Claim_your_Special'.tr,
                                  //                 ),
                                  //               ),
                                  //               Container(
                                  //                 height:
                                  //                     MediaQuery.of(context).size.height / 5,
                                  //                 child: ListView.builder(
                                  //                   scrollDirection: Axis.horizontal,
                                  //                   // shrinkWrap: true,
                                  //                   physics: ScrollPhysics(),
                                  //                   itemCount: 6, // Number of inner items
                                  //                   itemBuilder: (BuildContext context,
                                  //                       int innerIndex) {
                                  //                     return Image.asset(
                                  //                       Images.CARD,
                                  //                       scale: 4,
                                  //                     );
                                  //                   },
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           );
                                  //         },
                                  //       ),

                                  //     ),
                                  //   ],
                                  // )
                                ],
                              )
                            : Container(),
                      ],
                    ),
            ));
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: buildOthersServiceWidget - build others service widget
  Widget buildOthersServiceWidget(services) {
    return Stack(
      children: [
        Container(
          width: 30.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(05),
              border: Border.all(
                color: tPrimaryColor,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Image.network(
                  services['image'].toString(),
                  width: 40,
                  scale: isTab(context) ? 2 : 4.5,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  services['title'].toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop(context)
                        ? 3.sp
                        : isTab(context)
                            ? 9.sp
                            : 10.sp,
                    fontWeight: FontWeight.w700,
                    color: tDarkNavyblue,
                  ),
                ),
              ),
            ],
          ),
        ),
        CornerBanner(
          bannerPosition: CornerBannerPosition.topLeft,
          bannerColor: tDarkNavyblue,
          child: Text(
            "Coming soon!",
            style: TextStyle(
                color: tWhite,
                fontWeight: FontWeight.w400,
                fontSize: isTab(context) ? 8.sp : 12.sp),
          ),
        ),
      ],
    );
  }
  // <<< END: buildOthersServiceWidget - build others service widget

//

  // >>> START: navigateBasedOnConstant - opens based on constant
  void navigateBasedOnConstant(
    int constant,
    BuildContext context,
  ) {
    final tripOptionsProvider =
        Provider.of<TripOptionsProvider>(context, listen: false);
    switch (constant) {
      case DRIVER:
        if (penalty) {
          Twl.CancellationChargesBox(
              context, cancellationDetails['cancel_charges']);
        } else {
          //Navigate to the single booking screen for driver
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectLocationPage()),
          );
        }

        // Set service type for trip options provider
        tripOptionsProvider.setServiceType('DRIVER');
        break;

      case TAXI:
        // Taxi opens the Bike / Auto / Car service cards; each books on its own backend.
        tripOptionsProvider.setServiceType('TAXI');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TaxiServicesPage()),
        );
        break;

      case AUTO:
      case BIKE:
        if (!AppScreens.showComingSoonServices) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Exciting new services are on their way!'),
            ),
          );
          break;
        }
        tripOptionsProvider.setServiceType(
            constant == TAXI ? 'TAXI' : constant == AUTO ? 'AUTO' : 'BIKE');
        tripOptionsProvider.setServiceVehicleType(constant);
        break;
      case OTHERS:
        // Show a snackbar for other services
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exciting new services are on their way!'),
          ),
        );
        tripOptionsProvider.setServiceType('others');
        tripOptionsProvider.setServiceVehicleType(5);
        break;
      default:
        break;
    }
  }
  // <<< END: navigateBasedOnConstant - opens based on constant
}
// <<< END: _HomePageState - the data and logic behind its screen
