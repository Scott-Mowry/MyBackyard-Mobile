import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomPadding extends StatelessWidget {
  final Widget? child;
  final double? horizontalPadding,verticalPadding, topPadding, bottomPadding;
  const CustomPadding({Key? key, this.child, this.horizontalPadding,this.verticalPadding,this.topPadding,this.bottomPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 5.w, vertical: verticalPadding??0)+EdgeInsets.only(top: topPadding??12.h,bottom: bottomPadding??0),
      child: child,
    );
  }
}
