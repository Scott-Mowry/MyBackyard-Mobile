import 'package:backyard/View/Authentication/change_password.dart';
import 'package:backyard/View/Authentication/edit_schedule_time.dart';
import 'package:backyard/View/Authentication/forgot_password.dart';
import 'package:backyard/View/Business/create_offer.dart';
import 'package:backyard/View/Common/customer_profile.dart';
import 'package:backyard/View/Common/favorite.dart';
import 'package:backyard/View/Common/loyalty_program.dart';
import 'package:backyard/View/Common/subscription.dart';
import 'package:backyard/View/Payment/payment_history.dart';
import 'package:backyard/View/User/discount_offers.dart';
import 'package:backyard/View/User/give_review.dart';
import 'package:backyard/View/User/scan_qr.dart';
import 'package:backyard/View/Common/user_profile.dart';
import 'package:backyard/View/Widget/approval.dart';
import 'package:backyard/View/faqs.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Arguments/content_argument.dart';
import 'package:backyard/Arguments/profile_screen_arguments.dart';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Service/url_launcher.dart';
import 'package:backyard/View/Authentication/enter_otp.dart';
import 'package:backyard/View/Authentication/login_screen.dart';
import 'package:backyard/View/Authentication/phone_login.dart';
import 'package:backyard/View/Authentication/pre_login.dart';
import 'package:backyard/View/Authentication/profile_setup.dart';
import 'package:backyard/View/Authentication/role_selection.dart';
import 'package:backyard/View/Payment/all_cards.dart';
import 'package:backyard/View/Review/all_reviews.dart';
import 'package:backyard/View/home_view.dart';
import 'package:backyard/View/notifications.dart';
import 'package:backyard/View/splash.dart';
import '../View/Authentication/business_category.dart';
import '../View/Authentication/schedule.dart';
import '../View/Common/Settings/settings.dart';
import '../View/Payment/add_card.dart';
import '../View/User/search_result.dart';
import 'app_router_name.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case AppRouteName.SPLASH_SCREEN_ROUTE:
            return SplashScreen();
          // return CustomBottomNavigationBar();
          case AppRouteName.ROLE_SELECTION:
            return RoleSelection();
          case AppRouteName.PRE_LOGIN_SCREEN_ROUTE:
            return PreLoginScreen();
          case AppRouteName.LOGIN_SCREEN_ROUTE:
            return LoginScreen();
          // case AppRouteName.FORGET_PASSWORD_ROUTE:
          //   return ForgotPassword();
          // time scheduling edit screen
          case AppRouteName.TIME_SCHEDULING_EDIT_SCREEN_ROUTE:
            final arg = routeSettings.arguments as TimeSchedulingEditArgument?;
            return TimeSchedulingEditScreen(val: arg?.val, multiSelect: arg?.multiSelect);
          case AppRouteName.CHANGE_PASSWORD_ROUTE:
            ChangePasswordArguments? arg = routeSettings.arguments as ChangePasswordArguments?;
            return ChangePassword(fromSettings: arg?.fromSettings);
          case AppRouteName.FORGET_PASSWORD_ROUTE:
            return const ForgotPasswordScreen();
          case AppRouteName.ENTER_OTP_SCREEN_ROUTE:
            EnterOTPArguements? arg = routeSettings.arguments as EnterOTPArguements?;
            return EnterOTP(
              phoneNumber: arg?.phoneNumber ?? "",
              verification: arg?.verification,
              fromForgot: arg?.fromForgot,
              // isFirebase: arg?.isFirebase ?? false,
              // isFirebase: otpRoutingArgument?.isFirebase,
            );
          case AppRouteName.SCHEDULE_SCREEN_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments?;
            return Schedule(edit: arg?.fromEdit ?? false, args: arg?.args);
          case AppRouteName.CATEGORY_SCREEN_ROUTE:
            return Category();
          case AppRouteName.APPROVAL_SCREEN_ROUTE:
            return Approval();
          case AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments?;
            return ProfileSetup(editProfile: arg?.fromEdit ?? false);
          case AppRouteName.HOME_SCREEN_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments?;
            return HomeView();
          // return CustomBottomNavigationBar();
          case AppRouteName.PHONE_LOGIN_SCREEN_ROUTE:
            return PhoneLogin();
          // case AppRouteName.SESSION_DETAIL_ROUTE:
          //   SessionArgument? arg = routeSettings.arguments as SessionArgument?;
          //   return SessionDetails(
          //     s: arg?.s ?? SessionModel(),
          //   );
          case AppRouteName.SCAN_QR_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments?;
            return ScanQR(fromOffer: arg?.fromOffer ?? false);
          case AppRouteName.FAVORITE_ROUTE:
            return Favorite();
          case AppRouteName.LOYALTY_ROUTE:
            return LoyaltyProgram();
          case AppRouteName.DISCOUNT_OFFER_ROUTE:
            DiscountOffersArguments? arg = routeSettings.arguments as DiscountOffersArguments?;
            return DiscountOffers(model: arg?.model, fromSaved: arg?.fromSaved);
          case AppRouteName.SEARCH_RESULT_ROUTE:
            SearchResultArguments? arg = routeSettings.arguments as SearchResultArguments?;
            return SearchResult(categoryId: arg?.categoryId);
          case AppRouteName.GIVE_REVIEW_ROUTE:
            GiveReviewArguments? arg = routeSettings.arguments as GiveReviewArguments?;
            return GiveReview(busId: arg?.busId);
          case AppRouteName.CREATE_OFFER_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments?;
            return CreateOffer(edit: arg?.fromEdit ?? false, model: arg?.args?["offer"]);
          case AppRouteName.SUBSCRIPTION_SCREEN_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments?;
            return SubscriptionScreen(fromCompleteProfile: arg?.fromCompleteProfile ?? false);
          case AppRouteName.PAYMENT_METHOD_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments?;
            return PaymentMethod(fromSettings: arg?.fromSettings ?? false);
          case AppRouteName.PAYMENT_HISTORY_ROUTE:
            return PaymentHistory();

          case AppRouteName.ALL_REVIEWS_ROUTE:
            return AllReviews();

          case AppRouteName.SETTINGS_ROUTE:
            return Settings();
          case AppRouteName.ADD_CARD_ROUTE:
            ScreenArguments? arg = routeSettings.arguments as ScreenArguments;
            return AddCard(test: arg.args);
          case AppRouteName.NOTIFICATION_SCREEN_ROUTE:
            return NotificationScreen();
          case AppRouteName.FAQ_SCREEN_ROUTE:
            return FAQScreen();
          case AppRouteName.CONTENT_SCREEN:
            ContentRoutingArgument? contentRoutingArgument = routeSettings.arguments as ContentRoutingArgument?;
            return ContentScreen(
              // url: contentRoutingArgument?.url ?? "",
              contentType: contentRoutingArgument?.contentType,
              title: contentRoutingArgument?.title ?? "",
              isMerchantSetupDone: contentRoutingArgument?.isMerchantSetupDone,
            );
          case AppRouteName.USER_PROFILE_ROUTE:
            ProfileScreenArguments? arg = routeSettings.arguments as ProfileScreenArguments?;
            return UserProfile(
              isBusinessProfile: arg?.isBusinessProfile ?? false,
              user: arg?.user,
              isMe: arg?.isMe ?? false,
              isUser: arg?.isUser ?? false,
            );
          case AppRouteName.CustomerProfile:
            ProfileScreenArguments? arg = routeSettings.arguments as ProfileScreenArguments?;
            return CustomerProfile(isMe: arg?.isMe ?? false, user: arg?.user);
          default:
            return Container();
        }
      },
    );
  }
}
