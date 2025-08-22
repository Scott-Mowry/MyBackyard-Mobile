import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  final String? path;

  const PhotoViewScreen({super.key, this.path});

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
            AppNavigation.navigatorPop();
          },
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: .6.h, horizontal: 1.h),
            child: Image.asset(ImagePath.back, scale: 2, color: MyColors().whiteColor),
          ),
        ),
      ),
      body: PhotoView(imageProvider: NetworkImage(path.toString())),
    );
  }
}
