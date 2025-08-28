import 'dart:ui';

import 'package:backyard/boot.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/services/auth_service.dart';
import 'package:backyard/features/change_password/change_password_view.dart';
import 'package:backyard/legacy/Arguments/content_argument.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_switch.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/menu_model.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/app_strings.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/delete_account.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool val = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool get getBusinesses =>
      (navigatorKey.currentContext?.read<UserController>().isSwitch ?? false)
          ? false
          : navigatorKey.currentContext?.read<UserController>().user?.role == UserRoleEnum.Business;

  @override
  Widget build(Build) {
    return BaseView(
      bgImage: '',
      child: CustomPadding(
        topPadding: 2.h,
        horizontalPadding: 3.w,
        child: Column(
          children: [
            CustomAppBar(
              screenTitle: 'Settings',
              leading: getBusinesses ? MenuIcon() : BackButton(),
              trailing: getBusinesses ? NotificationIcon() : null,
              bottom: 2.h,
            ),
            Consumer<UserController>(
              builder: (context, val, _) {
                return (val.user?.role == UserRoleEnum.Business)
                    ? Padding(
                      padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors.whiteColor,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: .2),
                              blurRadius: 10.0,
                              offset: const Offset(0, 5),
                              spreadRadius: 2.0, //extend the shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: Utils.isTablet ? 8.sp : 15.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(title: 'Switch User', fontWeight: FontWeight.w500, size: Utils.isTablet ? 18 : 15),
                            CustomSwitch(
                              switchValue: val.isSwitch,
                              toggleColor: CustomColors.primaryGreenColor,
                              inActiveColor: CustomColors.pinkColor.withValues(alpha: .2),
                              onChange: (v) {},
                              onChange2: (v) {
                                val.setSwitch(v);
                                // AppNavigation.navigateToRemovingAll(
                                //     AppRouteName.HOME_VIEW_ROUTE);
                                Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
                                Navigator.pushReplacementNamed(
                                  navigatorKey.currentContext!,
                                  AppRouteName.HOME_VIEW_ROUTE,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    : const SizedBox.shrink();
              },
            ),
            showBarberList(l: business ? businessList : userList),
          ],
        ),
      ),
    );
  }

  late bool business = context.read<UserController>().user?.role == UserRoleEnum.Business;

  void getData() {
    if (context.read<UserController>().user?.isPushNotify == 1) {
      val = true;
    }
  }

  List<MenuModel> businessList = [
    MenuModel(name: 'Push Notification', onTap: () {}),
    MenuModel(
      name: 'Privacy Policy',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'Privacy Policy',
            contentType: AppStrings.PRIVACY_POLICY_TYPE,
            url: 'https://www.google.com/',
          ),
        );
      },
    ),
    MenuModel(
      name: 'About App',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'About App',
            contentType: AppStrings.ABOUT_APP_TYPE,
            url: 'https://www.google.com/',
          ),
        );
      },
    ),
    MenuModel(
      name: 'Terms & Conditions',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'Terms & Conditions',
            contentType: AppStrings.TERMS_AND_CONDITION_TYPE,
            url: 'https://www.google.com/',
          ),
        );
      },
    ),
    MenuModel(
      name: 'Delete Account',
      onTap: () {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (Build) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(0),
                insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                content: DeleteDialog(
                  title: 'Delete Account',
                  subTitle: 'Do you want to delete your account?',
                  onYes: () async {
                    getIt<AppNetwork>().loadingProgressIndicator();
                    await getIt<AuthService>().deleteAccount();
                    AppNavigation.navigatorPop();
                  },
                ),
              ),
            );
          },
        );
      },
    ),
    MenuModel(
      name: 'Change Password',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CHANGE_PASSWORD_VIEW_ROUTE,
          arguments: const ChangePasswordViewArgs(fromSettings: true),
        );
      },
    ),
    MenuModel(
      name: 'Subscriptions',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'Subscriptions',
            contentType: 'Subscriptions',
            url: 'https://www.google.com/',
          ),
        );
        // AppNavigation.navigateTo(AppRouteName.SUBSCRIPTION_VIEW_ROUTE);
      },
    ),
  ];
  late List<MenuModel> userList = [
    MenuModel(
      name: 'Push Notification',
      onTap: () async {
        val = !val;
      },
    ),
    MenuModel(
      name: 'Privacy Policy',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'Privacy Policy',
            contentType: AppStrings.PRIVACY_POLICY_TYPE,
            url: 'https://www.google.com/',
          ),
        );
      },
    ),
    MenuModel(
      name: 'About App',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'About App',
            contentType: AppStrings.ABOUT_APP_TYPE,
            url: 'https://www.google.com/',
          ),
        );
      },
    ),
    MenuModel(
      name: 'Terms & Conditions',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'Terms & Conditions',
            contentType: AppStrings.TERMS_AND_CONDITION_TYPE,
            url: 'https://www.google.com/',
          ),
        );
      },
    ),
    // MenuModel(
    //     name: 'Payment Details',
    //     onTap: () {
    //       AppNavigation.navigateTo(AppRouteName.PAYMENT_METHOD_VIEW_ROUTE,
    //           arguments: ScreenArguments(fromSettings: true));
    //     }),
    MenuModel(
      name: 'Delete Account',
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (Build) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(0),
                insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                content: DeleteDialog(
                  title: 'Delete Account',
                  subTitle: 'Do you want to delete your account?',
                  onYes: () async {
                    getIt<AppNetwork>().loadingProgressIndicator();
                    await getIt<AuthService>().deleteAccount();
                    AppNavigation.navigatorPop();
                  },
                ),
              ),
            );
          },
        );
      },
    ),
    MenuModel(
      name: 'Change Password',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CHANGE_PASSWORD_VIEW_ROUTE,
          arguments: const ChangePasswordViewArgs(fromSettings: true),
        );
      },
    ),
    MenuModel(
      name: 'Subscriptions',
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'Subscriptions',
            contentType: 'Subscriptions',
            url: 'https://www.google.com/',
          ),
        );
        // AppNavigation.navigateTo(AppRouteName.SUBSCRIPTION_VIEW_ROUTE);
      },
    ),
  ];
  ListView showBarberList({required List<MenuModel> l}) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: Utils.isTablet ? 2.h : 11, left: 10.sp, right: 10.sp),
      itemCount: l.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            l[index].onTap?.call();
          },
          child: Container(
            decoration:
            // index==0?
            BoxDecoration(
              color: CustomColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: .2),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                  spreadRadius: 2.0, //extend the shadow
                ),
              ],
            ),
            // : BoxDecoration(
            //   borderRadius: BorderRadius.circular(100),
            //   gradient: LinearGradient(colors: [
            //     MyColors().primaryColor,
            //     MyColors().primaryColor ], begin: Alignment.centerLeft, end: Alignment.centerRight)
            // )
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: Utils.isTablet ? 7.sp : 15.sp),
            margin: EdgeInsets.only(bottom: Utils.isTablet ? 2.h : 1.5.h),
            // padding: EdgeInsets.all(2.w)+EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  title: l[index].name!,
                  fontWeight: FontWeight.w500,
                  size: Utils.isTablet ? 18 : 15,
                  // clr: index == 0 ? null : Colors.white,
                ),
                if (index == 0)
                  // CupertinoSwitch(
                  //   value: val,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       val = value;
                  //     });
                  //   },
                  // ),
                  CustomSwitch(
                    switchValue: val,
                    toggleColor: CustomColors.primaryGreenColor,
                    inActiveColor: CustomColors.pinkColor.withValues(alpha: .2),
                    onChange: (v) {},
                    onChange2: (v) async {
                      val = !val;
                      setState(() {});
                      // await AuthController.i.onOffNotifications(,
                      //     onSuccess: () {}, on: val);
                    },
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: Utils.isTablet ? 12.sp : null,
                    // color: Colors.white,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
