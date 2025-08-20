import 'dart:developer';
import 'package:backyard/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class OfferAvailedDialog extends StatelessWidget {
  OfferAvailedDialog({required this.onYes, this.title});
  Function onYes;
  String? title;
  @override
  Widget build(BuildContext c) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      // height: responsive.setHeight(75),
      width: 100.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: MyColors().primaryColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20))),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    ImagePath.close,
                    scale: 2,
                    color: Colors.transparent,
                  ),
                  MyText(
                    title: 'Success',
                    clr: MyColors().whiteColor,
                    fontWeight: FontWeight.w600,
                    size: 18,
                  ),
                  GestureDetector(
                    onTap: () {
                      onYes(c);
                    },
                    child: Image.asset(
                      ImagePath.close,
                      scale: 2,
                    ),
                  ),
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
                  SizedBox(
                    height: 2.h,
                  ),
                  Image.asset(
                    ImagePath.like,
                    scale: 2,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyText(
                    title: 'Offer has been successfully availed.',
                    size: 14,
                    center: true,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  textDetail(title: 'Offer', description: title ?? ""),
                  SizedBox(
                    height: 1.h,
                  ),
                  textDetail(
                      title: 'Date',
                      description:
                          DateFormat("dd MMMM yyyy").format(DateTime.now())),
                  SizedBox(
                    height: 1.h,
                  ),
                  textDetail(
                      title: 'Time',
                      description:
                          DateFormat("hh : mm aa").format(DateTime.now())),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  // textDetail(title: 'Coins rewards', description: '+50'),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyButton(
                      onTap: () {
                        AppNavigation.navigatorPop();
                        log('Yaha arha h 3');
                        onYes(c);
                      },
                      title: "Continue"),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  textDetail({required String title, required String description}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          title: title,
          size: 16,
          clr: Color(0xff9FA2AB),
        ),
        MyText(
          title: description,
          size: 12,
        ),
      ],
    );
  }
}
