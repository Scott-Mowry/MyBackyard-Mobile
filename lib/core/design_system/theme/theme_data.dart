import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  useMaterial3: false,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  primaryColorDark: CustomColors.redColor,
  primaryColorLight: CustomColors.primaryGreenColor,
  primaryColor: CustomColors.cyanBlueColor,
  colorScheme: const ColorScheme.light(primary: CustomColors.primaryGreenColor),

  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.black)),

  brightness: Brightness.light,
  textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.black), titleSmall: TextStyle(color: Colors.black)),
  cardColor: CustomColors.lightGreyBlue,
  canvasColor: Colors.transparent,

  hintColor: CustomColors.greenColor,
  indicatorColor: CustomColors.indicatorColor,
  disabledColor: CustomColors.white,
  hoverColor: CustomColors.white,
  dividerColor: CustomColors.greyColor,

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: CustomColors.bottomNavBackgroundColor),
  buttonTheme: const ButtonThemeData(buttonColor: Colors.blue, disabledColor: Colors.grey),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);
