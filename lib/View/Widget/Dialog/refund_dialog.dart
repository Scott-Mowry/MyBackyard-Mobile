import 'dart:ui';

import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/Widget/Dialog/request_submitted.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../Component/custom_buttom.dart';
import '../../../../../Component/custom_text.dart';

class RefundDialog extends StatelessWidget {
  RefundDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
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
              Image.asset(
                ImagePath.sad,
                scale: 2,
              ),
              SizedBox(
                height: 2.h,
              ),
              MyText(
                title: 'Penalty fee will be deducted for cancellations',
                size: 24,
                center: true,
              ),
              SizedBox(
                height: 4.h,
              ),
              MyButton(
                onTap: () {
                  AppNavigation.navigatorPop();
                  requestSubmitted(context);
                },
                title: "Refund",
                bgColor: Colors.transparent,
                textColor: MyColors().whiteColor,
                gradient: false,
              ),
              SizedBox(
                height: 2.h,
              ),
              MyButton(
                  onTap: () {
                    AppNavigation.navigatorPop();
                  },
                  gradient: false,
                  title: "Cancel"),
              SizedBox(
                height: 3.5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  requestSubmitted(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              content: RequestSubmitted(),
            ),
          );
        });
  }
}
