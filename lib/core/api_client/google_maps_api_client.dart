import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/api_client/dio_helper.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/flavors.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Named(kGoogleMapsApiClient)
@Injectable(as: ApiClient)
class GoogleMapsApiClient extends ApiClient {
  static final baseUrl = switch (appBuildFlavor) {
    AppBuildFlavorEnum.STG => 'https://maps.googleapis.com/maps/api',
    AppBuildFlavorEnum.PROD => 'https://maps.googleapis.com/maps/api',
  };

  final _connectTimeout = switch (appBuildFlavor) {
    AppBuildFlavorEnum.STG => const Duration(seconds: 10),
    _ => const Duration(seconds: 10),
  };

  final _receiveTimeout = switch (appBuildFlavor) {
    AppBuildFlavorEnum.STG => const Duration(seconds: 10),
    _ => const Duration(seconds: 10),
  };

  late final _interceptors = [CurlLoggerDioInterceptor(printOnSuccess: true)];

  late final _baseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: _connectTimeout,
    receiveTimeout: _receiveTimeout,
  );

  late final Dio _dio = createDio(_baseOptions, _interceptors);

  @override
  Dio get dio => _dio;
}
