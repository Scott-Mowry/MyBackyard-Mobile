import 'dart:io';

import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/theme_data.dart';
import 'package:backyard/core/helper/custom_navigator_observer.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:sizer/sizer.dart';

class MyBackyardApp extends StatelessWidget {
  MyBackyardApp({super.key});

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final isTabletSize = shortestSide >= 600;
    final isIOS = Platform.isIOS;

    if (isIOS) return MediaQuery.sizeOf(context).width >= 768;
    return isTabletSize;
  }

  // don't initiate the router inside of the build function.
  static final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
    );

    Utils.isTablet = isTablet(context);
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: lightTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
          title: 'My Backyard',
          locale: const Locale('en', 'US'),
          builder: EasyLoading.init(
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);
              final scale = mediaQueryData.textScaler.clamp(
                minScaleFactor: 1.0,
                maxScaleFactor: defaultTargetPlatform == TargetPlatform.android ? 1.2 : 1.4,
              );
              return MediaQuery(data: mediaQueryData.copyWith(textScaler: scale), child: child!);
            },
          ),
          routerConfig: appRouter.config(navigatorObservers: () => [getIt<CustomNavigatorObserver>()]),
        );
      },
    );
  }
}
