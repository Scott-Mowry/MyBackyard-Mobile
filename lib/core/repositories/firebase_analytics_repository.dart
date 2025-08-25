import 'dart:developer';

import 'package:backyard/core/model/jwt_user_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'firebase_analytics_repository.g.dart';

@singleton
class FirebaseAnalyticsRepository = _FirebaseAnalyticsRepository with _$FirebaseAnalyticsRepository;

abstract class _FirebaseAnalyticsRepository with Store {
  final FirebaseAnalytics _analytics;

  const _FirebaseAnalyticsRepository(this._analytics);

  Future<void> logScreenViewEvent(String? screenName) async {
    if (screenName == null) return;
    if (kDebugMode) log('[FirebaseAnalyticsRepository] - logScreenViewEvent - $screenName');
    return _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logEvent(String eventName) async {
    return _analytics.logEvent(name: eventName);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setAnalyticsCollectionEnabled(bool enabled) {
    return _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  Future<void> setJwtUserInfoProperties(JwtUserInfo jwtUserInfo) async {
    await _analytics.setUserId(id: jwtUserInfo.userId);
    await _setUserProperty(name: 'roleId', value: jwtUserInfo.roleId);
    await _setUserProperty(name: 'roleType', value: jwtUserInfo.roleType.name);
  }

  Future<void> _setUserProperty({required String name, required String? value}) async {
    if (value == null) return;
    return _analytics.setUserProperty(name: name, value: value);
  }
}
