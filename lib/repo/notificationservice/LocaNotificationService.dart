import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future<void> showProgressNotification() async {
    int id=1;
    final int progressId = id;
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails('progress channel', 'progress channel',
                channelDescription: 'progress channel description',
                // channelShowBadge: false,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: maxProgress,
                progress: i);
        final NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        await notificationsPlugin.show(
            progressId,
            'progress notification title',
            'progress notification body',
            notificationDetails,
            payload: 'item x');
      });
    }
  }

  notificationDetails(bool showProgress,int progress,int maxProgress) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          channelDescription: 'progress channel description',
          importance: Importance.max,
          priority: Priority.high,
          showProgress: true,
          onlyAlertOnce: true,
          // indeterminate: true,
          progress: progress,
          maxProgress: maxProgress,
        ));
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      int? progress,
      int? maxProgress}) async {
        NotificationDetails notification = await notificationDetails(true,progress!,maxProgress!);
    return notificationsPlugin.show(
        id, title, body,notification,payload: "Custard app");
  }

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    log('123');
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.id != null && details.payload != null) {
          log("Router value1234 ${details.payload}");
        } else {
          log("Null");
        }
      },
    );
  }

  void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "custardapp",
          "custardchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
