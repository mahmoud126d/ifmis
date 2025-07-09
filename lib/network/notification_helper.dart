import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static _checkPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      Permission.notification.request();
    }
  }

  static init(BuildContext context) async {
    _checkPermission();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final String? payload = response.payload;
        if (payload != null) {
          Map<String, dynamic> data = jsonDecode(payload);
          handleNotificationClick(context, data);
        }
      },
    );
  }

  static Future<void> showNotification(RemoteMessage event) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      event.notification?.title,
      event.notification?.body,
      notificationDetails,
      payload: jsonEncode(event.data),
    );
  }

  static handleNotificationClick(
      BuildContext context, Map<String, dynamic> data) {
    debugPrint('notification payload: $data');
  }
}
