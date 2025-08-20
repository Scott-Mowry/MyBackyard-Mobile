import 'package:backyard/Model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Model/category_product_model.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropDown2 extends StatelessWidget {
  final CategoryModel? dropdownValue;
  final String? hintText;
  final Widget? prefix;
  final List<CategoryModel>? dropDownData;
  final Function(CategoryModel?)? onChanged;
  final double? width,
      fontSize,
      dropDownWidth,
      buttonPadding,
      menuItemPadding,
      horizontalPadding,
      verticalPadding;
  final Color? borderColor, bgColor;
  final EdgeInsets? contentPadding;
  final Offset? offset;
  final bool? showBorder;
  final String? Function(CategoryModel?)? validator;

  const CustomDropDown2(
      {Key? key,
      this.dropDownData,
      this.borderColor = Colors.transparent,
      this.dropdownValue,
      this.width,
      this.onChanged,
      this.fontSize = 15,
      this.hintText,
      this.bgColor,
      this.verticalPadding,
      this.horizontalPadding,
      this.validator,
      this.prefix,
      this.showBorder = false,
      this.contentPadding,
      this.menuItemPadding,
      this.dropDownWidth,
      this.buttonPadding,
      this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<CategoryModel>(
        style: GoogleFonts.roboto(
          fontSize: 14,
          color: MyColors().black,
        ),
        validator: validator!,
        decoration: InputDecoration(
          isDense: true,
          prefix: prefix,
          contentPadding: contentPadding ??
              EdgeInsets.only(
                  left: horizontalPadding ?? 2.w,
                  top: verticalPadding ?? 1.5.h,
                  bottom: verticalPadding ?? 1.5.h),
          fillColor: bgColor ?? MyColors().whiteColor,
          border: _outlineInputBorder(),
          enabledBorder: _outlineInputBorder(),
          focusedBorder: _outlineInputBorder(),
          errorBorder: _outlineInputBorder(),
          errorStyle: _errorStyle(),
          filled: true,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: menuItemPadding ?? 2.w),
        ),
        iconStyleData: const IconStyleData(
            // icon: Padding(
            //   padding: EdgeInsets.only(right: 16.w),
            //   child: Image.asset(AssetPath.DROPDOWN_ICON, scale: 4),
            // ),
            icon: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.expand_more_rounded),
        )

            // iconSize: 30,
            ),
        isExpanded: true,
        items: dropDownData!
            .map((item) => DropdownMenuItem<CategoryModel>(
                  value: item,
                  child:
                      _text(text: item.categoryName, color: MyColors().black),
                ))
            .toList(),
        value: dropdownValue,
        onChanged: (CategoryModel? newValue) {
          onChanged?.call(newValue);
          print(newValue?.categoryName);
        },
        hint: _text(text: hintText, fontWeight: FontWeight.w400),
        buttonStyleData: const ButtonStyleData(
            // padding: EdgeInsets.symmetric(vertical: 7.w),
            //width: 0.5.sw,
            ),
        dropdownStyleData: DropdownStyleData(
          // padding: EdgeInsets.only(left: horizontalPadding ?? 5.w),
          elevation: 1,

          width: dropDownWidth,
          // width: dropDownWidth ?? 0.813.sw,
          offset: offset ?? const Offset(-2.5, -10),
          isOverButton: false,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 2, color: Colors.transparent),
            color: MyColors().whiteColor,
          ),
          
        ),
        
      ),
    );
  }

  TextStyle _errorStyle() {
    return const TextStyle(
      color: Colors.red,
      height: 0.7,
    );
  }

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
          width: 1,
          style: showBorder == true ? BorderStyle.solid : BorderStyle.none,
          color: borderColor ?? Colors.transparent),
    );
  }

  Widget _text({String? text, Color? color, FontWeight? fontWeight}) {
    return MyText(
      title: text ?? "",
      size: fontSize,
      // textAlign: TextAlign.start,
      clr: color ?? MyColors().black,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }
}
