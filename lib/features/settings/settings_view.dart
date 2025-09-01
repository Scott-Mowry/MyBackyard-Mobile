import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_switch.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/menu_model.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Utils/app_strings.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/delete_account.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class SettingsView extends StatefulWidget {
  final bool wantKeepAlive;

  const SettingsView({super.key, this.wantKeepAlive = false});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with AutomaticKeepAliveClientMixin {
  bool val = false;

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();
    getData();
  }

  bool get getBusinesses =>
      (context.read<UserController>().isSwitch)
          ? false
          : context.read<UserController>().user?.role == UserRoleEnum.Business;

  @override
  Widget build(Build) {
    super.build(context);
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

                                Navigator.popUntil(context, (route) => route.isFirst);
                                return context.pushRoute<void>(HomeRoute());
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
    if (context.read<UserController>().user?.isPushNotify ?? false) {
      val = true;
    }
  }

  late List<MenuModel> businessList = [
    MenuModel(name: 'Push Notification', onTap: () {}),
    MenuModel(
      name: 'Privacy Policy',
      onTap:
          () => context.pushRoute<void>(
            ContentRoute(title: 'Privacy Policy', contentType: AppStrings.PRIVACY_POLICY_TYPE),
          ),
    ),
    MenuModel(
      name: 'About App',
      onTap: () => context.pushRoute<void>(ContentRoute(title: 'About App', contentType: AppStrings.ABOUT_APP_TYPE)),
    ),
    MenuModel(
      name: 'Terms & Conditions',
      onTap:
          () => context.pushRoute<void>(
            ContentRoute(title: 'Terms & Conditions', contentType: AppStrings.TERMS_AND_CONDITION_TYPE),
          ),
    ),
    MenuModel(
      name: 'Delete Account',
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
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
                    await getIt<UserAuthRepository>().deleteAccount();
                    context.maybePop();
                  },
                ),
              ),
            );
          },
        );
      },
    ),
    MenuModel(name: 'Change Password', onTap: () => context.pushRoute<void>(ChangePasswordRoute(fromSettings: true))),
    MenuModel(
      name: 'Subscriptions',
      onTap: () => context.pushRoute<void>(ContentRoute(title: 'Subscriptions', contentType: 'Subscriptions')),
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
      onTap:
          () => context.pushRoute<void>(
            ContentRoute(title: 'Privacy Policy', contentType: AppStrings.PRIVACY_POLICY_TYPE),
          ),
    ),
    MenuModel(
      name: 'About App',
      onTap: () => context.pushRoute(ContentRoute(title: 'About App', contentType: AppStrings.ABOUT_APP_TYPE)),
    ),
    MenuModel(
      name: 'Terms & Conditions',
      onTap:
          () => context.pushRoute(
            ContentRoute(title: 'Terms & Conditions', contentType: AppStrings.TERMS_AND_CONDITION_TYPE),
          ),
    ),
    MenuModel(
      name: 'Delete Account',
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
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
                    await getIt<UserAuthRepository>().deleteAccount();
                    context.maybePop();
                  },
                ),
              ),
            );
          },
        );
      },
    ),
    MenuModel(name: 'Change Password', onTap: () => context.pushRoute(ChangePasswordRoute(fromSettings: true))),
    MenuModel(
      name: 'Subscriptions',
      onTap: () => context.pushRoute(ContentRoute(title: 'Subscriptions', contentType: 'Subscriptions')),
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
