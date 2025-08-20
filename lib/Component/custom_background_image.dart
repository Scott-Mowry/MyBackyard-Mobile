import 'package:flutter/material.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:sizer/sizer.dart';

class CustomBackgroundImage extends StatelessWidget {
  final Widget? child;
  final Alignment? align;
  final String? image;
  final bool? blurEffect;
  final Color? color;

  const CustomBackgroundImage({
    super.key,
    this.child,
    this.image,
    this.color,
    this.align,
    this.blurEffect = false,
  });

  @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       width: 100.sw,
  //       decoration: const BoxDecoration(
  //         // color: Colors.transparent,
  //         image: DecorationImage(
  //           // fit: BoxFit.fill,
  //             image: AssetImage(
  //               ImagePath.backgroundImage,
  //             ),
  //             fit: BoxFit.cover
  //         ),
  //       ),
  //       alignment:align??Alignment.center,
  //       child: child
  //   );
  // }

  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: color,
        image: DecorationImage(
          // fit: BoxFit.fill,
          image: AssetImage(
            image ?? ImagePath.bgImage1,
          ),
          fit: BoxFit.cover,
        ),
      ),
      alignment: align ?? Alignment.center,
      // child: child
      child: blurEffect == false
          ? Scaffold(
              body: child,
              backgroundColor: Colors.transparent,
            )
          : Scaffold(body: child),
    );
  }
}
