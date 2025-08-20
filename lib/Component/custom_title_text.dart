import 'package:backyard/Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTitleText extends StatelessWidget {
  CustomTitleText({Key? key,this.title,this.leftPadding,this.size,this.colon=true}) : super(key: key);
  String? title;
  bool?colon;
  double? size,leftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding??0.w,bottom: 1.h),
      child: MyText(
        title: "$title${colon==true?":":""}",
        clr: Theme
            .of(context)
            .primaryColor,
        weight: "Semi Bold",
        size: size,
      ),
    );
  }
}
