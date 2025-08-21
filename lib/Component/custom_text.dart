
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatefulWidget {
  final String title;
  final String? weight;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? size, height;
  final clr;
  final toverflow;
  final bool? center;
  final int? line;
  final bool? under, cut;
  final TextAlign? align;
  final double? letterSpacing;
  final List<FontFeature>? fontFeatures;

  const MyText({
    super.key,
    required this.title,
    this.size,
    this.clr,
    this.letterSpacing,
    this.fontFeatures,
    this.weight,
    this.height,
    this.align,
    this.fontWeight,
    this.center,
    this.line,
    this.under,
    this.toverflow,
    this.fontStyle,
    this.cut,
  });

  @override
  _MyTextState createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      overflow: widget.toverflow ?? TextOverflow.visible,
      maxLines: widget.line,
      textScaleFactor: 1,
      style: GoogleFonts.poppins(
        letterSpacing: widget.letterSpacing,
        fontFeatures: widget.fontFeatures,
        height: widget.height,
        decoration:
            (widget.under == true
                ? TextDecoration.underline
                : widget.cut == true
                ? TextDecoration.lineThrough
                : TextDecoration.none),
        fontSize: widget.size,
        decorationColor: widget.clr ?? Colors.white,
        fontStyle: widget.fontStyle,
        color: widget.clr ?? Colors.black,
        fontWeight:
            widget.fontWeight ??
            (widget.weight == null
                ? FontWeight.normal
                : widget.weight == 'Bold'
                ? FontWeight.bold
                : widget.weight == 'Semi Bold'
                ? FontWeight.w600
                : FontWeight.w500),
      ),
      textAlign:
          widget.align ??
          (widget.center == null
              ? TextAlign.left
              : widget.center!
              ? TextAlign.center
              : TextAlign.left),
    );
  }
}
