import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/custom_text_style.dart';
import 'package:backyard/core/design_system/widgets/app_bar_back_button.dart';
import 'package:backyard/core/design_system/widgets/custom_web_view.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/legacy/Component/custom_switch.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/menu_model.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/delete_account.dart';
import 'package:backyard/legacy/View/Widget/Dialog/logout.dart';
import 'package:backyard/my-backyard-app.dart';
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
  bool allowNotifications = false;

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
  Widget build(context) {
    super.build(context);
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: AppBar(
        leading: AppBarBackButton(),
        title: Text('Settings', style: CustomTextStyle.labelLarge.copyWith(color: CustomColors.black)),
        backgroundColor: CustomColors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: CustomSpacer.right.xs,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AlertDialog(
                        backgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        content: LogoutAlert(),
                      ),
                    );
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(ImagePath.logout, scale: 3),
                  Padding(
                    padding: CustomSpacer.left.xxs,
                    child: MyText(
                      title: 'Logout',
                      clr: CustomColors.primaryGreenColor,
                      fontWeight: FontWeight.w600,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        padding: CustomSpacer.horizontal.xs + CustomSpacer.top.xl,
        child: Column(
          children: [
            Consumer<UserController>(
              builder: (context, userController, _) {
                final userProfile = userController.user;
                return Column(
                  children: [
                    if (userProfile?.role == UserRoleEnum.Business)
                      Padding(
                        padding: CustomSpacer.horizontal.xxs,
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
                          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: Utils.isTablet ? 7.sp : 15.sp),
                          margin: EdgeInsets.only(bottom: Utils.isTablet ? 2.h : 1.5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(title: 'Switch User', fontWeight: FontWeight.w500, size: Utils.isTablet ? 18 : 15),
                              CustomSwitch(
                                switchValue: userController.isSwitch,
                                toggleColor: CustomColors.primaryGreenColor,
                                inActiveColor: CustomColors.pinkColor.withValues(alpha: .2),
                                onChange: (v) {},
                                onChange2: (v) {
                                  userController.setSwitch(v);

                                  MyBackyardApp.appRouter.popUntilRoot();
                                  return context.pushRoute<void>(HomeRoute());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: CustomSpacer.horizontal.xxs + CustomSpacer.bottom.xmd,
              itemCount: optionsList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => optionsList[index].onTap?.call(),
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
                    padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: Utils.isTablet ? 7.sp : 15.sp),
                    margin: EdgeInsets.only(bottom: Utils.isTablet ? 2.h : 1.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          title: optionsList[index].name!,
                          fontWeight: FontWeight.w500,
                          size: Utils.isTablet ? 18 : 15,
                        ),
                        if (index == 0)
                          CustomSwitch(
                            switchValue: allowNotifications,
                            toggleColor: CustomColors.primaryGreenColor,
                            inActiveColor: CustomColors.pinkColor.withValues(alpha: .2),
                            onChange: (v) {},
                            onChange2: (v) async {
                              allowNotifications = !allowNotifications;
                              setState(() {});
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
            ),
          ],
        ),
      ),
    );
  }

  void getData() {
    if (context.read<UserController>().user?.isPushNotify ?? false) {
      allowNotifications = true;
    }
  }

  late List<MenuModel> optionsList = [
    MenuModel(name: 'Push Notification', onTap: () {}),
    MenuModel(name: 'Change Password', onTap: () => context.pushRoute<void>(ChangePasswordRoute(fromSettings: true))),
    MenuModel(name: 'Subscriptions', onTap: () => context.pushRoute(SubscriptionRoute())),
    MenuModel(name: 'Privacy Policy', onTap: () => showWebViewBottomSheet(url: privacyPolicyUrl, context: context)),
    MenuModel(name: 'Terms & Conditions', onTap: () => showWebViewBottomSheet(url: termsOfUseUrl, context: context)),
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
                  },
                ),
              ),
            );
          },
        );
      },
    ),
  ];
}
