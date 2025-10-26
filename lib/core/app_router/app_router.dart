import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/features/change_password/change_password_view.dart';
import 'package:backyard/features/change_password/forgot_password_view.dart';
import 'package:backyard/features/give_review/give_review_view.dart';
import 'package:backyard/features/home/business_home_view.dart';
import 'package:backyard/features/home/home_view.dart';
import 'package:backyard/features/home/user_home_view.dart';
import 'package:backyard/features/landing/landing_view.dart';
import 'package:backyard/features/offer_item/offer_item_view.dart';
import 'package:backyard/features/offers/create_offer_view.dart';
import 'package:backyard/features/offers/scan_offer_view.dart';
import 'package:backyard/features/settings/settings_view.dart';
import 'package:backyard/features/sign_in/enter_otp_view.dart';
import 'package:backyard/features/sign_in/sign_in_view.dart';
import 'package:backyard/features/subscriptions/view/external_subscriptions_view.dart';
import 'package:backyard/features/subscriptions/view/external_subscriptions_view_model.dart';
import 'package:backyard/features/subscriptions/view/in_app_subscriptions_view.dart';
import 'package:backyard/features/time_schedule/time_schedule_edit_view.dart';
import 'package:backyard/features/user_profile/business_availability_view.dart';
import 'package:backyard/features/user_profile/customer_profile_view.dart';
import 'package:backyard/features/user_profile/profile_setup_view.dart';
import 'package:backyard/features/user_profile/user_profile_view.dart';
import 'package:backyard/legacy/Model/day_schedule.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
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
    AutoRoute(path: '/business-availabilities', page: BusinessAvailabilityRoute.page),
    AutoRoute(path: '/profile-setup', page: ProfileSetupRoute.page),
    AutoRoute(path: '/home', page: HomeRoute.page),
    AutoRoute(path: '/offer-item', page: OfferItemRoute.page),
    AutoRoute(path: '/give-review', page: GiveReviewRoute.page),
    AutoRoute(path: '/create-offer', page: CreateOfferRoute.page),
    AutoRoute(path: '/scan-offer', page: ScanOfferRoute.page),
    AutoRoute(path: '/external-subscriptions', page: ExternalSubscriptionsRoute.page),
    AutoRoute(path: '/in-app-subscriptions', page: InAppSubscriptionsRoute.page),
    AutoRoute(path: '/settings', page: SettingsRoute.page),
    AutoRoute(path: '/user-profile', page: UserProfileRoute.page),
    AutoRoute(path: '/customer-profile', page: CustomerProfileRoute.page),
    AutoRoute(path: '/time-schedule-edit', page: TimeScheduleEditRoute.page),
  ];
}
