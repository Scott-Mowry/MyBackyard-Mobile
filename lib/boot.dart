import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/exception/exception_handler.dart';
import 'package:backyard/core/firebase_options/firebase_options.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/app_in_app_purchase.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
        await initDependencies();
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

        final providersList = [
          ChangeNotifierProvider(create: (context) => getIt<UserController>()),
          ChangeNotifierProvider(create: (context) => getIt<HomeController>()),
        ];

        runApp(MultiProvider(providers: providersList, child: MyBackyardApp()));
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
    ..indicatorColor = CustomColors.primaryGreenColor
    ..progressColor = CustomColors.primaryGreenColor
    ..textColor = CustomColors.black
    ..textPadding = CustomSpacer.top.md
    ..textStyle = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black)
    ..boxShadow = [const BoxShadow(color: Colors.transparent)]
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 35.0
    ..radius = 10.0
    ..maskColor = CustomColors.grey.withValues(alpha: 0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}
