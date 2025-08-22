import 'dart:io';

import 'package:backyard/legacy/Controller/state_management.dart';
import 'package:backyard/legacy/Service/app_in_app_purchase.dart';
import 'package:backyard/legacy/Service/firebase_options.dart';
import 'package:backyard/legacy/Utils/app_router.dart';
import 'package:backyard/legacy/Utils/my_colors.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

BitmapDescriptor pin = BitmapDescriptor.defaultMarker;

void main() async {
  configLoading();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppInAppPurchase().initialize();
  await ScreenUtil.ensureScreenSize();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(providers: StateManagement.providersList, child: const MyApp()));
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final isTabletSize = shortestSide >= 600;
    final isIOS = Platform.isIOS;

    if (isIOS) {
      // On iPad, the screen width is usually 768 or more
      return MediaQuery.sizeOf(context).width >= 768;
    }

    return isTabletSize;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
    );
    Utils.isTablet = isTablet(context); //MediaQuery.sizeOf(context).shortestSide >= 600;
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          navigatorKey: navigatorKey,
          darkTheme: lightTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
          title: 'My Backyard',
          locale: const Locale('en', 'US'),
          builder: EasyLoading.init(),
          // home: HomePage(),
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}
