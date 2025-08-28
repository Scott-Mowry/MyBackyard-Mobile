import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SuccessPaymentDialog extends StatelessWidget {
  const SuccessPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: CustomColors.whiteColor, borderRadius: BorderRadius.circular(20)),
      // height: responsive.setHeight(75),
      width: 100.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.close_outlined, color: Colors.transparent),
                  MyText(title: 'Successful', clr: CustomColors.whiteColor, fontWeight: FontWeight.w600),
                  GestureDetector(
                    onTap: () {
                      context.maybePop();
                      context.maybePop();
                      // HomeController.i.jumpTo(i: 1);
                    },
                    child: const Icon(Icons.close_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Image.asset(ImagePath.checked, scale: 2.5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  MyText(title: 'You have successfully booked your session.', size: 15, center: true),
                  SizedBox(height: 4.h),
                  MyButton(
                    onTap: () {
                      context.maybePop();
                      context.maybePop();
                      // HomeController.i.jumpTo(i: 1);
                      // AppNavigation.navigateTo( AppRouteName.SHOP_LOCATION_VIEW_ROUTE);
                    },
                    title: 'Continue',
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.5.h),
          ],
        ),
      ),
    );
  }
}
