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
    AppBuildFlavorEnum.STG => 'https://admin.mybackyardusa.com/public/api',
    AppBuildFlavorEnum.PROD => 'https://admin.mybackyardusa.com/public/api',
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

class MyBackyardApiEndpoints {
  static const timeout = Duration(seconds: 20);

  static const apiUrl = 'https://admin.mybackyardusa.com/public/api';
  static const public_url = 'https://admin.mybackyardusa.com/public/';
  static const sockerUrl = 'https://admin.mybackyardusa.com:3000';

  static const CONTENT_ENDPOINT = '/content';

  // Auth
  static const SIGN_IN_ENDPOINT = '/login';
  static const SIGN_IN_WITH_ID_ENDPOINT = '/loginWithId';
  static const FORGOT_PASSWORD_ENDPOINT = '/forgotPassword';
  static const CHANGE_PASSWORD_ENDPOINT = '/changePassword';
  static const VERIFY_ACCOUNT_ENDPOINT = '/verification';
  static const COMPLETE_PROFILE_ENDPOINT = '/completeProfile';
  static const RESEND_OTP_ENDPOINT = '/re_send_code';
  static const SIGN_OUT_ENDPOINT = '/logout';
  static const SOCIAL_LOGIN_ENDPOINT = '/socialLogin';
  static const DELETE_ACCOUNT_ENDPOINT = '/delete_account';

  //customers
  static const GET_CUSTOMERS_ENDPOINT = '/getCustomers';

  // categories
  static const CATEGORIES_ENDPOINT = '/categories';

  // places
  static const PLACES_ENDPOINT = '/places';

  //buses
  static const GET_BUSES_ENDPOINT = '/getBuses';
  static const GET_OFFERS_ENDPOINT = '/getOffers';
  static const ADD_OFFETS_ENDPOINT = '/addOffer';
  static const EDIT_OFFETS_ENDPOINT = '/editOffer';
  static const DELETE_OFFETS_ENDPOINT = '/deleteOffer';
  static const GET_REVIEWS_ENDPOINT = '/getReviews';
  static const POST_REVIEW_ENDPOINT = '/submitReview';
  static const AVAIL_OFFER_ENDPOINT = '/availOffer';
  static const CLAIM_OFFER_ENDPOINT = '/claimedOffer';
}
