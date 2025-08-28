import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LogoutAlert extends StatefulWidget {
  const LogoutAlert({super.key});

  @override
  State<LogoutAlert> createState() => _LogoutAlertState();
}

class _LogoutAlertState extends State<LogoutAlert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: CustomColors.whiteColor, borderRadius: BorderRadius.circular(20)),
      width: 100.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomColors.primaryGreenColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.close_outlined, color: Colors.transparent),
                  MyText(title: 'Logout', clr: CustomColors.whiteColor, fontWeight: FontWeight.w600),
                  GestureDetector(
                    onTap: context.maybePop,
                    child: const Icon(Icons.close_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 3.h),
                  Center(child: MyText(title: 'Are you sure want to\nlogout?', size: 18, center: true)),
                  SizedBox(height: 3.h),
                  MyButton(
                    onTap: () async {
                      getIt<AppNetwork>().loadingProgressIndicator();
                      await getIt<UserAuthRepository>().signOut();
                    },
                    title: 'Logout',
                  ),
                  SizedBox(height: 3.5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
