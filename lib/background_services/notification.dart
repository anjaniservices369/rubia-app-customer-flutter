// =============================================================================
// WHAT : INACTIVE: whole file is commented out (old local-notification helper).
// NOTES: Safe to delete.
// =============================================================================
// // notification.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   NotificationService(this.flutterLocalNotificationsPlugin);
//
//   Future<void> createChannel(
//       AndroidNotificationChannel notificationChannel) async {
//     return await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(notificationChannel);
//   }
//
//   void foregroundNotificationTap(NotificationResponse details) {
//     print("*******************LOCAL FOREGROUND RECEIVED********************");
//     // Additional logic when a foreground notification is tapped
//   }
//
//   @pragma('vm:entry-point')
//   static void backgroundNotificationTap(NotificationResponse details) {
//     print("*******************LOCAL BACKGROUND RECEIVED********************");
//     // Additional logic when a background notification is tapped
//   }
//
//   Future initialize(BuildContext context) async {
//     AndroidInitializationSettings androidInitializationSettings =
//     const AndroidInitializationSettings('launch_background');
//
//     DarwinInitializationSettings darwinInitializationSettings =
//     const DarwinInitializationSettings();
//
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: darwinInitializationSettings,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: foregroundNotificationTap,
//       onDidReceiveBackgroundNotificationResponse: backgroundNotificationTap,
//     );
//   }
//
//   Future showNotification({
//     int showNotificationId = 0,
//     required AndroidNotificationDetails androidNotificationDetails,
//     String? title,
//     String? body,
//     String? payload,
//   }) async {
//     var platformChannelSpecifics =
//     NotificationDetails(android: androidNotificationDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       showNotificationId,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: payload,
//     );
//   }
// }
