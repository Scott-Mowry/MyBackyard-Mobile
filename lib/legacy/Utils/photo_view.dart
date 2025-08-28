import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart' as photo_view;

class PhotoView extends StatelessWidget {
  final String? path;

  const PhotoView({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.maybePop();
          },
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: .6.h, horizontal: 1.h),
            child: Image.asset(ImagePath.back, scale: 2, color: CustomColors.whiteColor),
          ),
        ),
      ),
      body: photo_view.PhotoView(imageProvider: NetworkImage(path.toString())),
    );
  }
}
