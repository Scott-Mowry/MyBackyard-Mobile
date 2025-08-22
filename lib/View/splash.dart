import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Service/socket_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/local_shared_preferences.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 3), () async {
      final localDatabase = SharedPreference();
      final socket = SocketService.instance;
      socket?.initializeSocket();
      socket?.connectSocket();
      socket?.socketResponseMethod();
      await localDatabase.sharedPreference;
      final user = localDatabase.getUser();

      if (user != null) {
        userFunction(user);
      } else {
        AppNavigation.navigateReplacementNamed(AppRouteName.LOGIN_SCREEN_ROUTE);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void userFunction(Map<String, dynamic> user) {
    log('USER MODEL: ${json.encode(user)}');
    context.read<UserController>().setUser(User.setUser2(user, token: user['bearer_token']));
    log('Bearer Token:');
    log(context.read<UserController>().user?.token ?? '');
    SocketService.instance?.userResponse();
    Navigator.of(context).pushReplacementNamed(AppRouteName.HOME_SCREEN_ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SizedBox(
      width: 1.sw,
      height: 1.sh,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Container(
          //   alignment: Alignment.bottomCenter,
          //   padding: EdgeInsets.only(bottom: 3.h),
          //   decoration: BoxDecoration(
          //       image: DecorationImage(
          //     image: AssetImage(ImagePath.splashImage),
          //   )),
          //   child: Image.asset(
          //     ImagePath.go,
          //     scale: 2,
          //   ),
          // ),
          Image.asset(ImagePath.bgImage1, fit: BoxFit.cover, width: 1.sw),
          SizedBox(
            width: Utils.isTablet ? .6.sw : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height:
                      // 106.h
                      50.h,
                ),
                // AppLogo(scale: 1.899),
                Image.asset(ImagePath.appLogoAnimation, scale: 1.899),
                Utils.isTablet ? 45.verticalSpace : 20.verticalSpace,
                // 65.verticalSpace,
                const MyText(height: 1, size: 25, title: 'The Best', fontWeight: FontWeight.w600),
                11.verticalSpace,
                const MyText(height: 1, size: 40, title: 'Deals are', fontWeight: FontWeight.w600),
                11.verticalSpace,
                const MyText(height: 1, size: 30, title: 'Local & Family Owned', fontWeight: FontWeight.w600),
                12.5.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
                  child: const MyText(
                    height: 1.25,
                    size: 16,
                    letterSpacing: 1.3,
                    align: TextAlign.center,
                    title: 'Support Local Family Owned Business While Saving Money Doing It',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
