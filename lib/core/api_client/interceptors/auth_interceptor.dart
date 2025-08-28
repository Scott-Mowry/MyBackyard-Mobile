import 'dart:io';

import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/core/services/auth_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  static const retryCountHeader = 'Retry-Count';

  final ApiClient _apiClient;

  LocalStorageRepository get _localStorageRepository => getIt<LocalStorageRepository>();

  const AuthInterceptor(this._apiClient);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 1.1 For protected routes, accessToken shouldn't be null. If it is, logout.
    final userCredentials = await _localStorageRepository.getUserCredentials();
    final accessToken = userCredentials?['bearer_token'];

    // 1.0 Don't add authorization header on urls that don't need authorization
    if (accessToken == null) return super.onRequest(options, handler);

    // 1.2 Proceed with original request, adding the bearer token on headers
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final reqOpts = err.requestOptions;
    final isUnauthError = err.response?.statusCode == HttpStatus.unauthorized;

    // 1.0 If public route, or not a unauthorized error, proceed without interference
    if (!isUnauthError) return super.onError(err, handler);

    // 1.1 If not a retry request, attempt to refresh the token
    // 1.2 Logout if it's a retry request or the refresh attempt was unsuccessful
    final isRetryRequest = reqOpts.headers[retryCountHeader] == 1;
    if (isRetryRequest) return getIt<AuthService>().signOut();

    // final successfulRefresh = isRetryRequest ? null : await _authRepository.refreshToken();
    // if (isRetryRequest || (successfulRefresh != null && !successfulRefresh)) {
    //   return _authRepository.logout();
    // }

    // 1.3 Retry request with the new refreshed accessToken
    reqOpts.headers[retryCountHeader] = 1;
    final resp = await _apiClient.fetch(reqOpts);

    // 1.4 If retry was successful, return the original request with the new retried response
    return handler.resolve(resp);
  }
}
