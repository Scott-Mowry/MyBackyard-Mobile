import 'package:auto_route/auto_route.dart';
import 'package:backyard/features/change_password/change_password_view.dart';
import 'package:backyard/features/change_password/forgot_password_view.dart';
import 'package:backyard/features/content/content_view.dart';
import 'package:backyard/features/create_offer/create_offer_view.dart';
import 'package:backyard/features/discount_offers/discount_offers_view.dart';
import 'package:backyard/features/give_review/give_review_view.dart';
import 'package:backyard/features/home/business_home_view.dart';
import 'package:backyard/features/home/home_view.dart';
import 'package:backyard/features/home/user_home_view.dart';
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
import 'package:backyard/legacy/Model/day_schedule.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/landing', page: LandingRoute.page, initial: true),
    AutoRoute(path: '/login_screen', page: SignInRoute.page),
    AutoRoute(path: '/changePassword', page: ChangePasswordRoute.page),
    AutoRoute(path: '/forget-password', page: ForgotPasswordRoute.page),
    AutoRoute(path: '/enter-otp', page: EnterOTPRoute.page),
    AutoRoute(path: '/schedule', page: ScheduleRoute.page),
    AutoRoute(path: '/category', page: BusinessCategoryRoute.page),
    AutoRoute(path: '/profile-setup', page: ProfileSetupRoute.page),
    AutoRoute(path: '/home', page: HomeRoute.page),
    AutoRoute(path: '/scan-qr', page: ScanQRRoute.page),
    AutoRoute(path: '/discount-offers', page: DiscountOffersRoute.page),
    AutoRoute(path: '/SearchResult', page: SearchResultsRoute.page),
    AutoRoute(path: '/give-review', page: GiveReviewRoute.page),
    AutoRoute(path: '/create-offer', page: CreateOfferRoute.page),
    AutoRoute(path: '/subscription-screen', page: SubscriptionRoute.page),
    AutoRoute(path: '/settings', page: SettingsRoute.page),
    AutoRoute(path: '/content-screen', page: ContentRoute.page),
    AutoRoute(path: '/user-profile', page: UserProfileRoute.page),
    AutoRoute(path: '/customer-profile', page: CustomerProfileRoute.page),
    AutoRoute(path: '/timeSchedulingEditScreenRoute', page: TimeScheduleEditRoute.page),
  ];
}
