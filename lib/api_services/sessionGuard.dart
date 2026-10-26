// =============================================================================
// WHAT : Logs the customer out automatically when the server says the login is
//        no longer valid (expired after 90 days, replaced by a newer login, or
//        unknown).
// NOTES: Clears saved data and returns to the login screen. Called from
//        ApiHelper.
// =============================================================================
import 'package:base_project_flutter/views/logiPage/loginPage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// >>> START: SessionGuard - logs the customer out when the server says the login is no longer valid
/// Central handling for a rejected session.
///
/// The backend answers HTTP 200 with `status: NOK` and one of the errors below
/// when the `auth_code` is unknown, expired (90 days) or replaced by a newer
/// login. When that happens the stored session is wiped and the user is sent
/// back to the phone + OTP login screen.
class SessionGuard {
  // The server's wording for "your login is not valid any more".
  // The comparison is case-insensitive and also matches when the error is a list.
  static const List<String> _authErrors = [
    'user not found',
    'session not found',
    'auth code not found',
  ];

  // Prevents the logout from running twice when several requests fail together.
  static bool _handling = false;

  // >>> START: isAuthFailure - tells whether a server reply means "login invalid or expired"
  /// True when [response] is a NOK reply caused by an invalid session.
  /// The error may be a string or a list of strings.
  static bool isAuthFailure(dynamic response) {
    // 1. Only a JSON object can carry a status.
    if (response is! Map) return false;
    // 2. The server marks every failure with status = NOK.
    if (response['status']?.toString() != 'NOK') return false;
    // 3. No error text means it cannot be a login problem.
    final error = response['error'];
    if (error == null) return false;
    // 4. Turn the error (string or list) into one lower-case text and look for
    //    any of the known "login invalid" phrases.
    final text = error.toString().toLowerCase();
    return _authErrors.any(text.contains);
  }
  // <<< END: isAuthFailure - tells whether a server reply means "login invalid or expired"

  // >>> START: handle - if the login is invalid: clear saved data and go back to the login screen
  /// Clears the stored session and navigates to the login screen.
  /// Returns true when [response] was an auth failure.
  static Future<bool> handle(dynamic response) async {
    // 1. Ignore replies that are not a "login invalid" problem.
    if (!isAuthFailure(response)) return false;
    // 2. Skip if a logout is already running, or the app has not drawn its
    //    first screen yet (main.dart decides the first screen on its own).
    if (_handling || Get.context == null) return true;
    _handling = true;
    try {
      // 3. Forget everything saved on the phone (login code, profile, etc.).
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      // 4. Clear the screen stack and open the login screen.
      Get.offAll(() => LoginScreen());
      // 5. Tell the customer why they were signed out.
      Get.snackbar('Session expired', 'Please log in again.');
    } finally {
      // 6. Allow the next logout after two seconds.
      Future.delayed(const Duration(seconds: 2), () => _handling = false);
    }
    return true;
  }
  // <<< END: handle - if the login is invalid: clear saved data and go back to the login screen
}
// <<< END: SessionGuard - logs the customer out when the server says the login is no longer valid
