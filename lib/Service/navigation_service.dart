import 'package:backyard/main.dart';
import 'package:flutter/material.dart';

class AppNavigation {
  AppNavigation._();
  static void navigateToRemovingAll(String routeName,
      {Object? arguments}) async {
    Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, routeName,
        (Route<dynamic> route) => false,
        arguments: arguments);
  }

  static void navigateTo(String routeName, {Object? arguments}) async {
    Navigator.pushNamed(navigatorKey.currentContext!, routeName,
        arguments: arguments);
  }

  static void navigateReplacementNamed(String routeName,
      {Object? arguments}) async {
    Navigator.pushReplacementNamed(navigatorKey.currentContext!, routeName,
        arguments: arguments);
  }

  static void navigatorPop() {
    Navigator.pop(navigatorKey.currentContext!);
  }

  static void navigateCloseDialog() async {
    Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
  }
}
