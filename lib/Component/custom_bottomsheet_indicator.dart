import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';

class BottomSheetIndicator extends StatelessWidget {
  const BottomSheetIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 7,
        width: 60,
        decoration: BoxDecoration(
          color: MyColors().black,
          borderRadius: BorderRadius.circular(200),
        ),
      ),
    );
  }
}
