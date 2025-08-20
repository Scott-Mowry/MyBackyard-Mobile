import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomEmptyData extends StatelessWidget {
  CustomEmptyData(
      {Key? key,
      this.title,
      this.image,
      this.subTitle,
      this.imageColor,
      this.hasLoader,
      this.paddingVertical,
      this.onTapSubTitle})
      : super(key: key);
  String? title, subTitle, image;
  Function? onTapSubTitle;
  Color? imageColor;
  bool? hasLoader;
  double? paddingVertical;

  @override
  Widget build(BuildContext context) {
    return hasLoader == false
        ? Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 6.h),
              child: Column(
                children: [
                  MyText(
                      title: title ?? "Not available",
                      size: 14,
                      clr: Colors.grey.withOpacity(.5)),
                  if (subTitle != null) ...[
                    GestureDetector(
                      onTap: () {
                        onTapSubTitle!();
                      },
                      child: MyText(
                        title: subTitle!,
                        size: 12,
                        clr: MyColors().fbColor,
                        under: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        : Stack(
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: 100.h,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (image != null) ...[
                      Image.asset(
                        image!,
                        width: 6.w,
                        color: imageColor,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                    ],
                    MyText(
                      title: title ?? "Not available",
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
