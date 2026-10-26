// =============================================================================
// WHAT : Push notifications through OneSignal: registers the phone and passes
//        its id to the server.
// NOTES: The server uses that id to send alerts (booking accepted, driver
//        arrived, etc.). Only the public App ID is in the app; the secret REST
//        key must stay on the server.
// =============================================================================
import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:base_project_flutter/constants/apiConstants.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// >>> START: PushService - push notifications through OneSignal
/// Push notifications through OneSignal. The backend sends the pushes; the app
/// only registers and hands the subscription id to the server as `device_token`.
///
/// The App ID is public (it ships in every client). It can be overridden at
/// build time with `--dart-define=ONESIGNAL_APP_ID=<id>`. The REST API key is a
/// server secret and must never be put in the app.
class PushService {
  // The public OneSignal App ID (safe to ship inside the app).
  static const String _appId = String.fromEnvironment('ONESIGNAL_APP_ID',
      defaultValue: '72d43997-f9ac-4ed0-aaaa-8a8830060bd3');

  // True once OneSignal has been started in this run of the app.
  static bool _started = false;

  static bool get isConfigured => _appId.isNotEmpty;

  // >>> START: subscriptionId - this phone OneSignal notification id, once registered
  /// OneSignal subscription id, null until the device has registered.
  static String? get subscriptionId {
    // Not started (or push disabled): there is no id to give.
    if (!_started) return null;
    return OneSignal.User.pushSubscription.id;
  }
  // <<< END: subscriptionId - this phone OneSignal notification id, once registered

  // >>> START: init - starts push notifications (asks permission, registers the phone)
  /// Starts push notifications. Called once from main.dart at app start.
  static Future<void> init() async {
    // 1. Push is not available in a web browser build.
    if (kIsWeb) return;
    // 2. Nothing to do when no App ID is configured.
    if (!isConfigured) {
      debugPrint('PushService: ONESIGNAL_APP_ID not set, push is disabled.');
      return;
    }
    // 3. Connect this phone to the Rubia OneSignal project.
    OneSignal.initialize(_appId);
    _started = true;
    // 4. Whenever the phone gets (or changes) its notification id, report it.
    OneSignal.User.pushSubscription.addObserver((state) {
      // The id appears after registration and changes on re-subscribe.
      debugPrint('PushService: subscription id = '
          '${state.current.id}, opted in = ${state.current.optedIn}');
      syncToken();
    });
    // 5. When the customer taps a notification, log the data it carried.
    OneSignal.Notifications.addClickListener((event) {
      // Data keys sent by the server: order_id, type, url, img_url.
      debugPrint('Push opened: ${event.notification.additionalData}');
    });
    // 6. Ask the customer's permission to show notifications (Android 13+).
    await OneSignal.Notifications.requestPermission(true);
  }
  // <<< END: init - starts push notifications (asks permission, registers the phone)

  // >>> START: syncToken - tells the server this phone's notification id so it can send alerts
  /// Sends the current subscription id to the backend (`check`), when logged in.
  static Future<void> syncToken() async {
    // 1. Need a registered phone id first.
    final id = subscriptionId;
    if (id == null || id.isEmpty) return;
    try {
      // 2. Need a logged-in customer: the server stores the id against them.
      final prefs = await SharedPreferences.getInstance();
      final authCode = prefs.getString('authCode');
      if (authCode == null || authCode.isEmpty) return;
      // 3. Send the id; failures are ignored (it is retried on the next change).
      await ApiHelper().getTypePostBG(
        CHECK_API + authCode,
        {'AuthSession[device_token]': id},
      );
    } catch (e) {
      debugPrint('PushService.syncToken failed: $e');
    }
  }
  // <<< END: syncToken - tells the server this phone's notification id so it can send alerts
}
// <<< END: PushService - push notifications through OneSignal
