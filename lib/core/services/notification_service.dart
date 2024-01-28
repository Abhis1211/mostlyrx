import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const _channelId = 'mostlyrx_notification';
  static const _channelName = 'mostlyrx notification channel';
  static const _channelDescription = 'mostlyrx notification';
  late AndroidInitializationSettings _initializationSettingsAndroid;
  late FlutterLocalNotificationsPlugin _plugin;
  late InitializationSettings _initializationSettings;
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  NotificationService._() {
    _initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    _initializationSettings =
        InitializationSettings(android: _initializationSettingsAndroid);
    _plugin = FlutterLocalNotificationsPlugin();
  }

  void showDeleteNotification() async {
    var init = await _plugin.initialize(_initializationSettings);
    if (init == false) {
      return;
    }
    _plugin.cancelAll();
    await _plugin.show(
      Random.secure().nextInt(100),
      'Your account has been Deleted',
      'We are sorry to see you go!',
      const NotificationDetails(
          android: AndroidNotificationDetails(_channelId, _channelName,
              channelDescription: _channelDescription,
              enableLights: true,
              importance: Importance.high,
              visibility: NotificationVisibility.public)),
    );
  }
}
