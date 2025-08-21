import 'package:backyard/Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTitleText extends StatelessWidget {
  final String? title;
  final bool? colon;
  final double? size, leftPadding;

  const CustomTitleText({super.key, this.title, this.leftPadding, this.size, this.colon = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding ?? 0.w, bottom: 1.h),
      child: MyText(
        title: "$title${colon == true ? ":" : ""}",
        clr: Theme.of(context).primaryColor,
        weight: 'Semi Bold',
        size: size,
      ),
    );
  }
}
