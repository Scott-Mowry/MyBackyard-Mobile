import 'package:flutter/material.dart';

class ThemeButtons extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  final double? radius, fontSize;

  const ThemeButtons({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.elevation,
    this.radius,
    this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      // width: MediaQuery.sizeOf(context).width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(const Size(150, 20)),
          elevation: WidgetStateProperty.all(elevation ?? 3),
          backgroundColor: WidgetStateProperty.all(color),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 10.0),
              side: BorderSide(color: borderColor ?? Theme.of(context).primaryColorDark, width: borderWidth ?? 2.0),
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor, letterSpacing: 1.0, fontSize: fontSize ?? 12),
        ),
      ),
    );
  }
}
