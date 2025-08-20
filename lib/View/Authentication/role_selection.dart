import 'package:backyard/Component/custom_terms_condition.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:flutter/services.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:backyard/View/Widget/appLogo.dart';
import '../../Component/custom_background_image.dart';
import '../../Component/custom_buttom.dart';

class RoleSelection extends StatefulWidget {
  RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: CustomBackgroundImage(
        child: CustomPadding(
            child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            AppLogo(
              onTap: () {},
              scale: 2.5,
            ),
            SizedBox(
              height: 4.h,
            ),
            MyText(
              title: 'Role Selection',
              size: 20,
              clr: MyColors().black,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(
              height: 4.h,
            ),
            MyButton(
              title: "Continue as a User",
              onTap: () {
                context.read<UserController>().setRole(Role.User);
                AppNavigation.navigateTo(AppRouteName.PRE_LOGIN_SCREEN_ROUTE);
              },
            ),
            SizedBox(
              height: 2.h,
            ),
            MyButton(
              title: "Continue as a Business",
              onTap: () {
                context.read<UserController>().setRole(Role.Business);
                AppNavigation.navigateTo(AppRouteName.PRE_LOGIN_SCREEN_ROUTE);
              },
            ),
            const Spacer(),
            const CustomTermsCondition(),
            SizedBox(height: 4.h),
          ],
        )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return false;
  }
}
