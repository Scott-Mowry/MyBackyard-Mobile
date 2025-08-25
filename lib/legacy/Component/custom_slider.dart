import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double val, min, max;
  final int? divisions;
  final Function(double)? onChange;

  const CustomSlider({
    super.key,
    required this.val,
    required this.onChange,
    required this.min,
    required this.max,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbColor: CustomColors.grey,
          trackShape: CustomTrackShape(),
          // disabledActiveTrackColor: Colors.red,
          // disabledInactiveTrackColor: Colors.red,
          activeTrackColor: CustomColors.lightGrey2,
          activeTickMarkColor: CustomColors.lightGrey2,
          inactiveTrackColor: CustomColors.grey,
          inactiveTickMarkColor: CustomColors.grey,
          trackHeight: 8,
        ),
        child: Slider(value: val, min: min, max: max, divisions: divisions ?? 19, onChanged: onChange),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
