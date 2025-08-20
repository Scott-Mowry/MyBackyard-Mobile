import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../Component/custom_buttom.dart';
import '../../../../../Component/custom_text.dart';

class ReviewSubmitted extends StatelessWidget {
  ReviewSubmitted({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AppNavigation.navigatorPop();
        AppNavigation.navigatorPop();
        AppNavigation.navigatorPop();
        return Future(() => false);
        // return Utils().onWillPop(context, currentBackPressTime: currentBackPressTime);
      },
      child: Container(
        decoration: BoxDecoration(
          color: MyColors().blackLight,
          borderRadius: BorderRadius.circular(12),
        ),
        // height: responsive.setHeight(75),
        width: 100.w,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                MyText(
                  title: 'Review has been submitted',
                  size: 24,
                  center: true,
                ),
                SizedBox(
                  height: 4.h,
                ),
                MyButton(
                  onTap: () {
                    AppNavigation.navigatorPop();
                    AppNavigation.navigatorPop();
                    AppNavigation.navigatorPop();
                    // HomeController.i.jumpTo(i: 2);
                  },
                  title: "Go to Home",
                ),
                SizedBox(
                  height: 3.5.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
