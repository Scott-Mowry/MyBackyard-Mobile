import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sizer/sizer.dart';

const _textFieldThemeColor = Color(0xff707070);

class CustomTextFormField extends StatefulWidget {
  final String? title;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? horizontalPadding;
  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final Function(String)? onFieldSubmit;
  final Function(String)? onChanged;
  final String? hintText;
  final Function? onTapSuffixIcon;
  final Function? onTap;
  final Function? onTapPrefixIcon;
  final IconData? suffixIconData;
  final IconData? prefixIconData;
  final FocusNode? focusNode;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final Color? cursorColor;
  final Color? textColor;
  final Color? prefixIconColor;
  final Color? sufixIconColor;
  final Color? borderColor;
  final Widget? prefixWidget;
  final TextInputType? inputType;
  final bool obscureText;
  final InputDecoration? inputDecoration;
  final Widget? suffixIcons;
  final bool fullBorder;
  final bool showLabel;
  final bool readOnly, cardFormat, cardExpiration, contact, onlyNumber, numberWithDecimal;
  final int? maxLength, minLines, maxLines;
  final bool filed;
  final bool enable;
  final bool autoCorrect;
  final double? fontSize;
  final double? prefixIconSize;
  final String? prefixText;
  final BoxConstraints? suffixIconConstraints;
  final TextInputAction? inputAction;
  final TextInputFormatter? inputFormate;
  final TextAlign? textAlign;

  const CustomTextFormField({
    super.key,
    this.height,
    this.onChanged,
    this.inputAction,
    this.maxLength,
    this.textAlign,
    this.suffixIconConstraints,
    this.onTapSuffixIcon,
    this.horizontalPadding,
    this.width,
    this.showLabel = false,
    this.inputFormate,
    this.onlyNumber = false,
    this.cardExpiration = false,
    this.fontSize,
    this.prefixText,
    this.contact = false,
    this.numberWithDecimal = false,
    this.fullBorder = true,
    this.borderColor = Colors.white,
    this.inputDecoration,
    this.cardFormat = false,
    this.title,
    this.onTap,
    this.controller,
    this.borderRadius = 10,
    this.validation,
    this.onFieldSubmit,
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.prefixIconSize,
    this.onTapPrefixIcon,
    this.focusNode,
    this.backgroundColor,
    this.hintTextColor = const Color(0xff374856),
    this.cursorColor = _textFieldThemeColor,
    this.textColor = Colors.black,
    this.prefixIconColor,
    this.sufixIconColor = _textFieldThemeColor,
    this.prefixWidget,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcons,
    this.readOnly = false,
    this.filed = false,
    this.minLines,
    this.maxLines,
    this.enable = true,
    this.autoCorrect = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  MyColors colors = MyColors();
  Responsive responsive = Responsive();
  static MaskTextInputFormatter phoneNumberMask = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.roboto(fontSize: 14, color: Theme.of(context).indicatorColor.withValues(alpha: 0.8));
    responsive.setContext(context);
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        onTap: widget.onTap != null ? () => widget.onTap!() : null,
        textAlign: widget.textAlign ?? TextAlign.start,
        enabled: widget.enable,
        autocorrect: widget.autoCorrect,

        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        obscuringCharacter: '*',
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        minLines: widget.minLines ?? 1,
        maxLines: widget.maxLines ?? 1,
        focusNode: widget.focusNode,
        validator: widget.validation,
        cursorWidth: 1,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: widget.cursorColor,
        inputFormatters: [
          if (widget.contact == true) phoneNumberMask,
          if (widget.cardFormat == true || widget.cardExpiration == true) FilteringTextInputFormatter.digitsOnly,
          if (widget.cardFormat == true) CardNumberFormatter(),
          if (widget.cardExpiration == true) CardExpirationFormatter(),
          if (widget.onlyNumber == true) FilteringTextInputFormatter.digitsOnly,
          if (widget.numberWithDecimal == true) FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          LengthLimitingTextInputFormatter(widget.maxLength),
          if (widget.inputFormate != null) (widget.inputFormate!),
        ],
        autofocus: false,
        controller: widget.controller,
        style: GoogleFonts.roboto(color: widget.textColor, fontSize: 16.sp),
        onFieldSubmitted: widget.onFieldSubmit,
        decoration:
            widget.inputDecoration ??
            InputDecoration(
              hoverColor: Colors.white,
              labelText: widget.showLabel == true ? '   ${widget.title ?? widget.hintText}   ' : null,
              labelStyle: textStyle.copyWith(color: widget.hintTextColor),
              hintText: widget.hintText,
              fillColor: widget.backgroundColor ?? MyColors().secondaryColor,
              filled: true,
              hintStyle: GoogleFonts.roboto(color: widget.hintTextColor ?? Colors.grey, fontSize: 16.sp),
              contentPadding: EdgeInsets.only(
                top: 17,
                bottom: 17,
                left: 14,
                right: widget.suffixIconData == null ? 14 : 0,
              ),
              prefixText: widget.prefixText ?? '',
              suffixIcon: widget.suffixIcons,
              prefixIcon:
                  widget.prefixWidget ??
                  (widget.prefixIconData == null
                      ? null
                      : GestureDetector(
                        onTap: () {
                          widget.onTapPrefixIcon!();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: widget.horizontalPadding ?? 0),
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.setHeight(0.3),
                            horizontal: responsive.setWidth(5),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: widget.filed == true ? colors.prefixContainerColor : Colors.transparent,
                          ),
                          child: Icon(
                            widget.prefixIconData,
                            color: widget.prefixIconColor ?? const Color(0xffFF6D09),
                            size: widget.prefixIconSize != null ? responsive.setWidth(widget.prefixIconSize) : null,
                          ),
                        ),
                      )),
              focusedBorder:
                  widget.fullBorder
                      ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : MyColors().prefixContainerColor,
                          width: 1,
                        ),
                      )
                      : UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : widget.textColor!,
                          width: 1,
                        ),
                      ),
              suffixIconConstraints: widget.suffixIconConstraints,
              enabledBorder:
                  widget.fullBorder
                      ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : MyColors().prefixContainerColor,
                          width: 1,
                        ),
                      )
                      : UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : MyColors().hintColor,
                          width: 1.5,
                        ),
                      ),
              disabledBorder:
                  widget.fullBorder
                      ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : MyColors().hintColor,
                          width: 1,
                        ),
                      )
                      : UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : MyColors().hintColor,
                          width: 1,
                        ),
                      ),
              border:
                  widget.fullBorder == true
                      ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : MyColors().hintColor,
                          width: 1,
                        ),
                      )
                      : UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor != null ? widget.borderColor! : MyColors().hintColor,
                          width: 1,
                        ),
                      ),
              errorMaxLines: 3,
              errorStyle: GoogleFonts.roboto(color: Theme.of(context).colorScheme.error, fontSize: 16.sp),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
                gapPadding: 30,
              ),
            ),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue previousValue, TextEditingValue nextValue) {
    final inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    final bufferString = StringBuffer();
    for (var i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      final nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    final string = bufferString.toString();
    return nextValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    var valueToReturn = '';

    for (var i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      final nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newValueString.length && !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(TextPosition(offset: valueToReturn.length)),
    );
  }
}
