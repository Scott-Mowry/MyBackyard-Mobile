import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'analytics_repository.g.dart';

@singleton
class AnalyticsRepository = _AnalyticsRepository with _$AnalyticsRepository;

abstract class _AnalyticsRepository with Store {
  final FirebaseAnalytics _analytics;

  const _AnalyticsRepository(this._analytics);

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

  Future<void> setUserCredentialsInfoProperties(Map<String, dynamic> userCredentials) async {
    await _analytics.setUserId(id: userCredentials['id']);
  }

  // Future<void> _setUserProperty({required String name, required String? value}) async {
  //   if (value == null) return;
  //   return _analytics.setUserProperty(name: name, value: value);
  // }
}
