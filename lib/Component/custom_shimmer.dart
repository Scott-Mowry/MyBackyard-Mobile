import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Color? shimmerBaseColor, shimmerHighlightColor;
  final bool? shimmerHighlightColorEnable;
  final Widget child;

  CustomShimmer(
      {this.shimmerBaseColor,
        this.shimmerHighlightColor,
        this.shimmerHighlightColorEnable,
        required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        highlightColor: shimmerHighlightColor ?? MyColors().shimmerColor,
        baseColor: shimmerBaseColor ?? MyColors().shimmerBaseColor,
        enabled: shimmerHighlightColorEnable ?? true,
        child: child);
  }
}
