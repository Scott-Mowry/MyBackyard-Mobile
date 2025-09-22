import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await EasyLoading.show();
        await Future.delayed(Duration(milliseconds: 500));
        final localStorageRepository = getIt<LocalStorageRepository>();
        final savedUser = await localStorageRepository.getUser();

        final bearerToken = savedUser?.bearerToken;
        if (savedUser != null && bearerToken != null && bearerToken.isNotEmpty) {
          context.read<UserController>().setUser(savedUser);

          if (!savedUser.isProfileCompleted) return context.replaceRoute<void>(ProfileSetupRoute(isEditProfile: false));
          return context.replaceRoute<void>(HomeRoute());
        }

        return context.replaceRoute<void>(SignInRoute());
      } finally {
        await EasyLoading.dismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return CustomBackgroundImage(child: Center(child: AppLogo()));
  }
}
