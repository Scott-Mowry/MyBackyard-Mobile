import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:sizer/sizer.dart';

class PhoneNumberTextField extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor, iconColor, textColor;
  final bool? isBorder, isUnderLineBorder;
  final String? country;
  final bool? isReadOnly, gradient;
  final double? textFieldBorderRadius, fontSize;
  final EdgeInsets? contentPadding;
  final double? horizontalPadding, verticalPadding;
  final TextEditingController? controller;
  final Function(Country)? onCountryChanged;
  final Future<String?> Function(PhoneNumber?)? validator;
  const PhoneNumberTextField({
    super.key,
    this.controller,
    this.validator,
    this.backgroundColor,
    this.borderColor = Colors.white,
    this.isBorder = true,
    this.isReadOnly = false,
    this.isUnderLineBorder = true,
    this.textFieldBorderRadius,
    this.fontSize,
    this.contentPadding,
    this.country,
    this.iconColor,
    this.gradient,
    this.textColor,
    this.onCountryChanged,
    this.horizontalPadding,
    this.verticalPadding,
  });
  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.roboto(fontSize: 14, color: Theme.of(context).indicatorColor.withValues(alpha: 0.8));
    return IntlPhoneField(
      initialValue: null,
      initialCountryCode: country, //'IN',//country??'IN',
      invalidNumberMessage: AppStrings.PHONE_NO_INVALID_LENGTH,
      validator: validator,
      // gradient: gradient??false,
      dropdownIconPosition: IconPosition.trailing,
      dropdownTextStyle: _textStyle(),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      dropdownIcon: Icon(Icons.arrow_drop_down, color: iconColor ?? MyColors().whiteColor),
      autovalidateMode: AutovalidateMode.disabled,
      controller: controller,
      style: _textStyle(),
      decoration: InputDecoration(
        hintText: 'Phone Number',
        labelText: '   Phone Number   ',
        labelStyle: textStyle.copyWith(color: MyColors().whiteColor),
        hintStyle: GoogleFonts.roboto(
          color: textColor ?? MyColors().whiteColor,
          fontSize: 11.sp,

          // fontSize: AppSize.TEXTFIELD_FONT_SIZE,//16,
        ),

        counter: const SizedBox.shrink(),
        border: isUnderLineBorder! ? _underLineInputBorder() : _outLineInputBorder(),
        focusedBorder: isUnderLineBorder! ? _underLineInputBorder() : _outLineInputBorder(),
        enabledBorder: isUnderLineBorder! ? _underLineInputBorder() : _outLineInputBorder(),
        errorBorder: isUnderLineBorder! ? _underLineInputBorder() : _outLineInputBorder(),
        fillColor: backgroundColor ?? Colors.transparent,
        filled: true,
        // prefix: SizedBox(width: 5.w),
        // contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: verticalPadding ?? 19.h),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        errorMaxLines: 2,
        errorStyle: const TextStyle(color: Colors.red, height: 1),
      ),
      onChanged: (phone) {},
      readOnly: isReadOnly ?? false,
      // countryReadOnly: isReadOnly??false,
      onCountryChanged: onCountryChanged,

      //     (country) {
      // },
    );
  }

  TextStyle _textStyle() {
    return GoogleFonts.roboto(
      color: textColor ?? MyColors().whiteColor,
      // fontSize: fontSize??AppSize.TEXTFIELD_FONT_SIZE,//16,
    );
  }

  OutlineInputBorder _outLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(textFieldBorderRadius ?? 10),
      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
    );
  }

  dynamic _underLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        width: 1,
        color: borderColor ?? MyColors().whiteColor,
        style: isBorder == true ? BorderStyle.solid : BorderStyle.none,
      ),
    );
  }
}
