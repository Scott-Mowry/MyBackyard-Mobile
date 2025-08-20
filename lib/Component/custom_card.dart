import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';

class CustomCard extends StatelessWidget {
  CustomCard({super.key,required this.child,this.padding,this.elevation,this.margin});
  Widget child;
  EdgeInsets? padding,margin;
  double? elevation;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: margin,
      elevation: elevation??3,
      color: MyColors().whiteColor,child: Padding(
         padding: padding??EdgeInsets.all(2.5.w),
        child: child,
      ),);
  }
}
