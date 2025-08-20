import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomRectangulatTextFormField extends StatelessWidget {
  final String? iconPath;
  final String? hintText;
  final String? title;
  final TextEditingController? controller;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onValidate;
  final TextInputType? keyType;
  final bool? obscureText;
  final FocusNode? focusNode;
  final Function()? ontapSuffix;
  final Function? onTap;
  final Color? hintTextColor, titleColor, textColor, bgColor;
  final String? suffixIconPath;
  final bool? showSuffixIcn;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool? isIcon, isSuffixIcon, showPrefixIcon;
  final double? prefixIconScale;
  final Function(String)? onFieldSubmit;
  final bool? readOnly, contact;
  final int? maxLength;

  const CustomRectangulatTextFormField({
    super.key,
    this.controller,
    this.iconPath,
    required this.hintText,
    this.title,
    this.keyType,
    this.onChanged,
    this.onValidate,
    this.prefixIconData,
    this.suffixIconData,
    this.focusNode,
    this.maxLength,
    this.titleColor,
    this.textColor,
    this.contact,
    this.onTap,
    this.hintTextColor = Colors.white,
    this.readOnly,
    this.isIcon,
    this.isSuffixIcon,
    this.obscureText = false,
    this.showPrefixIcon = true,
    this.ontapSuffix,
    this.onFieldSubmit,
    this.bgColor,
    this.suffixIconPath,
    this.showSuffixIcn = false,
    this.prefixIconScale = 3.2,
  });
  static MaskTextInputFormatter MASK_TEXT_FORMATTER_PHONE_NO =
      MaskTextInputFormatter(
          mask: '(###) ###-####',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.roboto(
      fontSize: 14,
      color: Theme.of(context).indicatorColor.withOpacity(0.8),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          height: 7.8.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: bgColor ?? MyColors().purpleColor.withOpacity(0.4),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                EdgeInsets.only(left: 0, right: 14, top: 0.4.h, bottom: 0.4.h),
            child: Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                showPrefixIcon == true
                    ? Expanded(
                        flex: 1,
                        child: isIcon == true
                            ? Icon(
                                prefixIconData,
                                color: Theme.of(context).primaryColorDark,
                                size: prefixIconScale,
                              )
                            : Image.asset(
                                iconPath!,
                                scale: prefixIconScale,
                                // color: Theme.of(context).primaryColorDark,
                              ),
                      )
                    : const SizedBox(),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        title: title ?? '',
                        clr: titleColor ?? Colors.white,
                        size: 11.sp,
                        // weight: "Semi Bold",
                      ),
                      SizedBox(height: 0.2.h),
                      TextFormField(
                        readOnly: readOnly ?? false,
                        obscureText: obscureText!,
                        obscuringCharacter: "*",
                        focusNode: focusNode,
                        onTap: () {
                          if (onTap != null) {
                            onTap?.call();
                          }
                        },
                        controller: controller,
                        keyboardType: keyType,
                        onFieldSubmitted: onFieldSubmit,
                        inputFormatters: [
                          if (contact == true) MASK_TEXT_FORMATTER_PHONE_NO,
                          LengthLimitingTextInputFormatter(maxLength),
                        ],
                        cursorColor: const Color(0xff707070),
                        cursorWidth: 1,
                        validator: onValidate,
                        style: GoogleFonts.roboto(
                          color: textColor ?? Colors.white,
                          fontSize: 11.sp,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: GoogleFonts.roboto(
                            color: hintTextColor ?? Colors.grey,
                            fontSize: 11.sp,
                          ),

                          //     hintStyle: textStyle.copyWith(
                          // fontWeight: FontWeight.w300,
                          //     color: hintTextColor?? Color(0xff8E9192),
                          // ),
                        ),
                        onChanged: onChanged,
                      )
                    ],
                  ),
                ),
                if (showSuffixIcn!)
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: ontapSuffix,
                          child: isSuffixIcon == true
                              ? Icon(
                                  suffixIconData,
                                  color: Colors.grey,
                                  size: 25,
                                )
                              : Image.asset(
                                  suffixIconPath ?? '',
                                  scale: 3,

                                  // color: AppColors.THEME_COLOR_GREY,
                                )))
              ],
            ),
          )),
    );
  }
}
