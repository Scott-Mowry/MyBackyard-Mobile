import 'dart:async';

import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobx/mobx.dart';

part 'connectivity_repository.g.dart';

@singleton
class ConnectivityRepository = _ConnectivityRepository with _$ConnectivityRepository;

abstract class _ConnectivityRepository with Store {
  final InternetConnection _internetConnection;

  _ConnectivityRepository(this._internetConnection);

  @observable
  bool hasInternetAccess = true;

  @action
  Future<void> init() async {
    try {
      hasInternetAccess = await _internetConnection.hasInternetAccess;
      _internetConnection.onStatusChange.listen(onInternetConnectionStatusChanged);
    } catch (error, stack) {
      throw AppInternalError(code: kConnectivityInitErrorKey, error: error, stack: stack);
    }
  }

  @action
  Future<void> onInternetConnectionStatusChanged(InternetStatus internetStatus) async {
    if (kDebugMode) print('[ConnectivityRepository] onInternetConnectionStatusChanged $internetStatus');
    hasInternetAccess = internetStatus == InternetStatus.connected;
  }

  Future<bool> checkInternetAccess() => _internetConnection.hasInternetAccess;
}
