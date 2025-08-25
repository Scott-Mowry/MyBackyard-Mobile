import 'dart:async';
import 'dart:convert';

import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/helper/target_platform_helper.dart';
import 'package:backyard/flavors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'push_notifications_repository.g.dart';

@singleton
class PushNotificationsRepository = _PushNotificationsRepository with _$PushNotificationsRepository;

abstract class _PushNotificationsRepository with Store {
  @visibleForTesting
  static const appIconFilename = 'ic_launcher_foreground';

  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  _PushNotificationsRepository(this._firebaseMessaging, this._localNotifications);

  final _androidNotificationDetails =
      defaultTargetPlatform == TargetPlatform.android
          ? AndroidNotificationDetails(
            '${appBuildFlavor.androidBundleName}.notifications',
            '${appBuildFlavor.androidBundleName}.notifications',
            icon: appIconFilename,
            largeIcon: DrawableResourceAndroidBitmap(appIconFilename),
            visibility: NotificationVisibility.public,
            category: AndroidNotificationCategory.social,
            fullScreenIntent: false,
          )
          : null;

  final _darwinNotificationDetails =
      defaultTargetPlatform == TargetPlatform.iOS
          ? DarwinNotificationDetails(
            presentSound: true,
            presentAlert: true,
            threadIdentifier: '${appBuildFlavor.androidBundleName}.notifications',
          )
          : null;

  late final _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _darwinNotificationDetails,
  );

  Future<void> init() async {
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(onForegroundMessage);
      _firebaseMessaging.onTokenRefresh.listen((_) => subscribeToTopic(kFcmTopicAll));

      const initSettingsAndroid = AndroidInitializationSettings(appIconFilename);
      const initSettingsIOS = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: initSettingsAndroid, iOS: initSettingsIOS);

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
    } catch (error, stack) {
      throw AppInternalError(code: kPushNotificationsInitErrorKey, error: error, stack: stack);
    }
  }

  Future<String?> getFcmDeviceToken() async {
    for (var i = 1; i <= 3; i++) {
      try {
        await Future.delayed(Duration(seconds: i));
        final deviceToken = await _firebaseMessaging.getToken();

        if (deviceToken != null) return deviceToken;
      } catch (_) {}
    }

    return null;
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      if (kDebugMode) print('[PushNotificationsRepository] subscribeToTopic: $topic');
      await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

      if (defaultTargetPlatform.isIOS && !(await hasIOSApnsToken())) return;

      return _firebaseMessaging.subscribeToTopic(topic);
    } catch (error, stack) {
      throw AppInternalError(code: kSubscribeToFcmTopicErrorKey, error: error, stack: stack);
    }
  }

  @visibleForTesting
  Future<bool> hasIOSApnsToken() async {
    String? apnsToken;
    for (var i = 1; i <= 3; i++) {
      try {
        await Future.delayed(Duration(seconds: i));
        apnsToken = await _firebaseMessaging.getAPNSToken();
      } catch (_) {}
      if (apnsToken != null) break;
    }

    return apnsToken != null;
  }

  @visibleForTesting
  Future<void> onForegroundMessage(RemoteMessage message) async {
    final msgNotification = message.notification;
    if (msgNotification == null) return;

    if (defaultTargetPlatform.isAndroid) {
      return _localNotifications.show(
        0,
        msgNotification.title,
        msgNotification.body,
        _notificationDetails,
        payload: jsonEncode(message.data),
      );
    }
  }

  @visibleForTesting
  Future<void> onDidReceiveNotificationResponse(NotificationResponse details) async {
    // var payload = <String, dynamic>{};
    // try {
    //   payload = jsonDecode(details.payload ?? '');
    // } catch (_) {}
    //
    // return onNotificationTapped(payload);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
