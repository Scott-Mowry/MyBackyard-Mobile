import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@module
abstract class ThirdPartyModulesRegister {
  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @singleton
  FirebaseAnalytics get firebaseAnalytics => FirebaseAnalytics.instance;

  @singleton
  FirebaseCrashlytics get firebaseCrashlytics => FirebaseCrashlytics.instance;

  @singleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @singleton
  FlutterLocalNotificationsPlugin get localNotifications => FlutterLocalNotificationsPlugin();

  @singleton
  InternetConnection get internetConnection => InternetConnection();
}
