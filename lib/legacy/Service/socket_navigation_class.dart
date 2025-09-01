import 'dart:developer';

import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';

class SocketNavigationClass {
  static SocketNavigationClass? _instance;

  SocketNavigationClass._();

  static SocketNavigationClass? get instance {
    _instance ??= SocketNavigationClass._();
    return _instance;
  }

  Future<void> socketUserResponseMethod({dynamic responseData}) async {
    log('Socket User Response data:$responseData');
    log('User Data:$responseData');

    if (responseData != null) {
      final responseDataJson = responseData as Map<String, dynamic>;
      if (responseDataJson['object_type'] == 'get_user') {
        try {
          getIt<UserController>().setSubId(UserProfileModel.fromJson(responseDataJson['data'][0]));
        } catch (e) {
          log(e.toString());
        }
      }
    }
  }

  Future<void> socketResponseMethod({dynamic responseData}) async {
    log('Socket Response data:$responseData');
    log('Data:$responseData');

    if (responseData != null) {
      final responseDataJson = responseData as Map<String, dynamic>;
      if (responseDataJson['object_type'] == 'get_buses') {
        getIt<UserController>().clearMarkers();
        var users = <UserProfileModel>[];
        users = List<UserProfileModel>.from((responseDataJson['data'] ?? {}).map((x) => UserProfileModel.fromJson(x)));
        getIt<UserController>().setBusList(users);
        for (var user in users) {
          getIt<UserController>().addMarker(user);
        }
      }
    }
  }

  void socketErrorMethod({dynamic errorResponseData}) {
    if (errorResponseData != null) {
      log('Socket Error Response:');
      log('errorResponseData');
      log(errorResponseData.toString());
    }
  }
}
