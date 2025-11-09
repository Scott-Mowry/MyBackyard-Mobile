import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/api_client/dio_helper.dart';
import 'package:backyard/core/api_client/interceptors/auth_interceptor.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/flavors.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Named(kMyBackyardApiClient)
@Injectable(as: ApiClient)
class MyBackyardApiClient extends ApiClient {
  static final baseUrl = switch (appBuildFlavor) {
    AppBuildFlavorEnum.STG => 'https://api.staging.mybackyardusa.net/api',
    AppBuildFlavorEnum.PROD => 'https://api.mybackyardusa.net/api',
  };

  static final publicUrl = switch (appBuildFlavor) {
    AppBuildFlavorEnum.STG => 'https://api.staging.mybackyardusa.net',
    AppBuildFlavorEnum.PROD => 'https://api.mybackyardusa.net',
  };

  final _connectTimeout = switch (appBuildFlavor) {
    AppBuildFlavorEnum.STG => const Duration(seconds: 20),
    _ => const Duration(seconds: 20),
  };

  final _receiveTimeout = switch (appBuildFlavor) {
    AppBuildFlavorEnum.STG => const Duration(seconds: 20),
    _ => const Duration(seconds: 20),
  };

  late final _interceptors = [AuthInterceptor(this), CurlLoggerDioInterceptor(printOnSuccess: true)];

  late final _baseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: _connectTimeout,
    receiveTimeout: _receiveTimeout,
  );

  late final Dio _dio = createDio(_baseOptions, _interceptors);

  @override
  Dio get dio => _dio;
}
