import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';

class CheckBoxWidget extends StatefulWidget {
  CheckBoxWidget({Key? key,required this.onChange,required this.defaultVal,this.disableCheck}) : super(key: key);
  ValueChanged<bool> onChange;
  bool defaultVal= false;
  bool? disableCheck= false;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Theme(
        data: ThemeData(
            unselectedWidgetColor: MyColors().errorColor,
            splashColor: Colors.transparent,
            checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.resolveWith((_) => Colors.black),
              fillColor: MaterialStateProperty.resolveWith((_) => Colors.transparent),
              side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(width: 1.0, color: MyColors().primaryColor,),
              ),
            )
          // Your color
        ),
        child: Checkbox(
          splashRadius: 0,
          value: widget.defaultVal,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          //fillColor: MaterialStateProperty.all<Color>(Colors.transparent),
          activeColor: MyColors().primaryColor,

          tristate: false,
          //MaterialStateProperty.all<Color>(Colors.transparent),,
          side: BorderSide(color:MyColors().primaryColor,),
          checkColor:  MyColors().whiteColor,
          onChanged: (value) {
            if(widget.disableCheck!=true){
              setState(() {
                widget.defaultVal = !widget.defaultVal;
              });
              widget.onChange(value??false);
            }
          },
        ),
      ),
    );
  }
}
