import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReviewSubmitted extends StatelessWidget {
  const ReviewSubmitted({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.maybePop();
        context.maybePop();
        context.maybePop();
        return Future(() => false);
        // return Utils().onWillPop(context, currentBackPressTime: currentBackPressTime);
      },
      child: Container(
        decoration: BoxDecoration(color: CustomColors.blackLight, borderRadius: BorderRadius.circular(12)),
        // height: responsive.setHeight(75),
        width: 100.w,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4.h),
                MyText(title: 'Review has been submitted', size: 24, center: true),
                SizedBox(height: 4.h),
                MyButton(
                  onTap: () {
                    context.maybePop();
                    context.maybePop();
                    context.maybePop();
                    // HomeController.i.jumpTo(i: 2);
                  },
                  title: 'Go to Home',
                ),
                SizedBox(height: 3.5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
