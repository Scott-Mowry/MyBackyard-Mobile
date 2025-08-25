import 'dart:developer';

import 'package:backyard/core/constants/ui_error_alerts.dart';
import 'package:backyard/core/dependencies/error_handler_context_locator.dart';
import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

void handleAppInternalError(AppInternalError exception) {
  final message = uiErrorAlertsMap[exception.code];
  return message == null || message.isEmpty ? null : _showErrorMessage(message);
}

void handleUnexpectedDioException(DioException error, StackTrace? stack) {
  switch (error.type) {
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionTimeout:
      return handleAppInternalError(const AppInternalError(code: kDioTimeoutErrorKey));
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
      return handleAppInternalError(const AppInternalError(code: kCheckInternetConnectionErrorKey));
    default:
      return;
  }
}

void reportFlutterErrorDetails(FlutterErrorDetails flutterErrorDetails) {
  const errors = <String>['rendering library', 'widgets library'];

  final isSilentOnRelease = kReleaseMode && flutterErrorDetails.silent;
  final isLibraryOnDebug = !kReleaseMode && errors.contains(flutterErrorDetails.library);
  if (isSilentOnRelease || isLibraryOnDebug) {
    log(
      flutterErrorDetails.exceptionAsString(),
      name: 'ReportErrorDetails',
      stackTrace: flutterErrorDetails.stack,
      error: flutterErrorDetails.exception,
    );
  }

  final exception = flutterErrorDetails.exception;
  final errorDetails =
      exception is AppInternalError
          ? FlutterErrorDetails(
            exception: exception.error ?? flutterErrorDetails.exception,
            stack: exception.stack ?? flutterErrorDetails.stack,
          )
          : flutterErrorDetails;

  FlutterError.presentError(errorDetails);
  return reportErrorToUI(flutterErrorDetails.exception, flutterErrorDetails.stack);
}

void reportErrorToUI(Object error, StackTrace? stackTrace) {
  if (error is DioException) return handleUnexpectedDioException(error, stackTrace);
  if (error is AppInternalError) return handleAppInternalError(error);
}

void _showErrorMessage(String message) {
  final context = getGlobalErrorHandlerContext();
  return showSnackbar(context: context, content: message);
}
