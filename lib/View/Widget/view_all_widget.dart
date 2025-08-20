import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';
import '../../Component/custom_text.dart';

class ViewAll extends StatelessWidget {
  ViewAll(
      {Key? key,
      this.title,
      this.onTap,
      this.trailing,
      this.showTrailing = true})
      : super(key: key);
  String? title;
  Function? onTap;
  Widget? trailing;
  bool showTrailing = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: MyText(
          title: title ?? "",
          size: 20,
          clr: MyColors().whiteColor,
          fontWeight: FontWeight.w700,
        )),
        if (showTrailing) ...[
          SizedBox(
            width: 4.w,
          ),
          InkWell(
              onTap: () {
                onTap?.call();
              },
              child: trailing ??
                  MyText(
                      title: "View All",
                      size: 16,
                      under: true,
                      clr: MyColors().whiteColor,
                      fontWeight: FontWeight.w700)),
        ],
      ],
    );
  }
}
