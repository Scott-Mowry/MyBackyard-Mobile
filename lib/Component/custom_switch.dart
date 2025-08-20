import 'package:backyard/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/responsive.dart';

class CustomSwitch extends StatefulWidget {
  String? switchName, toggleValue1, toggleValue2;
  bool? switchValue = true;
  double? toggleWidth;
  Color? toggleColor;
  Color? inActiveColor;
  double? height, width;
  final Function(bool) onChange, onChange2;
  CustomSwitch({
    super.key,
    this.switchName,
    this.switchValue,
    this.toggleValue1,
    this.inActiveColor,
    this.height,
    this.width,
    this.toggleValue2,
    this.toggleWidth,
    this.toggleColor,
    required this.onChange,
    required this.onChange2,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  Responsive responsive = Responsive();

  @override
  Widget build(BuildContext context) {
    responsive.setContext(context);
    return FlutterSwitch(
      width: responsive.setWidth(widget.width ?? (Utils.isTablet ? 7 : 12)),
      height: responsive.setHeight(widget.height ?? (Utils.isTablet ? 2.7 : 3.2)),
      valueFontSize: 10,
      toggleSize: responsive.setTextScale(20),
      value: widget.switchValue ?? false,
      borderRadius: 30.0,
      toggleColor: widget.toggleColor ?? MyColors().primaryColor2,
      padding: 3.0,
      activeColor: widget.toggleColor ?? MyColors().greyColor.withOpacity(.2),
      inactiveColor: widget.inActiveColor ?? MyColors().whiteColor,
      showOnOff: true,
      onToggle: (val) {
        widget.onChange2(val);
      },
      activeText: widget.toggleValue1 ?? '',
      inactiveText: widget.toggleValue2 ?? '',
      activeTextColor: MyColors().blackLight,
      inactiveTextColor: MyColors().blackLight,
      inactiveToggleColor: MyColors().primaryColor,
      activeToggleColor: MyColors().whiteColor,
      inactiveTextFontWeight: FontWeight.w400,
      activeTextFontWeight: FontWeight.w400,
    );
  }
}
