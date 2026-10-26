// =============================================================================
// WHAT : Choose the drop from saved favourite addresses.
// NOTES: Server: list-favourite-location.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/dropGoogleMap.dart';
import '../../globalWidgets/pickupgoogleMap.dart';
import '../../providers/riderProvider.dart';

// >>> START: FavLocation - screen/widget
class FavLocation extends StatelessWidget {
  const FavLocation({Key? key}) : super(key: key);

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

    return Column(
      children: [
        SizedBox(height: 2.h),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'choose_from_favourites'.tr,
            style: GoogleFonts.mulish(
              color: tSecondaryColor,
              fontWeight: FontWeight.w700,
              fontSize: isTab(context) ? 10.sp : 16.sp,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: FutureBuilder(
            future: UserAPI().favoriteList(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('error_fetching_favorite'.tr));
              } else if (!snapshot.hasData) {
                return Center(child: Text('no_favorites_found'.tr));
              } else {
                final data = snapshot.data as Map<String, dynamic>?;

                if (data != null) {
                  final details = data['details'] as List<dynamic>?;

                  if (details != null && details.isNotEmpty) {
                    return ListView.builder(
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        final item = details[index] as Map<String, dynamic>;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: tWhite, boxShadow: [tBackbtnBoxShadow]),
                          child: ListTile(
                            leading: Image.asset(
                              item['address_type'] == 'home'.tr
                                  ? Images.HOUSEICON
                                  : item['address_type'] == 'office'.tr
                                      ? Images.BUILDINGLOCATION
                                      : Images.LIKEMORE,
                              scale: isTab(context) ? 4 : 5,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['address_type'] as String,
                                  style: GoogleFonts.mulish(
                                    color: tSecondaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTab(context) ? 10.sp : 13.sp,
                                  ),
                                ),
                                Text(
                                  item['address'] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.mulish(
                                    color: tDarkOrangeColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: isTab(context) ? 8.sp : 10.sp,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final latitude = item['latitude'] as String;
                              final longitude = item['logitude'] as String;
                              final address = item['address'] as String;
                              Map<String, String> param = {
                                'lat': latitude.toString(),
                                'lng': longitude.toString(),
                              };
                              var res = await UserAPI().checkBoundary(context, param);
                              if (res['status'] == "OK") {
                                if (tripOptionsProvider.locationType == 1) {
                                  if (tripOptionsProvider.tripType == TRIP_TYPE_INTERCITY) {
                                    tripOptionsProvider.setPickupLocation(latitude, longitude, address);
                                    tripOptionsProvider.setCityId(res['selected_city_id']);
                                    tripOptionsProvider.setDropLocation("", "", "");
                                    Twl.navigateBack(context);
                                  } else {
                                    tripOptionsProvider.setPickupLocation(latitude, longitude, address);
                                    tripOptionsProvider.setCityId(res['selected_city_id']);
                                    Twl.navigateBack(context);

                                    // if (tripOptionsProvider.tripType !=
                                    //         TRIP_TYPE_INTERCITY &&
                                    //     tripOptionsProvider.selectedCityId !=
                                    //         res['selected_city_id'] &&
                                    //     tripOptionsProvider.selectedCityId !=
                                    //         0) {
                                    //   tripOptionsProvider
                                  }
                                } else {
                                  if (tripOptionsProvider.tripType == TRIP_TYPE_INTERCITY) {
                                    // Check for selected city and it should be same with pickup city id
                                    if (tripOptionsProvider.selectedCityId == res['selected_city_id'] && tripOptionsProvider.selectedCityId != 0) {
                                      tripOptionsProvider.setDropLocation(latitude, longitude, address);
                                      tripOptionsProvider.setCityId(res['selected_city_id']);
                                      tripOptionsProvider.setDropCityId(res['selected_city_id']);
                                      Twl.navigateBack(context);
                                    } else {
                                      Twl.createAlert(context, "Sorry", "Pickup and Drop location should be same city");
                                    }
                                  } else {
                                    if (tripOptionsProvider.selectedCityId != res['selected_city_id']) {
                                      tripOptionsProvider.setDropLocation(latitude, longitude, address);
                                      if (tripOptionsProvider.selectedCityId != null || tripOptionsProvider.selectedCityId != 0) {
                                        tripOptionsProvider.setCityId(res['selected_city_id']);
                                      }

                                      // tripOptionsProvider.setDropCityId(
                                      //     res['selected_city_id']);
                                      Twl.navigateBack(context);
                                      tripOptionsProvider.getVehicles(context);
                                    } else {
                                      Twl.createAlert(context, "Sorry", "Pickup and Drop locations should be in different cities");
                                    }
                                  }
                                }
                              } else {
                                //   'sorry'.tr,
                                if (tripOptionsProvider.tripType == TRIP_TYPE_INTERCITY) {
                                  // Check for selected city and it should be same with pickup city id
                                  if (tripOptionsProvider.selectedCityId == res['selected_city_id'] && tripOptionsProvider.selectedCityId != 0) {
                                    tripOptionsProvider.setDropLocation(latitude, longitude, address);
                                    tripOptionsProvider.setCityId(res['selected_city_id']);
                                    tripOptionsProvider.setDropCityId(res['selected_city_id']);
                                    Twl.navigateBack(context);
                                  } else {
                                    Twl.createAlert(context, "Sorry", "Pickup and Drop location should be same city");
                                  }
                                } else {
                                  if (tripOptionsProvider.selectedCityId != res['selected_city_id']) {
                                    tripOptionsProvider.setDropLocation(latitude, longitude, address);
                                    // tripOptionsProvider
                                    //     .setCityId(res['selected_city_id']);
                                    // tripOptionsProvider
                                    //     .setDropCityId(res['selected_city_id']);
                                    Twl.navigateBack(context);
                                    tripOptionsProvider.getVehicles(context);
                                  } else {
                                    Twl.createAlert(context, "Sorry", "Pickup and Drop locations should be in different cities");
                                  }
                                }
                              }
                            },
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return Container();
                }
              }
              return Center(child: Text('no_favorites_found'.tr));
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            Twl.navigateBack(context);
            tripOptionsProvider.locationType == 1
                ? Twl.navigateTo(
                    context,
                    PickupAddressGoogleMapPage(),
                  )
                : Twl.forceNavigateTo(
                    context,
                    DropGoogleMap(),
                  );
          },
          child: Container(
            height: 6.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: tPrimaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: tWhite,
                  size: 24.0,
                ),
                Text(
                  'select_from_map'.tr,
                  style: TextStyle(
                    letterSpacing: 1,
                    color: tWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: isTab(context) ? 8.sp : 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: FavLocation - screen/widget
