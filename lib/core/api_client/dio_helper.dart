import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio createDio(BaseOptions opts, List<Interceptor> interceptors) {
  final dio = Dio(opts);

  dio.interceptors.addAll([if (kDebugMode) PrettyDioLogger(requestBody: true, responseHeader: true)]);

  dio.interceptors.addAll(interceptors);
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['Content-Type'] = 'application/json';

  return dio;
}
