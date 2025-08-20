import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_background_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import '../../../Component/custom_buttom.dart';
import '../../../Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Approval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onWillPop(context);
      },
      child: CustomBackgroundImage(
        child: CustomPadding(
          topPadding: 6.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomAppBar(
                screenTitle: 'Wait For Approval',
                leading: CustomBackButton(),
                bottom: 6.h,
              ),
              Expanded(
                  child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Column(
                    children: [
                      Image.asset(
                        ImagePath.happy,
                        scale: 2.3,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      MyText(
                        title:
                            'Waiting for profile verification,\nOnce the admin will approve your\nprofile verification then you will\nstart the using app.',
                        size: 15,
                        center: true,
                        fontStyle: FontStyle.italic,
                        clr: MyColors().whiteColor,
                      ),
                    ],
                  ),
                  Spacer(),
                  MyButton(
                    title: 'Continue',
                    onTap: () {
                      onSubmit(context);
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit(context) {
    AppNavigation.navigatorPop();
    AppNavigation.navigatorPop();
    // AppNavigation.navigateToRemovingAll(context, AppRouteName.HOME_SCREEN_ROUTE,);
  }

  onWillPop(context) async {
    onSubmit(context);
    return false;
  }
}
