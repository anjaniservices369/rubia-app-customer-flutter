// =============================================================================
// WHAT : Light/dark theme choice.
// NOTES: Currently not exposed to the customer.
// =============================================================================
import 'package:flutter/material.dart';

import '../constants/constants.dart';

// >>> START: ThemeProvider - shared app memory (provider) other screens listen to
class ThemeProvider with ChangeNotifier {
  bool _swithValue = false;

  bool get swithValue => _swithValue;
  // >>> START: setDayMode - sets day mode
  void setDayMode(value) async {
    ThemeData(colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: tWhite));
    tPrimaryColor = Color(0XFFFB6E1F);
    tSecondaryColor = Color(0XFF6B0BE4);
    tBackground = Colors.white;
    tWhite = Colors.white;
    tBlack = Colors.black;
    _swithValue = value;
    notifyListeners();
  }
  // <<< END: setDayMode - sets day mode
  ThemeData lightTheme =ThemeData(colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: tWhite));
ThemeData darkTheme = ThemeData(
        iconTheme:  IconThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: tBlack));
  // >>> START: setNightMode - sets night mode
  void setNightMode(value) async {
   darkTheme;

    tPrimaryColor = Color(0XFF6B0BE4);
    tSecondaryColor = Color(0XFFFB6E1F);
    tWhite = Colors.black;
    tBlack = Colors.white;
    tBackground = Colors.black;
    _swithValue = value;
    notifyListeners();
  }
  // <<< END: setNightMode - sets night mode
}
// <<< END: ThemeProvider - shared app memory (provider) other screens listen to
