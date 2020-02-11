import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void registerNotification() {
  firebaseMessaging.requestNotificationPermissions();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      showNotification(message['notification']);
    },
    onBackgroundMessage: _reportBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      return;
    },
    onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      return;
    },
  );
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

// ignore: missing_return
Future<dynamic> _reportBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    print("[Background Message] data: $data");
    showNotification(message['data']);
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
    print("[Background Message] notification: $notification");
  }
}

void configLocalNotification() {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon_round');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  _flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification(message) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'np.com.naxa.open_space_portal',
    'Chat Alerts',
    'Notification for chats',
    playSound: true,
    enableVibration: true,
    importance: Importance.Max,
    priority: Priority.High,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await _flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
      message['body'].toString(), platformChannelSpecifics,
      payload: json.encode(message));
}
