import 'package:backyard/features/change_password/change_password_view.dart';
import 'package:backyard/features/change_password/forgot_password_view.dart';
import 'package:backyard/features/content/content_view.dart';
import 'package:backyard/features/create_offer/create_offer_view.dart';
import 'package:backyard/features/discount_offers/discount_offers_view.dart';
import 'package:backyard/features/give_review/give_review_view.dart';
import 'package:backyard/features/home/home_view.dart';
import 'package:backyard/features/landing/landing_view.dart';
import 'package:backyard/features/scan_qr/scan_qr_view.dart';
import 'package:backyard/features/search_results/search_results_view.dart';
import 'package:backyard/features/settings/settings_view.dart';
import 'package:backyard/features/sign_in/enter_otp_view.dart';
import 'package:backyard/features/sign_in/sign_in_view.dart';
import 'package:backyard/features/subscription/subscription_view.dart';
import 'package:backyard/features/time_schedule/time_schedule_edit_view.dart';
import 'package:backyard/features/user_profile/business_category_view.dart';
import 'package:backyard/features/user_profile/customer_profile_view.dart';
import 'package:backyard/features/user_profile/profile_setup_view.dart';
import 'package:backyard/features/user_profile/schedule_view.dart';
import 'package:backyard/features/user_profile/user_profile_view.dart';
import 'package:backyard/legacy/Arguments/content_argument.dart';
import 'package:backyard/legacy/Arguments/profile_screen_arguments.dart';
import 'package:backyard/legacy/Arguments/screen_arguments.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
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
          final arg = routeSettings.arguments as EnterOTPArgs?;
          return EnterOTPView(
            phoneNumber: arg?.phoneNumber ?? '',
            verification: arg?.verification,
            fromForgot: arg?.fromForgot,
          );
        case AppRouteName.SCHEDULE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return ScheduleView(edit: arg?.fromEdit ?? false, args: arg?.args);
        case AppRouteName.CATEGORY_VIEW_ROUTE:
          return BusinessCategoryView();

        case AppRouteName.COMPLETE_PROFILE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return ProfileSetup(editProfile: arg?.fromEdit ?? false);
        case AppRouteName.HOME_VIEW_ROUTE:
          return HomeView();
        case AppRouteName.SCAN_QR_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return ScanQRView(fromOffer: arg?.fromOffer ?? false);
        case AppRouteName.DISCOUNT_OFFER_VIEW_ROUTE:
          final arg = routeSettings.arguments as DiscountOffersArguments?;
          return DiscountOffers(model: arg?.model, fromSaved: arg?.fromSaved);
        case AppRouteName.SEARCH_RESULT_VIEW_ROUTE:
          final arg = routeSettings.arguments as SearchResultsArgs?;
          return SearchResultsView(categoryId: arg?.categoryId);
        case AppRouteName.GIVE_REVIEW_VIEW_ROUTE:
          final arg = routeSettings.arguments as GiveReviewArgs?;
          return GiveReviewView(busId: arg?.busId);
        case AppRouteName.CREATE_OFFER_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return CreateOfferView(edit: arg?.fromEdit ?? false, model: arg?.args?['offer']);
        case AppRouteName.SUBSCRIPTION_VIEW_ROUTE:
          final arg = routeSettings.arguments as ScreenArguments?;
          return SubscriptionView(fromCompleteProfile: arg?.fromCompleteProfile ?? false);
        case AppRouteName.SETTINGS_VIEW_ROUTE:
          return SettingsView();
        case AppRouteName.CONTENT_SCREEN:
          final contentRoutingArgument = routeSettings.arguments as ContentRoutingArgument?;
          return ContentView(
            contentType: contentRoutingArgument?.contentType,
            title: contentRoutingArgument?.title ?? '',
            isMerchantSetupDone: contentRoutingArgument?.isMerchantSetupDone,
          );
        case AppRouteName.USER_PROFILE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ProfileScreenArguments?;
          return UserProfileView(
            isBusinessProfile: arg?.isBusinessProfile ?? false,
            user: arg?.user,
            isMe: arg?.isMe ?? false,
            isUser: arg?.isUser ?? false,
          );
        case AppRouteName.CUSTOMER_PROFILE_VIEW_ROUTE:
          final arg = routeSettings.arguments as ProfileScreenArguments?;
          return CustomerProfileView(isMe: arg?.isMe ?? false, user: arg?.user);
        default:
          return Container();
      }
    },
  );
}
