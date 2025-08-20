import 'package:backyard/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Component/custom_text.dart';
import '../Utils/my_colors.dart';

class MyButton extends StatelessWidget {
  double? height, width, fontSize, radius, horPadding;
  String? title, weight, prefixIconPath;
  Color? bgColor, borderColor, textColor;
  Function? onTap;
  bool gradient = false, showPrefix;
  IconData? prefixIconData;
  Color? prefixIconColor;
  bool? loading;
  double? prefixIconSize;
  MainAxisAlignment mainAxisAlignment;

  MyButton({
    super.key,
    this.height,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.prefixIconSize,
    this.prefixIconData,
    this.prefixIconColor,
    this.borderColor,
    this.textColor,
    this.radius,
    this.horPadding,
    this.showPrefix = false,
    this.fontSize,
    this.loading,
    this.gradient = false,
    this.weight,
    this.width,
    this.onTap,
    this.prefixIconPath,
    this.title,
    this.bgColor,
  });

  MyColors colors = MyColors();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap?.call();
        }
      },
      child: Container(
        height: height ?? 55,
        width: width ?? double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horPadding ?? 15),
        // margin: EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: bgColor ?? MyColors().black,
          gradient:
              gradient == true
                  ? LinearGradient(
                    colors: [MyColors().primaryColor, MyColors().primaryColor2],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,

                    // begin: Alignment(0.0, 0.0),
                    // end: Alignment(0.2, 2.5),
                    // stops: [ 0.02, 0.4],
                    // transform: GradientRotation(math.pi*5 / 5),
                  )
                  : null,
          borderRadius: BorderRadius.circular(radius ?? 25),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            if (loading ?? false) ...[
              const Spacer(),
              CircularProgressIndicator(color: MyColors().greenColor),
              const Spacer(),
            ] else ...[
              showPrefix == true
                  ? prefixIconData != null
                      ? Icon(prefixIconData, size: prefixIconSize, color: prefixIconColor)
                      : Image.asset(prefixIconPath ?? '', scale: prefixIconSize ?? 3, color: prefixIconColor)
                  : Container(),
              SizedBox(width: showPrefix == true ? 10 : 0),
              Flexible(
                child: Padding(
                  padding: prefixIconData != null ? const EdgeInsets.only(left: 5.0) : const EdgeInsets.only(left: 0),
                  child: MyText(
                    toverflow: TextOverflow.ellipsis,
                    title: title!,
                    clr: textColor ?? Colors.white,
                    weight: weight,
                    fontWeight: FontWeight.w600,
                    size: fontSize ?? (Utils.isTablet ? 7.sp : 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
