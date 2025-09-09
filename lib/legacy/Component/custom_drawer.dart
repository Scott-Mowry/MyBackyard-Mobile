import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/widgets/custom_web_view.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/menu_model.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Utils.isTablet ? 60.w : 92.w,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(ImagePath.drawer),
              alignment: Alignment.centerRight,
              fit: BoxFit.fitHeight,
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 3.h),
              Row(
                children: [
                  SizedBox(width: Utils.isTablet ? 13.w : 23.5.w),
                  Consumer<UserController>(
                    builder: (context, val, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.primaryGreenColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: CustomColors.whiteColor, width: 1),
                            ),
                            padding: EdgeInsets.all(6),
                            height: Utils.isTablet ? 12.h : 16.h,
                            width: Utils.isTablet ? 12.h : 16.h,
                            alignment: Alignment.center,
                            child: CustomImage(
                              height: Utils.isTablet ? 11.h : 15.h,
                              width: Utils.isTablet ? 11.h : 15.h,
                              isProfile: true,
                              photoView: false,
                              url: val.user?.profileImage,
                              radius: 100,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          MyText(
                            title: val.user?.name ?? '',
                            fontWeight: FontWeight.w500,
                            size: 18,
                            clr: CustomColors.whiteColor,
                          ),
                          SizedBox(
                            width: 16.h,
                            child: MyText(
                              toverflow: TextOverflow.ellipsis,
                              title: val.user?.email ?? '',
                              size: 15,
                              clr: CustomColors.whiteColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              showList(l: business ? businessList : userList),
              SizedBox(height: 3.h),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: AlertDialog(
                            backgroundColor: Colors.transparent,
                            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            content: LogoutAlert(),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w) + EdgeInsets.only(right: 5.w),
                    decoration: BoxDecoration(
                      color: CustomColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          blurRadius: 10, // Spread of the shadow
                          spreadRadius: 5, // Size of the shadow
                          offset: const Offset(0, 4), // Position of the shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(ImagePath.logout, scale: 2),
                        SizedBox(width: 2.w),
                        MyText(
                          title: 'Logout',
                          clr: CustomColors.primaryGreenColor,
                          fontWeight: FontWeight.w500,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
        Positioned(
          top: 5.h,
          right: Utils.isTablet ? 1.w : 4.w,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 10.h,
              width: 18.w,
              color: Colors.transparent,
              child: Icon(Icons.close, color: CustomColors.whiteColor, size: Utils.isTablet ? 45 : 30),
            ),
          ),
        ),
      ],
    );
  }

  Expanded showList({required List<MenuModel> l}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, top: 0.h),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: l.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                context.maybePop();
                l[index].onTap?.call();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Row(
                children: [
                  Image.asset(l[index].image!, scale: 2, color: CustomColors.whiteColor),
                  SizedBox(width: 3.w),
                  MyText(title: l[index].name!, fontWeight: FontWeight.w500, size: 18, clr: CustomColors.whiteColor),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(padding: EdgeInsets.only(bottom: 4.h));
          },
        ),
      ),
    );
  }

  late List<MenuModel> businessList = [
    MenuModel(name: 'Home', image: ImagePath.home3, onTap: () => context.read<HomeController>().jumpTo(i: 0)),
    MenuModel(name: 'Scan QR', image: ImagePath.scan, onTap: () => context.pushRoute(ScanQRRoute())),
    MenuModel(name: 'Settings', image: ImagePath.setting, onTap: () => context.read<HomeController>().jumpTo(i: 2)),
    MenuModel(
      name: 'Terms & Conditions',
      image: ImagePath.terms,
      onTap: () => showWebViewBottomSheet(url: termsOfUseUrl, context: context),
    ),
    MenuModel(
      name: 'Privacy Policy',
      image: ImagePath.privacy,
      onTap: () => showWebViewBottomSheet(url: privacyPolicyUrl, context: context),
    ),
  ];

  late List<MenuModel> userList = [
    MenuModel(name: 'Home', image: ImagePath.home3, onTap: () => context.read<HomeController>().jumpTo(i: 0)),
    MenuModel(name: 'Settings', image: ImagePath.setting, onTap: () => context.pushRoute(SettingsRoute())),
    MenuModel(
      name: 'Terms & Conditions',
      image: ImagePath.terms,
      onTap: () => showWebViewBottomSheet(url: termsOfUseUrl, context: context),
    ),
    MenuModel(
      name: 'Privacy Policy',
      image: ImagePath.privacy,
      onTap: () => showWebViewBottomSheet(url: privacyPolicyUrl, context: context),
    ),
  ];

  Future logoutAlert(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            content: LogoutAlert(),
          ),
        );
      },
    );
  }

  late bool business =
      (context.read<UserController>().isSwitch)
          ? false
          : context.read<UserController>().user?.role == UserRoleEnum.Business;
}
