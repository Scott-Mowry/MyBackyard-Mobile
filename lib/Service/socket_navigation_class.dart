import 'dart:developer';

import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/main.dart';
import 'package:provider/provider.dart';

class SocketNavigationClass {
  static SocketNavigationClass? _instance;

  SocketNavigationClass._();

  static SocketNavigationClass? get instance {
    _instance ??= SocketNavigationClass._();
    return _instance;
  }

  void socketUserResponseMethod({dynamic responseData}) async {
    log("Socket User Response data:$responseData");
    log("User Data:$responseData");

    if (responseData != null) {
      final responseDataJson = responseData as Map<String, dynamic>;
      if (responseDataJson["object_type"] == "get_user") {
        try {
          navigatorKey.currentContext?.read<UserController>().setSubId(User.setUser(responseDataJson["data"][0]));
        } catch (e) {
          log(e.toString());
        }
      }
    }
  }

  void socketResponseMethod({dynamic responseData}) async {
    log("Socket Response data:$responseData");
    log("Data:$responseData");

    if (responseData != null) {
      final responseDataJson = responseData as Map<String, dynamic>;
      if (responseDataJson["object_type"] == "get_buses") {
        navigatorKey.currentContext?.read<UserController>().clearMarkers();
        List<User> users = [];
        users = List<User>.from((responseDataJson["data"] ?? {}).map((x) => User.setUser(x)));
        navigatorKey.currentContext?.read<UserController>().setBusList(users);
        for (var user in users) {
          navigatorKey.currentContext?.read<UserController>().addMarker(user);
        }
      }
    }
  }

  void socketErrorMethod({dynamic errorResponseData}) {
    if (errorResponseData != null) {
      log("Socket Error Response:");
      log("errorResponseData");
      log(errorResponseData.toString());
    }
  }
}
