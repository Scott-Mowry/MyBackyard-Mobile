import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:backyard/Utils/image_path.dart';

class AppLogo extends StatefulWidget {
  AppLogo({Key? key, this.onTap, this.scale}) : super(key: key);
  Function? onTap;
  double? scale;

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
        child: Image.asset(
          ImagePath.appLogo,
          scale: widget.scale ?? 2.5,
        ),
      ),
    );
  }
}
