import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../src/app_shared.dart';

Future<void> handleBackgroundMessage(RemoteMessage remoteMessage) async {
  log(remoteMessage.data['title']);
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: 'important notifications', importance: Importance.max);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initFCM() async {
    try {
      await _firebaseMessaging.requestPermission(
          alert: true,
          sound: true,
          badge: true,
          announcement: true,
          carPlay: true,
          criticalAlert: true,
          provisional: true);
      final fCMToken = await _firebaseMessaging.getToken();
      if (AppShared.localStorage!.getBool('subs') == true ||
          AppShared.localStorage!.getBool('subs') == null) {
        await _firebaseMessaging.subscribeToTopic('all');
      }

      AppShared.localStorage?.setString("token", "$fCMToken");
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      FirebaseMessaging.onMessage.listen((event) {
        final notification = event.notification;
        if (notification == null) return;
        _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    importance: Importance.max,
                    priority: Priority.high,
                    _androidChannel.id,
                    _androidChannel.name,
                    channelDescription: _androidChannel.description,
                    icon: '@mipmap/ic_launcher')));
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
