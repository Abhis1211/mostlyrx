import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'globals.dart';

class FirebaseService {
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'mostlyrx', // id
      'mostlyrx Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
      enableVibration: false,
      sound: RawResourceAndroidNotificationSound('notification'),
      playSound: false);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<FlutterLocalNotificationsPlugin> initLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new DarwinInitializationSettings();

    var initializationsSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);
    _requestFCMPermissions();
    _requestLocalNotiPermissions();
    return flutterLocalNotificationsPlugin;
  }

  static onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {}

  void showNotifications(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    print("noti shown");
    flutterLocalNotificationsPlugin.show(
      0,
      message.data["alert"],
      "",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.max,
          playSound: false,
          enableVibration: false,
          sound: RawResourceAndroidNotificationSound('notification'),
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> initFirebaseMessaging() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onMessage.listen((event) {
      // showNotifications(event);
    });
    /*await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );*/
  }

  void _requestFCMPermissions() {
    FirebaseMessaging.instance.requestPermission(
      provisional: true,
      criticalAlert: true,
      announcement: true,
      carPlay: true,
    );
  }

  void _requestLocalNotiPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
