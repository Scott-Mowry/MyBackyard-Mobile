import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Utils/my_colors.dart';

class ScreenTitle extends StatelessWidget {
  String? title;
  FontWeight? fontWeight;
  ScreenTitle({super.key, this.title, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return MyText(title: title ?? "", fontWeight: fontWeight ?? FontWeight.w500, size: 17, clr: MyColors().whiteColor);
  }
}
