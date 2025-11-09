import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({super.key, required this.imageUrl, this.height, this.width, this.fit});

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      progressIndicatorBuilder: (context, _, progress) {
        final bytesLoaded = progress.downloaded;
        final totalBytes = progress.totalSize ?? 1;
        final progressPercentage = bytesLoaded / totalBytes;
        return Center(
          child: Padding(
            padding: CustomSpacer.all.xs,
            child: CircularProgressIndicator(value: progressPercentage, strokeWidth: 2),
          ),
        );
      },
      errorWidget: (_, __, ___) {
        return Center(
          child: Container(
            color: CustomColors.white,
            child: Padding(
              padding: CustomSpacer.all.xs,
              child: Icon(Icons.broken_image_outlined, color: CustomColors.grey.withValues(alpha: 0.1), size: 48),
            ),
          ),
        );
      },
    );
  }
}
