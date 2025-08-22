import 'package:backyard/legacy/Utils/image_path.dart';
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
    return Center(
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap?.call();
          }
        },
        child: Image.asset(ImagePath.appLogo, scale: widget.scale ?? 2.5),
      ),
    );
  }
}
