import 'package:backyard/features/change_password/change_password_view.dart';
import 'package:backyard/features/change_password/forgot_password_view.dart';
import 'package:backyard/features/landing/landing_view.dart';
import 'package:backyard/features/notifications/notifications_view.dart';
import 'package:backyard/features/sign_in/sign_in_view.dart';
import 'package:backyard/features/time_schedule/time_schedule_edit_view.dart';
import 'package:backyard/legacy/Arguments/content_argument.dart';
import 'package:backyard/legacy/Arguments/profile_screen_arguments.dart';
import 'package:backyard/legacy/Arguments/screen_arguments.dart';
import 'package:backyard/legacy/Service/url_launcher.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/View/Authentication/business_category.dart';
import 'package:backyard/legacy/View/Authentication/enter_otp.dart';
import 'package:backyard/legacy/View/Authentication/profile_setup.dart';
import 'package:backyard/legacy/View/Authentication/schedule.dart';
import 'package:backyard/legacy/View/Business/create_offer.dart';
import 'package:backyard/legacy/View/Common/Settings/settings.dart';
import 'package:backyard/legacy/View/Common/customer_profile.dart';
import 'package:backyard/legacy/View/Common/subscription.dart';
import 'package:backyard/legacy/View/Common/user_profile.dart';
import 'package:backyard/legacy/View/Payment/add_card.dart';
import 'package:backyard/legacy/View/User/discount_offers.dart';
import 'package:backyard/legacy/View/User/give_review.dart';
import 'package:backyard/legacy/View/User/scan_qr.dart';
import 'package:backyard/legacy/View/User/search_result.dart';
import 'package:backyard/legacy/View/home_view.dart';
import 'package:flutter/material.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  return MaterialPageRoute(
    settings: routeSettings,
    builder: (context) {
      switch (routeSettings.name) {
        case AppRouteName.LANDING_VIEW_ROUTE:
          return LandingView();
        case AppRouteName.LOGIN_VIEW_ROUTE:
          return SignInView();
        case AppRouteName.TIME_SCHEDULE_EDIT_VIEW_ROUTE:
          final arg = routeSettings.arguments as TimeSchedulingEditArgs?;
          return TimeScheduleEditView(val: arg?.val, multiSelect: arg?.multiSelect);
        case AppRouteName.CHANGE_PASSWORD_VIEW_ROUTE:
          final arg = routeSettings.arguments as ChangePasswordViewArgs?;
          return ChangePasswordView(fromSettings: arg?.fromSettings);
        case AppRouteName.FORGET_PASSWORD_VIEW_ROUTE:
          return const ForgotPasswordView();
        case AppRouteName.ENTER_OTP_VIEW_ROUTE:
          final arg = routeSettings.arguments as EnterOTPArguements?;
          return EnterOTP(
            phoneNumber: arg?.phoneNumber ?? '',
            verification: arg?.verification,
            fromForgot: arg?.fromForgot,
          );
        case AppRouteName.SCHEDULE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return Schedule(edit: arg?.fromEdit ?? false, args: arg?.args);
        case AppRouteName.CATEGORY_VIEW_ROUTE:
          return Category();

        case AppRouteName.COMPLETE_PROFILE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return ProfileSetup(editProfile: arg?.fromEdit ?? false);
        case AppRouteName.HOME_VIEW_ROUTE:
          return HomeView();
        case AppRouteName.SCAN_QR_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return ScanQR(fromOffer: arg?.fromOffer ?? false);
        case AppRouteName.DISCOUNT_OFFER_VIEW_ROUTE:
          final arg = routeSettings.arguments as DiscountOffersArguments?;
          return DiscountOffers(model: arg?.model, fromSaved: arg?.fromSaved);
        case AppRouteName.SEARCH_RESULT_VIEW_ROUTE:
          final arg = routeSettings.arguments as SearchResultArguments?;
          return SearchResult(categoryId: arg?.categoryId);
        case AppRouteName.GIVE_REVIEW_VIEW_ROUTE:
          final arg = routeSettings.arguments as GiveReviewArguments?;
          return GiveReview(busId: arg?.busId);
        case AppRouteName.CREATE_OFFER_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return CreateOffer(edit: arg?.fromEdit ?? false, model: arg?.args?['offer']);
        case AppRouteName.SUBSCRIPTION_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return SubscriptionView(fromCompleteProfile: arg?.fromCompleteProfile ?? false);
        case AppRouteName.SETTINGS_VIEW_ROUTE:
          return Settings();
        case AppRouteName.ADD_CARD_VIEW_ROUTE:
          final ScreenArguments? arg = routeSettings.arguments as ScreenArguments;
          return AddCard(test: arg?.args);
        case AppRouteName.NOTIFICATION_VIEW_ROUTE:
          return NotificationsView();
        case AppRouteName.CONTENT_SCREEN:
          final contentRoutingArgument = routeSettings.arguments as ContentRoutingArgument?;
          return ContentView(
            contentType: contentRoutingArgument?.contentType,
            title: contentRoutingArgument?.title ?? '',
            isMerchantSetupDone: contentRoutingArgument?.isMerchantSetupDone,
          );
        case AppRouteName.USER_PROFILE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ProfileScreenArguments?;
          return UserProfile(
            isBusinessProfile: arg?.isBusinessProfile ?? false,
            user: arg?.user,
            isMe: arg?.isMe ?? false,
            isUser: arg?.isUser ?? false,
          );
        case AppRouteName.CUSTOMER_PROFILE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ProfileScreenArguments?;
          return CustomerProfile(isMe: arg?.isMe ?? false, user: arg?.user);
        default:
          return Container();
      }
    },
  );
}
