import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Service/socket_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 1), () async {
      final socket = SocketService.instance;
      socket?.initializeSocket();
      socket?.connectSocket();
      socket?.socketResponseMethod();

      final localStorageRepository = getIt<LocalStorageRepository>();
      final user = await localStorageRepository.getUser();
      final bearerToken = user?['bearer_token'] as String?;
      if (user != null && bearerToken != null && bearerToken.isNotEmpty) {
        final savedUsed = User.setUser2(user, token: bearerToken);
        context.read<UserController>().setUser(savedUsed);

        SocketService.instance?.userResponse();
        await Navigator.of(context).pushReplacementNamed(AppRouteName.HOME_SCREEN_ROUTE);
        return;
      }

      return AppNavigation.navigateReplacementNamed(AppRouteName.LOGIN_VIEW_ROUTE);
    });
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
