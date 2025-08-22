import 'dart:ui';

import 'package:backyard/legacy/Arguments/content_argument.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/menu_model.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/app_strings.dart';
import 'package:backyard/legacy/Utils/enum.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/my_colors.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/logout.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool val = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                              // color: Colors.red,
                              color: MyColors().primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: MyColors().whiteColor, width: 1),
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
                            clr: MyColors().whiteColor,
                          ),
                          // MyText(title: AuthController.i.user.value.fullName,fontWeight: FontWeight.w600,size: 18,clr: MyColors().whiteColor),
                          // SizedBox(
                          //   height: 1.h,
                          // ),
                          SizedBox(
                            width: 16.h,
                            child: MyText(
                              toverflow: TextOverflow.ellipsis,
                              title: val.user?.email ?? '',
                              size: 15,
                              clr: MyColors().whiteColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w)+EdgeInsets.only(right: 2.w),
              //   child: Column(
              //     children: [
              //       MyText(title: AuthController.i.user.value.fullName,size: 24,fontWeight: FontWeight.w600,),
              //       MyText(title: AuthController.i.user.value.email,size: 18,),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 5.h,),
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
                      color: MyColors().whiteColor,
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
                        MyText(title: 'Logout', clr: MyColors().primaryColor, fontWeight: FontWeight.w500, size: 18),
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
            onTap: AppNavigation.navigatorPop,
            child: Container(
              height: 10.h,
              width: 18.w,
              color: Colors.transparent,
              child: Icon(Icons.close, color: MyColors().whiteColor, size: Utils.isTablet ? 45 : 30),
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
                AppNavigation.navigatorPop();
                l[index].onTap?.call();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Row(
                children: [
                  Image.asset(l[index].image!, scale: 2, color: MyColors().whiteColor),
                  SizedBox(width: 3.w),
                  MyText(title: l[index].name!, fontWeight: FontWeight.w500, size: 18, clr: MyColors().whiteColor),
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

  List<MenuModel> businessList = [
    MenuModel(
      name: 'Home',
      image: ImagePath.home3,
      onTap: () {
        navigatorKey.currentContext?.read<HomeController>().jumpTo(i: 0);
      },
    ),
    MenuModel(
      name: 'Scan QR',
      image: ImagePath.scan,
      onTap: () {
        AppNavigation.navigateTo(AppRouteName.SCAN_QR_ROUTE);
      },
    ),
    MenuModel(
      name: 'Settings',
      image: ImagePath.setting,
      onTap: () {
        navigatorKey.currentContext?.read<HomeController>().jumpTo(i: 2);
      },
    ),
    MenuModel(
      name: 'Terms & Conditions',
      image: ImagePath.terms,
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
      name: 'Privacy Policy',
      image: ImagePath.privacy,
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
  ];
  List<MenuModel> userList = [
    // MenuModel(name: 'Subscription',image: ImagePath.home3,onTap: (context){AppNavigation.navigateTo( AppRouteName.SUBSCRIPTION_SCREEN_ROUTE);}),
    MenuModel(
      name: 'Home',
      image: ImagePath.home3,
      onTap: () {
        navigatorKey.currentContext?.read<HomeController>().jumpTo(i: 0);
      },
    ),
    // MenuModel(
    //     name: 'Favorites',
    //     image: ImagePath.favorite,
    //     onTap: () {
    //       AppNavigation.navigateTo(AppRouteName.FAVORITE_ROUTE);
    //     }),
    // MenuModel(name: 'Loyalty',image: ImagePath.loyalty,onTap: (context){AppNavigation.navigateTo( AppRouteName.LOYALTY_ROUTE);}),
    MenuModel(
      name: 'Settings',
      image: ImagePath.setting,
      onTap: () {
        AppNavigation.navigateTo(AppRouteName.SETTINGS_ROUTE);
      },
    ),
    MenuModel(
      name: 'Terms & Conditions',
      image: ImagePath.terms,
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
      name: 'Privacy Policy',
      image: ImagePath.privacy,
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CONTENT_SCREEN,
          arguments: ContentRoutingArgument(
            title: 'Privacy Policy',
            contentType: AppStrings.PRIVACY_POLICY_TYPE,
            url: '',
          ),
        );
      },
    ),
    // MenuModel(name: 'Support and Help',image: ImagePath.support,onTap: (context){
    //   AppNavigation.navigateTo( AppRouteName.FAQ_SCREEN_ROUTE);
    // }),
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

  bool business =
      (navigatorKey.currentContext?.read<UserController>().isSwitch ?? false)
          ? false
          : navigatorKey.currentContext?.read<UserController>().user?.role == Role.Business;
}
