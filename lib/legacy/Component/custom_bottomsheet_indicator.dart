import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class BottomSheetIndicator extends StatelessWidget {
  const BottomSheetIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 7,
        width: 60,
        decoration: BoxDecoration(color: CustomColors.black, borderRadius: BorderRadius.circular(200)),
      ),
    );
  }
}
