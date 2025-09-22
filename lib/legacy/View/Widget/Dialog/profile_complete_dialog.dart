import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileCompleteDialog extends StatefulWidget {
  final void Function() onConfirm;

  const ProfileCompleteDialog({super.key, required this.onConfirm});

  @override
  State<ProfileCompleteDialog> createState() => _ProfileCompleteDialogState();
}

class _ProfileCompleteDialogState extends State<ProfileCompleteDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      // height: responsive.setHeight(75),
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
                  Image.asset(ImagePath.close, scale: 2, color: Colors.transparent),
                  MyText(title: 'Successfully', clr: CustomColors.whiteColor, fontWeight: FontWeight.w600, size: 18),
                  GestureDetector(
                    onTap: () {
                      context.maybePop();
                      widget.onConfirm();
                    },
                    child: Image.asset(ImagePath.close, scale: 2),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 2.h),
                  Image.asset(ImagePath.like, scale: 2),
                  SizedBox(height: 2.h),
                  MyText(title: 'Your profile has been successfully created.', size: 14, center: true),
                  SizedBox(height: 2.h),
                  MyButton(
                    onTap: () {
                      context.maybePop();
                      widget.onConfirm();
                    },
                    title: 'Continue',
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
