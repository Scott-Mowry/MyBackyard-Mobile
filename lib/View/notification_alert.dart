// import 'package:firebase_messaging/notification_service.dart';
//
// class FirebaseMessagingService {
//   static FirebaseMessagingService? _messagingService;
//
//   static FirebaseMessaging? _firebaseMessaging;
//
//   FirebaseMessagingService._createInstance();
//
//   factory FirebaseMessagingService() {
//     // factory with constructor, return some value
//     if (_messagingService == null) {
//       _messagingService = FirebaseMessagingService._createInstance(); // This is executed only once, singleton object
//
//       _firebaseMessaging = _getMessagingService();
//     }
//     return _messagingService!;
//   }
//
//   static FirebaseMessaging _getMessagingService() {
//     return _firebaseMessaging ??= FirebaseMessaging.instance;
//   }
//
//   Future<String?> getToken() async {
//     try {
//       return await _firebaseMessaging!.getToken();
//     } catch (error) {
//       return null;
//     }
//   }
//
//   initialize() async
//   {
//     NotificationSettings settings = await _firebaseMessaging!.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
// }



// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:backyard/Controller/auth_controller.dart';
// import 'package:backyard/Model/user_model.dart';
// import 'package:backyard/Utils/local_shared_preferences.dart';
// import 'package:backyard/Utils/utils.dart';
// import 'package:backyard/main.dart';
// import '../Model/notification_model.dart';
// import '../Service/navigation_service.dart';
// import '../Utils/app_router_name.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
//   if (kDebugMode) {
//     print("Handling a background message");
//     print("_messaging onBackgroundMessage: ${message?.data}");
//   }
//   if (message != null) {
//     if (kDebugMode) {
//       print("message is not null");
//     }
//     if (navigatorKey.currentState?.context != null) {
//       if (kDebugMode) {
//         print("context is not null");
//       }
//       // BlocProvider.of<AuthenticationCubit>(MyApp.navigatorKey.currentState!.context)
//       //     .setNotificationsCount(
//       //     notificationCount: message.data['notification_count'].toString());
//     } else {
//       if (kDebugMode) {
//         print("context is null");
//       }
//     }
//   }
// }

// class FirebaseMessagingService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   IOSInitializationSettings? _initializationSettingsIOS;
//   AndroidInitializationSettings? _initializationSettingsAndroid;
//   AndroidNotificationDetails? _androidLocalNotificationDetails;
//   AndroidNotificationChannel? androidNotificationChannel;
//   static FirebaseMessagingService? _messagingService;
//   NotificationDetails? _androidNotificationDetails;
//   InitializationSettings? _initializationSettings;

//   // NotificationAppLaunchDetails? _notificationAppLaunchDetails;
//   // bool? _didNotificationLaunchApp;

//   static FirebaseMessaging? _firebaseMessaging;

//   FirebaseMessagingService._createInstance();

//   factory FirebaseMessagingService() {
//     // factory with constructor, return some value
//     if (_messagingService == null) {
//       _messagingService = FirebaseMessagingService
//           ._createInstance(); // This is executed only once, singleton object

//       _firebaseMessaging = _getMessagingService();
//     }
//     return _messagingService!;
//   }

//   static FirebaseMessaging _getMessagingService() {
//     return _firebaseMessaging ??= FirebaseMessaging.instance;
//   }

//   Future<String?> getToken() {
//     return _firebaseMessaging!.getToken();
//   }

//   Future initializeNotificationSettings() async {
//     print('initializeNotificationSettings');
//     NotificationSettings? settings =
//     await _firebaseMessaging?.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('User granted permission');
//       }
//     } else if (settings?.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('User granted provisional permission');
//       }
//     } else {
//       if (kDebugMode) {
//         print('User declined or has not accepted permission');
//       }
//     }

//     androidNotificationChannel = const AndroidNotificationChannel(
//       "bydify", // id
//       "bydify", // title
//       description: "bydify",
//       // description
//       importance: Importance.max,
//     );
//     //
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(androidNotificationChannel!);

//     //check if data comes from any link(app yaha sa start hogi)
//     //await _initUniLinks();

//     if (Platform.isIOS) {
//       //configure local notification for ios
//       await _initializeIosLocalNotificationSettings();
//     } else {
//       //configure local notification for android
//       await _initializeAndroidLocalNotificationSettings();
//     }
//   }

//   Future<void> _initializeIosLocalNotificationSettings() async {
//     _initializationSettingsIOS = const IOSInitializationSettings(
//         requestAlertPermission: false,
//         requestBadgePermission: false,
//         requestSoundPermission: false);
//     _initializationSettings =
//         InitializationSettings(iOS: _initializationSettingsIOS);

