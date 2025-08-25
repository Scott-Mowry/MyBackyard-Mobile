import 'package:backyard/core/exception/app_exception_codes.dart';

final uiErrorAlertsMap = {
  // Dio/Internet
  kDioTimeoutErrorKey: 'Looks like this is taking longer than expected. Please try again in a moment.',
  kCheckInternetConnectionErrorKey: 'Hmm, seems like there\'s no internet connection. Check it and try again.',

  // System errors
  kPermissionRequestErrorKey: "We don't have the permissions needed. Please check your settings.",
  kLocalStorageInitErrorKey: 'We had trouble accessing local storage. Please restart the app.',
  kConnectivityInitErrorKey: 'We had trouble connecting to the network. Please check your connection.',
};
