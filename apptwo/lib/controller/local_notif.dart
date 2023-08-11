import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotif {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotif) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/launcher_icon');
    var iOsInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {},
    );
    var initializeSetting =
        InitializationSettings(android: androidInitialize, iOS: iOsInitialize);

    await flutterLocalNotif.initialize(
      initializeSetting,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  static notificationdetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          "alert_notification",
          "Alerts Notification",
          channelDescription: "Receive alerts notifications",
          playSound: true,
          priority: Priority.high,
          color: Colors.red,
          sound: RawResourceAndroidNotificationSound("notification"),
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails());
  }
}
