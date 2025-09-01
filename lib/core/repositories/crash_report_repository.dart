import 'dart:io';

import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'crash_report_repository.g.dart';

@singleton
class CrashReportRepository = _CrashReportRepository with _$CrashReportRepository;

abstract class _CrashReportRepository with Store {
  final FirebaseCrashlytics _crashlytics;

  const _CrashReportRepository(this._crashlytics);

  bool isKnownError(Object error) => error is AppInternalError || error is DioException;

  Future<void> recordError(dynamic exception, StackTrace? stack, {bool? fatal}) async {
    if (kIsWeb) return;
    if (isImage403HttpException(exception)) return;
    if (exception is AppInternalError) {
      return _crashlytics.recordError(
        exception.error ?? exception,
        exception.stack ?? stack,
        reason: exception.code,
        fatal: fatal ?? false,
      );
    }

    return _crashlytics.recordError(exception, stack, fatal: fatal ?? !isKnownError(exception));
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    if (kIsWeb) return;
    return _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  Future<void> setUserInfoProperties(UserProfileModel user) async {
    if (kIsWeb) return;
    if (user.id != null) await _crashlytics.setUserIdentifier(user.id!.toString());
    await _setCustomKey(key: 'role', value: user.role?.name.toLowerCase());
    await _setCustomKey(key: 'name', value: user.name);
    await _setCustomKey(key: 'email', value: user.email);
  }

  Future<void> _setCustomKey({required String key, required String? value}) async {
    if (value == null) return;
    return _crashlytics.setCustomKey(key, value);
  }
}

bool isImage403HttpException(dynamic exception) {
  return exception is HttpException && exception.message == kInvalidStatusCode403HttpExceptionMsg;
}
