import 'package:backyard/core/exception/app_exception_codes.dart';

final uiErrorAlertsMap = {
  // Dio/Internet
  kDioTimeoutErrorKey: 'Looks like this is taking longer than expected. Please try again in a moment.',
  kCheckInternetConnectionErrorKey: 'Hmm, seems like there\'s no internet connection. Check it and try again.',

  // System errors
  kPermissionRequestErrorKey: "We don't have the permissions needed. Please check your settings.",
  kLocalStorageInitErrorKey: 'We had trouble accessing local storage. Please restart the app.',
  kConnectivityInitErrorKey: 'We had trouble connecting to the network. Please check your connection.',

  // User authentication errors
  kSignInErrorKey: 'We couldn\'t sign you in right now. Please check your credentials and try again.',
  kVerifyAccountErrorKey: 'We couldn\'t verify your account. Please check your verification code and try again.',
  kCompleteProfileErrorKey: 'We couldn\'t complete your profile setup. Please try again.',
  kResendCodeErrorKey: 'We couldn\'t resend the verification code. Please try again in a moment.',
  kForgotPasswordErrorKey: 'We couldn\'t process your password reset request. Please try again.',
  kChangePasswordErrorKey: 'We couldn\'t update your password. Please try again.',
  kSignOutErrorKey: 'We couldn\'t sign you out properly. Please try again.',
  kDeleteAccountErrorKey: 'We couldn\'t delete your account. Please try again later.',

  // In-app purchase errors
  kBuySubscriptionErrorKey: 'We couldn\'t complete your purchase. Please try again or contact support if the issue persists.',
};
