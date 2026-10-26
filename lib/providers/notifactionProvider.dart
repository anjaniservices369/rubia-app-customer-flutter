// =============================================================================
// WHAT : Holds the notification list and the unread count (red dot on the
//        bell).
// NOTES: Fed by the server.
// =============================================================================
import 'dart:developer';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// >>> START: MyNotifactionProvider - shared app memory (provider) other screens listen to
class MyNotifactionProvider extends ChangeNotifier {
  List myFavoritesList = [];
  bool myFavoritesGetting = false;
  int favoritesLength = 0;
  int currentPage = 0;
  int totalPages = 0;
  // >>> START: getFavorites - gets favorites
  getFavorites({context, page}) async {
    myFavoritesGetting = true;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var res = await UserAPI().getMyNotifaction(context, page);
    try {
      if (res['status'] == 'OK') {
        // myFavoritesList.clear();
        List details = res['details'];
        currentPage = res['pagination']['current_page'];
        totalPages = res['pagination']['total_pages'];
        myFavoritesList = myFavoritesList + details;
        details.clear();
        currentPage = currentPage + 1;
        log('current page' + currentPage.toString());
        log('total page' + totalPages.toString());
        myFavoritesGetting = false;
      } else {
        myFavoritesGetting = false;
      }
    } catch (e) {
      myFavoritesGetting = false;
      log(e.toString());
    }

    notifyListeners();
  }
  // <<< END: getFavorites - gets favorites
}
// <<< END: MyNotifactionProvider - shared app memory (provider) other screens listen to
