import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomEmptyData extends StatelessWidget {
  final String? title, subTitle, image;
  final Function? onTapSubTitle;
  final Color? imageColor;
  final bool? hasLoader;
  final double? paddingVertical;

  const CustomEmptyData({
    super.key,
    this.title,
    this.image,
    this.subTitle,
    this.imageColor,
    this.hasLoader,
    this.paddingVertical,
    this.onTapSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    return hasLoader == false
        ? Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 6.h),
            child: Column(
              children: [
                MyText(title: title ?? 'Not available', size: 14, clr: Colors.grey.withValues(alpha: .5)),
                if (subTitle != null) ...[
                  GestureDetector(
                    onTap: () {
                      onTapSubTitle!();
                    },
                    child: MyText(title: subTitle!, size: 12, clr: CustomColors.fbColor, under: true),
                  ),
                ],
              ],
            ),
          ),
        )
        : Stack(
          children: [
            SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(), child: Container(height: 100.h)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (image != null) ...[Image.asset(image!, width: 6.w, color: imageColor), SizedBox(width: 3.w)],
                  MyText(title: title ?? 'Not available', size: 18),
                ],
              ),
            ),
          ],
        );
  }
}
