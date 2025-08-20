import 'package:backyard/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../Utils/responsive.dart';
import '../Utils/my_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyTextField extends StatefulWidget {
  final String? title;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final Function(String)? onFieldSubmit;
  final Function(String)? onChanged;
  final String? hintText;
  final Function? onTapSuffixIcon;
  final Function? onTap;
  final Function? onTapPrefixIcon;
  final suffixIconData;
  final bool? multiIcon;
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
  final bool? obscureText;
  final InputDecoration? inputDecoration;
  final Widget? suffixIcons;
  final bool? fullBorder;
  final bool? validate;
  bool showLabel = false;
  final bool? readOnly, cardFormat, cardExpiration, contact, onlyNumber, numberWithDecimal;
  final int? maxLength, minLines, maxLines;
  final bool? filed;
  final bool? enable;
  final double? elevation, fontSize;
  final double? prefixIconSize;
  final String? prefixText;
  final BoxConstraints? suffixIconConstraints;
  final TextInputAction? inputAction;
  final TextInputFormatter? inputFormate;
  final TextAlign? textAlign;
  static const Color _textFieldThemeColor = Color(0xff707070);

  MyTextField({
    super.key,
    this.onChanged,
    this.inputAction,
    this.elevation,
    this.maxLength,
    this.textAlign,
    this.suffixIconConstraints,
    this.horizontalPadding,
    this.width,
    this.validate,
    this.showLabel = false,
    this.inputFormate,
    this.onlyNumber,
    this.cardExpiration,
    this.fontSize,
    this.prefixText,
    this.height,
    this.contact,
    this.numberWithDecimal,
    this.fullBorder,
    this.borderColor = Colors.white,
    this.inputDecoration,
    this.cardFormat,
    this.multiIcon,
    this.title,
    this.onTap,
    this.controller,
    this.verticalPadding,
    this.borderRadius = 10,
    this.validation,
    this.onFieldSubmit,
    this.hintText,
    this.onTapSuffixIcon,
    this.suffixIconData,
    this.prefixIconData,
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
    this.readOnly,
    this.filed,
    this.minLines,
    this.maxLines,
    this.enable,
  });

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<MyTextField> {
  MyColors colors = MyColors();
  Responsive responsive = Responsive();
  static MaskTextInputFormatter MASK_TEXT_FORMATTER_PHONE_NO = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.roboto(fontSize: 14, color: Theme.of(context).indicatorColor.withOpacity(0.8));
    responsive.setContext(context);
    return Container(
      // height: widget.height??7.h,
      width: widget.width,
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: colors.primaryColor.withOpacity(0.7),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ), //alignment: Alignment.center,
      child: TextFormField(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap?.call();
          }
        },
        textAlign: widget.textAlign ?? TextAlign.start,
        enabled: widget.enable,
        readOnly: widget.readOnly ?? false,
        obscureText: widget.obscureText!,
        obscuringCharacter: "*",
        // maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        minLines: widget.minLines ?? 1,
        maxLines: widget.maxLines ?? 1,
        textCapitalization: TextCapitalization.sentences,
        focusNode: widget.focusNode,
        // validator: widget.validator!,
        validator: widget.validation,
        cursorWidth: 1,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: widget.cursorColor,
        // inputFormatters:widget.inputFormate!=null?[widget.inputFormate!]:null ,
        inputFormatters: [
          if (widget.contact == true) MASK_TEXT_FORMATTER_PHONE_NO,
          if (widget.cardFormat == true || widget.cardExpiration == true) FilteringTextInputFormatter.digitsOnly,
          if (widget.cardFormat == true) CardNumberFormatter(),
          if (widget.cardExpiration == true) CardExpirationFormatter(),
          if (widget.onlyNumber == true) FilteringTextInputFormatter.digitsOnly,
          if (widget.numberWithDecimal == true) FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          LengthLimitingTextInputFormatter(widget.maxLength),
          if (widget.inputFormate != null) (widget.inputFormate!),
        ],
        autofocus: false,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        style: GoogleFonts.roboto(
          color: widget.textColor,
          fontSize: widget.fontSize ?? (Utils.isTablet ? 6.sp : 11.sp),
        ),
        onFieldSubmitted: widget.onFieldSubmit,
        decoration:
            widget.inputDecoration ??
            InputDecoration(
              // counter:  (widget.counter==true)?const SizedBox():null,
              hoverColor: Colors.white,
              labelText: widget.showLabel == true ? '   ${widget.title ?? widget.hintText}   ' : null,
              labelStyle: textStyle.copyWith(color: widget.hintTextColor),
              hintText: widget.hintText,
              fillColor: widget.backgroundColor ?? MyColors().secondaryColor,
              filled: true,
              // hintStyle: textStyle.copyWith(
              //   fontWeight: FontWeight.w300,
              //   color: widget.hintTextColor ?? colors.hintColor,
              //   fontSize: widget.fontSize??null
              // ),
              hintStyle: GoogleFonts.roboto(
                color: widget.hintTextColor ?? Colors.grey,
                fontSize: Utils.isTablet ? 6.sp : 11.sp,
                fontStyle: FontStyle.italic,
              ),

              // errorStyle: textStyle.copyWith(
              //     fontWeight: FontWeight.w300,
              //     color: widget.hintTextColor ?? colors.hintColor,
              //     fontSize: 14),
              // contentPadding: EdgeInsets.symmetric(
              //     horizontal: widget.horizontalPadding==null?
              //     (widget.fullBorder == false
              //         ? 0
              //         : 20):widget.horizontalPadding!,
              //     vertical: widget.verticalPadding==null?
              //     (widget.fullBorder == false
              //         ? responsive.setHeight(1.9)
              //         : responsive.setHeight(1.9)):widget.verticalPadding!
              // ),
              contentPadding: EdgeInsets.only(
                top: 17,
                bottom: 17,
                left: 14,
                right: widget.suffixIconData == null ? 14 : 0,
              ),
              prefixText: widget.prefixText ?? "",
              // vertical: widget.fullBorder == false ? 15 : 2),
              suffixIcon: widget.suffixIcons,
              // widget.suffixIconData == null
              //     ? null
              //     : GestureDetector(
              //         onTap: () {
              //           widget.onTapSuffixIcon!();
              //         },
              //         child: widget.suffixIconData),
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
                  (widget.fullBorder == true || widget.fullBorder == null)
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
              // suffix: widget.suffixIcons,
              suffixIconConstraints: widget.suffixIconConstraints,
              enabledBorder:
                  (widget.fullBorder == true || widget.fullBorder == null)
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
                  (widget.fullBorder == true || widget.fullBorder == null)
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
                  (widget.fullBorder == true || widget.fullBorder == null)
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
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
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
