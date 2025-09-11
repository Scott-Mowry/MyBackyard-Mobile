// ignore_for_file: avoid_classes_with_only_static_members

class API {
  /// [url] : Base url for apis.
  static String url = 'https://admin.mybackyardusa.com/public/api';
  static String publicUrl = 'https://admin.mybackyardusa.com/public/';

  //timeout Duraiton
  static Duration timeout = const Duration(seconds: 20);

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
  static const GET_BUSINESSES_ENDPOINT = '/getBuses';
  static const GET_OFFERS_ENDPOINT = '/getOffers';
  static const ADD_OFFETS_ENDPOINT = '/addOffer';
  static const EDIT_OFFETS_ENDPOINT = '/editOffer';
  static const DELETE_OFFETS_ENDPOINT = '/deleteOffer';
  static const GET_REVIEWS_ENDPOINT = '/getReviews';
  static const POST_REVIEW_ENDPOINT = '/submitReview';
  static const AVAIL_OFFER_ENDPOINT = '/availOffer';
  static const CLAIM_OFFER_ENDPOINT = '/claimedOffer';

  //**End points**//
}
