import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/exception/exception_handler.dart';
import 'package:backyard/core/firebase_options/firebase_options.dart';
import 'package:backyard/legacy/Controller/state_management.dart';
import 'package:backyard/legacy/Service/app_in_app_purchase.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> boot() async {
  return runZonedGuarded(
    () async {
      {
        configLoading();
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(options: currentFirebasePlatform);

        await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
        );

        injectDependencies();
        FlutterError.onError = (details) async {
          reportFlutterErrorDetails(details);
          return crashReportRepository.recordError(details.exception, details.stack);
        };

        if (!kIsWeb) {
          Isolate.current.addErrorListener(
            RawReceivePort((pair) async {
              final List<dynamic> errorAndStacktrace = pair;
              final stackTrace = StackTrace.fromString(errorAndStacktrace.last.toString());
              return crashReportRepository.recordError(errorAndStacktrace.first, stackTrace);
            }).sendPort,
          );
        }

        await AppInAppPurchase().initialize();
        await ScreenUtil.ensureScreenSize();
        HttpOverrides.global = MyHttpOverrides();

        runApp(MultiProvider(providers: StateManagement.providersList, child: const MyBackyardApp()));
      }
    },
    (error, stack) async {
      if (kDebugMode) debugPrint('Unhandled Error: $error StackTrace: $stack');
      reportErrorToUI(error, stack);
      return crashReportRepository.recordError(error, stack);
    },
  );
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..backgroundColor = Colors.transparent
    ..indicatorColor = const Color(0xffB4B4B4)
    ..textColor = Colors.transparent
    ..boxShadow = [const BoxShadow(color: Colors.transparent)]
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 35.0
    ..radius = 10.0
    ..maskColor =
        Colors
            .transparent //.withValues(alpha: 0.6)
    ..userInteractions = false
    ..dismissOnTap = false;
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}
