import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
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
    timer = Timer(const Duration(milliseconds: 500), () async {
      final localStorageRepository = getIt<LocalStorageRepository>();
      final savedUser = await localStorageRepository.getUser();
      final bearerToken = savedUser?.bearerToken;
      if (savedUser != null && bearerToken != null && bearerToken.isNotEmpty) {
        context.read<UserController>().setUser(savedUser);

        if (!savedUser.isProfileCompleted) return context.replaceRoute<void>(ProfileSetupRoute(isEditProfile: false));
        return context.replaceRoute<void>(HomeRoute());
      }

      return context.replaceRoute<void>(SignInRoute());
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
