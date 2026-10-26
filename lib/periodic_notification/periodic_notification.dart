// =============================================================================
// WHAT : After a booking is placed, checks the booking status every ~30 seconds
//        in the background and shows a notification (for example 'Driver
//        Arrived, please share your OTP').
// NOTES: Runs through the Android WorkManager so it works even when the app is
//        closed.
// =============================================================================
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../api_services/userApi.dart';
import '../constants/constants.dart';

typedef VoidCallback = void Function();

// >>> START: callbackDispatcher - callback dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    await PeriodicNotification._performBackgroundTask();
    return Future.value(true);
  });
}
// <<< END: callbackDispatcher - callback dispatcher

// >>> START: PeriodicNotification - helper class
class PeriodicNotification {
  static const String onDemandTaskName = "onDemandTask";
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static VoidCallback? onStateChanged; // Callback to update state

  // >>> START: setOnStateChangedCallback - sets on state changed callback
  static void setOnStateChangedCallback(VoidCallback callback) {
    onStateChanged = callback;
  }
  // <<< END: setOnStateChangedCallback - sets on state changed callback

  // >>> START: _performBackgroundTask - perform background task
  static Future<void> _performBackgroundTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bookingId = prefs.getString('booking_id');

    if (bookingId != null) {
      var details = await UserAPI().viewBookingBG(bookingId);

      if (details != null && details['status'] == 'OK') {
        _handleBookingStatus(details['details']['status'],details['details']['notif_status'],int.parse(details['notification_interval']),int.parse(details['auto_cancel_time']));

      }
    }
  }
  // <<< END: _performBackgroundTask - perform background task

  // >>> START: _handleBookingStatus - handles booking status
  static void _handleBookingStatus(int status,int notificationStatus, int notificationInterval,int autoCancelTime ) {
    if (status == STATUS_GO_FOR_PICKUP && notificationStatus == 1) {
      // Display notification for driver arrival
      _showNotification('Driver Arrived', 'Please share your OTP, otherwise your ride will cancel in 20 minutes');
      // Register the same one-off task again with a delay of 30 seconds
      Workmanager().registerOneOffTask(
        onDemandTaskName,
        onDemandTaskName,
        initialDelay: Duration(minutes: notificationInterval),
        existingWorkPolicy: ExistingWorkPolicy.append,
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
        ),
      );
    } else if (status == STATUS_WAITING_FOR_DRIVER || status == STATUS_DRIVER_ACCEPTED || status == STATUS_GO_FOR_PICKUP) {
      Workmanager().registerOneOffTask(
        onDemandTaskName,
        onDemandTaskName,
        initialDelay: Duration(seconds: 30),
        existingWorkPolicy: ExistingWorkPolicy.append,
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
        ),
      );
    }
  }
  // <<< END: _handleBookingStatus - handles booking status



  // >>> START: _ensureInitialized - prepares the notification plugin once
  /// The plugin must be initialised before it can show anything on Android.
  /// Safe to call many times (also from the WorkManager background isolate).
  static bool _initialized = false;
  // >>> START: _ensureInitialized - ensure initialized
  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_notify'),
    ));
    _initializeNotificationChannel();
    _initialized = true;
  }
  // <<< END: _ensureInitialized - ensure initialized
  // <<< END: _ensureInitialized - prepares the notification plugin once

  // >>> START: showBookingPlaced - tells the customer the booking was received
  /// Shows "Booking placed" with a sound right after the server accepts the
  /// booking. [bookingId] is the server's booking number.
  static Future<void> showBookingPlaced(String bookingId) async {
    await _ensureInitialized();
    await flutterLocalNotificationsPlugin.show(
      1, // id 1 = booking placed (0 is used by the status notifications)
      'Booking placed',
      'Your driver booking #$bookingId was received. We are finding a driver for you.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '888',
          'Arrive Location',
          channelShowBadge: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('music'),
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_stat_notify',
        ),
      ),
      payload: 'booking_placed',
    );
  }
  // <<< END: showBookingPlaced - tells the customer the booking was received

  // >>> START: _showNotification - shows notification
  static void _showNotification(String title, String description) async {
    await _ensureInitialized();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '888',
      'Arrive Location',
      channelShowBadge: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('music'),
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_stat_notify',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      title,
      description,
      platformChannelSpecifics,
      payload: "ondemand_notification",
    );
  }
  // <<< END: _showNotification - shows notification

  // >>> START: startOnDemandTask - starts on demand task
  static void startOnDemandTask() {
    // Initialize notification channel
    _initializeNotificationChannel();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    // Register on-demand task with a delay of 30 seconds
    Workmanager().registerOneOffTask(
      onDemandTaskName,
      onDemandTaskName,
      initialDelay: Duration(seconds: 30),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }
  // <<< END: startOnDemandTask - starts on demand task

  // >>> START: _initializeNotificationChannel - initialize notification channel
  static void _initializeNotificationChannel() {
    // Initialize notification channel for Android
    const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
      '888',
      'Arrive Location',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('music'),
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
  // <<< END: _initializeNotificationChannel - initialize notification channel
}
// <<< END: PeriodicNotification - helper class

// >>> START: IOSNotificationDetails - helper class
class IOSNotificationDetails {}
// <<< END: IOSNotificationDetails - helper class
