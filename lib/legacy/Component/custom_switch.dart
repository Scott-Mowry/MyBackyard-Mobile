import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Utils/responsive.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitch extends StatefulWidget {
  final String? switchName, toggleValue1, toggleValue2;
  final bool? switchValue;
  final double? toggleWidth;
  final Color? toggleColor;
  final Color? inActiveColor;
  final double? height, width;
  final Function(bool) onChange, onChange2;

  const CustomSwitch({
    super.key,
    this.switchName,
    this.switchValue = true,
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
      toggleColor: widget.toggleColor ?? CustomColors.primaryGreenColor,
      padding: 3.0,
      activeColor: widget.toggleColor ?? CustomColors.greyColor.withValues(alpha: .2),
      inactiveColor: widget.inActiveColor ?? CustomColors.whiteColor,
      showOnOff: true,
      onToggle: (val) {
        widget.onChange2(val);
      },
      activeText: widget.toggleValue1 ?? '',
      inactiveText: widget.toggleValue2 ?? '',
      activeTextColor: CustomColors.blackLight,
      inactiveTextColor: CustomColors.blackLight,
      inactiveToggleColor: CustomColors.primaryGreenColor,
      activeToggleColor: CustomColors.whiteColor,
      inactiveTextFontWeight: FontWeight.w400,
      activeTextFontWeight: FontWeight.w400,
    );
  }
}
