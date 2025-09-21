import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class CategoryNameWidget extends StatelessWidget {
  final String name;
  final double fontSize;

  const CategoryNameWidget({super.key, required this.name, this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CustomSpacer.horizontal.sm + CustomSpacer.vertical.xxs,
      decoration: BoxDecoration(color: CustomColors.primaryGreenColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: CustomTextStyle.labelSmall.copyWith(color: CustomColors.white, fontSize: fontSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}
