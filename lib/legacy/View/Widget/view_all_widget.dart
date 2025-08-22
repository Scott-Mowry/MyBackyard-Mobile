import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ViewAll extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final Widget? trailing;
  final bool showTrailing;

  const ViewAll({super.key, this.title, this.onTap, this.trailing, this.showTrailing = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: MyText(title: title ?? '', size: 20, clr: MyColors().whiteColor, fontWeight: FontWeight.w700)),
        if (showTrailing) ...[
          SizedBox(width: 4.w),
          InkWell(
            onTap: () {
              onTap?.call();
            },
            child:
                trailing ??
                MyText(
                  title: 'View All',
                  size: 16,
                  under: true,
                  clr: MyColors().whiteColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ],
    );
  }
}
