import 'dart:io';

import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/repositories/analytics_repository.dart';
import 'package:backyard/core/repositories/crash_report_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_repository.g.dart';

@singleton
class PermissionRepository = _PermissionRepository with _$PermissionRepository;

abstract class _PermissionRepository with Store {
  final CrashReportRepository _crashlyticsRepository;
  final AnalyticsRepository _analyticsRepository;

  _PermissionRepository(this._crashlyticsRepository, this._analyticsRepository);

  bool _isRequestingPermission = false;

  bool get isRequestingPermission => _isRequestingPermission;

  Future<bool> requestTrackingPermission() async {
    try {
      if (!Platform.isIOS) return true;

      _isRequestingPermission = true;
      final permStatus = await Permission.appTrackingTransparency.request();
      await _analyticsRepository.setAnalyticsCollectionEnabled(permStatus.isGranted);

      return permStatus.isGranted;
    } catch (error, stack) {
      final internalError = AppInternalError(code: kPermissionRequestErrorKey, error: error, stack: stack);
      await _crashlyticsRepository.recordError(internalError, stack);

      return false;
    } finally {
      _isRequestingPermission = false;
    }
  }

  Future<bool> requestLocationPermission() async {
    try {
      _isRequestingPermission = true;
      if (await isLocationPermGranted) return true;

      final permStatus = await Permission.locationWhenInUse.request();
      return permStatus.isGranted;
    } catch (error, stack) {
      final internalError = AppInternalError(code: kPermissionRequestErrorKey, error: error, stack: stack);
      await _crashlyticsRepository.recordError(internalError, stack);

      return false;
    } finally {
      _isRequestingPermission = false;
    }
  }

  Future<bool> get isLocationPermGranted => Permission.locationWhenInUse.isGranted;
}
