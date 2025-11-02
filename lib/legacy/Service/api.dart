// ignore_for_file: avoid_classes_with_only_static_members

class API {
  //timeout Duraiton
  static Duration timeout = const Duration(seconds: 20);

  // Auth
  static const SIGN_IN_ENDPOINT = '/login';
  static const FORGOT_PASSWORD_ENDPOINT = '/forgotPassword';
  static const CHANGE_PASSWORD_ENDPOINT = '/changePassword';
  static const VERIFY_ACCOUNT_ENDPOINT = '/verification';
  static const COMPLETE_PROFILE_ENDPOINT = '/completeProfile';
  static const RESEND_OTP_ENDPOINT = '/re_send_code';
  static const SIGN_OUT_ENDPOINT = '/logout';
  static const DELETE_ACCOUNT_ENDPOINT = '/delete_account';
  static const USER = '/user';

  //customers
  static const GET_CUSTOMERS_ENDPOINT = '/getCustomers';

  // categories
  static const CATEGORIES_ENDPOINT = '/categories';

  // subscriptions
  static const GET_SUBSCRIPTIONS = '/v2/admin/subscriptions';

  //buses
  static const GET_BUSINESSES_ENDPOINT = '/getBuses';
  static const GET_OFFERS_ENDPOINT = '/getOffers';
  static const ADD_OFFER_ENDPOINT = '/addOffer';
  static const EDIT_OFFER_ENDPOINT = '/editOffer';
  static const DELETE_OFFER_ENDPOINT = '/deleteOffer';
  static const GET_REVIEWS_ENDPOINT = '/getReviews';
  static const POST_REVIEW_ENDPOINT = '/submitReview';
  static const AVAIL_OFFER_ENDPOINT = '/availOffer';
  static const CLAIM_OFFER_ENDPOINT = '/claimedOffer';
}
