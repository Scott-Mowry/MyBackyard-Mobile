import 'dart:io';

import 'package:backyard/boot.dart';
import 'package:backyard/core/design_system/theme/theme_data.dart';
import 'package:backyard/legacy/Utils/app_router.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:sizer/sizer.dart';

class MyBackyardApp extends StatelessWidget {
  const MyBackyardApp({super.key});

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final isTabletSize = shortestSide >= 600;
    final isIOS = Platform.isIOS;

    if (isIOS) return MediaQuery.sizeOf(context).width >= 768;
    return isTabletSize;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
    );
    Utils.isTablet = isTablet(context);
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
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
