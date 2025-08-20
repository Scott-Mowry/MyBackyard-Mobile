import 'package:flutter/material.dart';

class ThemeButtons extends StatelessWidget {
  final String text;
  final Function onChange;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  final double? radius, fontSize;

  const ThemeButtons({Key? key, required this.text, required this.onChange, this.color, this.textColor, this.borderColor, this.borderWidth, this.elevation, this.radius,this.fontSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      // width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: ()=> onChange(

        ),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(150, 20)),
            elevation: MaterialStateProperty.all(elevation ?? 3),
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius ?? 10.0),
                    side: BorderSide(color: borderColor ?? Theme.of(context).primaryColorDark,width: borderWidth ?? 2.0)
                )
            ),

        ),
        child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor,
              letterSpacing: 1.0,
            fontSize:fontSize?? 12
          ),),
      ),
    );
  }
}