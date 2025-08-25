import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String? title;
  final FontWeight? fontWeight;

  const ScreenTitle({super.key, this.title, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return MyText(
      title: title ?? '',
      fontWeight: fontWeight ?? FontWeight.w500,
      size: 17,
      clr: CustomColors.whiteColor,
    );
  }
}
