import 'dart:io';

import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/dependencies/error_handler_context_locator.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/theme_data.dart';
import 'package:backyard/core/helper/custom_navigator_observer.dart';
import 'package:backyard/core/repositories/connectivity_repository.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
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
              registerGlobalErrorHandlerContext(context);
              final mediaQueryData = MediaQuery.of(context);
              final scale = mediaQueryData.textScaler.clamp(
                minScaleFactor: 1.0,
                maxScaleFactor: defaultTargetPlatform == TargetPlatform.android ? 1.2 : 1.4,
              );
              return MediaQuery(
                data: mediaQueryData.copyWith(textScaler: scale),
                child: GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  child: Observer(
                    builder: (context) {
                      final connectivityRepository = getIt<ConnectivityRepository>();
                      return Column(
                        children: [
                          Expanded(child: child!),
                          if (!connectivityRepository.hasInternetAccess)
                            Material(
                              child: Container(
                                padding: CustomSpacer.all.md + CustomSpacer.bottom.xs,
                                width: double.infinity,
                                color: CustomColors.lightGreyColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: CustomSpacer.right.xs,
                                      child: Icon(Icons.warning_amber_rounded, color: CustomColors.blackLight),
                                    ),
                                    Text(
                                      'No internet connection...',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
          routerConfig: appRouter.config(navigatorObservers: () => [getIt<CustomNavigatorObserver>()]),
        );
      },
    );
  }
}
