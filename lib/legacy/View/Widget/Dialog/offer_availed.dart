import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class OfferAvailedDialog extends StatelessWidget {
  final void Function() onConfirm;
  final String? title;

  const OfferAvailedDialog({super.key, required this.onConfirm, this.title});

  @override
  Widget build(BuildContext context) {
    print(title);
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                  MyText(title: 'Success', clr: CustomColors.whiteColor, fontWeight: FontWeight.w600, size: 18),
                  GestureDetector(onTap: onConfirm, child: Image.asset(ImagePath.close, scale: 2)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: 2.h,),
                  // Center(child: CircleAvatar(radius: 45, backgroundColor: MyColors().purpleColor,child:Image.asset(ImagePath.delete,scale: 3,color: MyColors().whiteColor,),)),
                  SizedBox(height: 2.h),
                  Image.asset(ImagePath.like, scale: 2),
                  SizedBox(height: 2.h),
                  MyText(title: 'Offer has been successfully availed.', size: 14, center: true),
                  SizedBox(height: 2.h),
                  textDetail(title: 'Offer', description: title ?? ''),
                  SizedBox(height: 1.h),
                  textDetail(title: 'Date', description: DateFormat('dd MMMM yyyy').format(DateTime.now())),
                  SizedBox(height: 1.h),
                  textDetail(title: 'Time', description: DateFormat('hh : mm aa').format(DateTime.now())),
                  SizedBox(height: 2.h),
                  MyButton(
                    onTap: () {
                      context.maybePop();
                      onConfirm();
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

  Row textDetail({required String title, required String description}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [MyText(title: title, size: 16, clr: Color(0xff9FA2AB)), MyText(title: description, size: 12)],
    );
  }
}
