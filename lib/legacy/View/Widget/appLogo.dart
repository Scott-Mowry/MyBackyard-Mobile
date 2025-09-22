import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatefulWidget {
  final Function? onTap;
  final double? scale;

  const AppLogo({super.key, this.onTap, this.scale});

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  @override
  Widget build(BuildContext context) {
    final isAfterHalloween = clock.now().isAfter(DateTime(2025, 11, 01));
    return Center(
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap?.call();
          }
        },
        child: Image.asset(
          isAfterHalloween ? ImagePath.appLogo : ImagePath.appLogoHalloween,
          scale: widget.scale ?? 2.5,
        ),
      ),
    );
  }
}
