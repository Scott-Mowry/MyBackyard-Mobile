import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Color? shimmerBaseColor, shimmerHighlightColor;
  final bool? shimmerHighlightColorEnable;
  final Widget child;

  const CustomShimmer({
    super.key,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerHighlightColorEnable,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: shimmerHighlightColor ?? CustomColors.grey,
      baseColor: shimmerBaseColor ?? CustomColors.grey.withValues(alpha: 0.8),
      enabled: shimmerHighlightColorEnable ?? true,
      child: child,
    );
  }
}
