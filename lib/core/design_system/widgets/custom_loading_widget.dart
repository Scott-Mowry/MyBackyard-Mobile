import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  final double? height;
  final Color? color;
  final double strokeWidth;

  final Color? backgroundColor;

  const CustomLoadingWidget({super.key, this.height, this.color, this.backgroundColor, this.strokeWidth = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: backgroundColor ?? CustomColors.black.withValues(alpha: 0.3)),
      alignment: Alignment.center,
      child: Center(child: CircularProgressIndicator(color: CustomColors.primaryGreenColor, strokeWidth: strokeWidth)),
    );
  }
}
