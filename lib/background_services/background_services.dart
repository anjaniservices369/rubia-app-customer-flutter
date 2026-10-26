// =============================================================================
// WHAT : INACTIVE: whole file is commented out (an old background-service
//        experiment).
// NOTES: Safe to delete.
// =============================================================================
// // background_services.dart
// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'notification.dart';
//
// const String notificationChannelId = "foreground_service";
// const int foregroundServiceNotificationId = 888;
// const String initialNotificationTitle = "Driver Arrived";
// const String initialNotificationContent =
//     "Please Share your OTP otherwise your ride will be cancelled in 15 minutes";
// late Timer? timerService;
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   NotificationService notificationService =
//   NotificationService(flutterLocalNotificationsPlugin);
//
//
//   // Start periodic notifications every 30 seconds
//   timerService = Timer.periodic(const Duration(seconds: 30), (timer) {
//     notificationService.showNotification(
//       showNotificationId: foregroundServiceNotificationId,
//       title: "Periodic Notification",
//       body: "This is a periodic notification every 30 seconds",
//       payload: "periodic_notification",
//       androidNotificationDetails: const AndroidNotificationDetails(
//         notificationChannelId,
//         notificationChannelId,
//         channelShowBadge: true,
//         playSound: true,
//         sound: RawResourceAndroidNotificationSound('noti'),
//         enableVibration: true,
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: 'launch_background',
//       ),
//     );
//   });
//
//   service.on('invoke').listen((event) async {
//     print("Service invoked");
//     // Additional logic when service is invoked
//   });
//
//   service.on("stop_service").listen((event) async {
//     // Stop the periodic notifications timer
//     timerService?.cancel();
//
//     // Clean up and stop the service
//     await service.stopSelf();
//   });
// }
//
// class BackgroundService {
//   final FlutterBackgroundService flutterBackgroundService =
//   FlutterBackgroundService();
//
//   FlutterBackgroundService get instance => flutterBackgroundService;
//
//   Future<void> initializeService() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//     NotificationService notificationService =
//     NotificationService(flutterLocalNotificationsPlugin);
//
//     await notificationService.createChannel(
//       const AndroidNotificationChannel(
//         notificationChannelId,
//         notificationChannelId,
//       ),
//     );
//     await flutterBackgroundService.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: false,
//         isForegroundMode: true,
//         notificationChannelId: notificationChannelId,
//         foregroundServiceNotificationId: foregroundServiceNotificationId,
//         initialNotificationTitle: initialNotificationTitle,
//         initialNotificationContent: initialNotificationContent,
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//       ),
//     );
//     await flutterBackgroundService.startService();
//   }
//
//   void setServiceAsForeground() async {
//     flutterBackgroundService.invoke('setAsForeground');
//   }
//
//   void stopService() {
//     flutterBackgroundService.invoke('stop_service');
//   }
// }
