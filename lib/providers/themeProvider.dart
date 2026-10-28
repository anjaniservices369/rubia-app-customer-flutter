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
    tPrimaryColor = Color(0XFFFB6E1F);
    tSecondaryColor = Color(0XFF6B0BE4);
    tBackground = Colors.white;
    tWhite = Colors.white;
    tBlack = tDarkNavyblue;
    _swithValue = value;
    notifyListeners();
  }
  // <<< END: setDayMode - sets day mode
  ThemeData lightTheme = ThemeData.light().copyWith(
    iconTheme: IconThemeData(color: tDarkNavyblue),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: tDarkNavyblue, displayColor: tDarkNavyblue),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(background: tWhite, onSurface: tDarkNavyblue),
  );
  ThemeData darkTheme = ThemeData.dark().copyWith(
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: ThemeData.dark()
        .textTheme
        .apply(bodyColor: Colors.white, displayColor: Colors.white),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
    ).copyWith(
      background: tDarkNavyblue,
      surface: tDarkNavyblue,
      onSurface: Colors.white,
    ),
  );
  // >>> START: setNightMode - sets night mode
  void setNightMode(value) async {
   darkTheme;

    tPrimaryColor = Color(0XFF6B0BE4);
    tSecondaryColor = Color(0XFFFB6E1F);
    tWhite = tDarkNavyblue;
    tBlack = Colors.white;
    tBackground = tDarkNavyblue;
    _swithValue = value;
    notifyListeners();
  }
  // <<< END: setNightMode - sets night mode
}
// <<< END: ThemeProvider - shared app memory (provider) other screens listen to