//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     await _flutterLocalNotificationsPlugin.initialize(_initializationSettings!,
//         onSelectNotification:
//         onTapLocalNotification
//     );
//   }

//   Future<void> _initializeAndroidLocalNotificationSettings() async {
//     _initializationSettingsAndroid =
//     const AndroidInitializationSettings('mipmap/ic_launcher');
//     _initializationSettings = InitializationSettings(
//       android: _initializationSettingsAndroid,
//     );
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     _androidLocalNotificationDetails = const AndroidNotificationDetails(
//         "bydify_local_1", "bydify",
//         channelDescription: "bydify",
//         importance: Importance.max,
//         priority: Priority.high);
//     _androidNotificationDetails =
//         NotificationDetails(android: _androidLocalNotificationDetails);

//     await _flutterLocalNotificationsPlugin.initialize(_initializationSettings!,
//         onSelectNotification: onTapLocalNotification);
//   }

//   //on tap local notification
//   void onTapLocalNotification(String? payload) async {
//     if (payload != null) {
//       Utils().goToNotificationRoute(context: navigatorKey.currentContext!, n: NotificationModel.fromJson(jsonDecode(payload)),isPush: true);
//     }
//   }

//   //This will execute when the app is open and in foreground
//   void foregroundNotification() {
//     //To registered firebase messaging listener only once
//     FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
//       log("Message ForeGround 1:${message?.data.toString()}");
//       log("foregroundNotification 5:${message?.notification?.body}");
//       try {
//         _showLocalNotification(
//           localNotificationId: DateTime.now().hour +
//               DateTime.now().minute +
//               DateTime.now().second,
//           notificationData: message?.data,
//           messageTitle: message?.notification?.title,
//           messageBody: message?.notification?.body,
//         );
//       } catch (error) {
//         log("error");
//       }
//     });
//     FirebaseMessaging.onMessage.listen((message) async {
//       log("Message ForeGround message:${message}");
//       onNotificationReceived(c:navigatorKey.currentState!.context,n:NotificationModel.fromJson(message.data));
//     });
//   }

//   void _showLocalNotification(
//       {int? localNotificationId,
//         Map<String, dynamic>? notificationData,
//         String? messageTitle,
//         String? messageBody}) async {
//     if (notificationData != null) {
//       log("Notification Data:${notificationData}");

//       await _flutterLocalNotificationsPlugin.show(
//           localNotificationId ?? 0,
//           notificationData["title"] ?? messageTitle,
//           notificationData["body"] ?? messageBody,
//           _androidNotificationDetails,
//           payload: jsonEncode(notificationData));
//     }
//   }

//   //This will execute when the app is in background but not killed and tap on that notification
//   void backgroundTapNotification() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
//       RemoteMessage? terminatedMessage = await _firebaseMessaging?.getInitialMessage();
//       Utils().goToNotificationRoute(context: navigatorKey.currentState,n: NotificationModel.fromJson(terminatedMessage!.data),isPush: true);
//     });
//   }

//   void terminateNotification(context) async {
//     RemoteMessage? msg = await _firebaseMessaging?.getInitialMessage();
//     NotificationNavigation(context,msg: msg);
//   }
//   void NotificationNavigation(context,{RemoteMessage? msg}){
//     log("objectsss eeees");
//     if(msg!=null){
//       Utils().goToNotificationRoute(context: navigatorKey.currentState!.context,n: NotificationModel.fromJson(msg.data),isPush: true);
//     }
//     else{
//       navigateToNextPage(context);
//     }
//   }
//   void navigateToNextPage(context) async {
//     // SharedPreference().setFcmToken(token: FirebaseMessagingService().getToken().toString());
//     if(SharedPreference().getUser() != null)
//     {
//       AuthController.i.user.value =User.fromJson(jsonDecode(SharedPreference().getUser()!));
//       Utils().setUserRole(AuthController.i.user.value.role);
//       Utils().setUserLoginType(AuthController.i.user.value.userSocialType);
//       Utils().goToRoute(context: context, user:AuthController.i.user.value,isLogin: false);
//     }
//     else{
//       AppNavigation.navigateToRemovingAll(context, AppRouteName.ROLE_SELECTION);
//     }
//   }
//   void onNotificationReceived({required BuildContext c,required NotificationModel n}) async {
//     // if(n.notificationType==AppStrings.STREAM_REQUEST_CANCELLED_NOTIFICATION){
//     //   HomeController.i.getStreaming(loading:false,context: c);
//     // }
//   }

// }