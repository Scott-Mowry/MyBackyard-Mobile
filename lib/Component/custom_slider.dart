import 'package:flutter/material.dart';

import '../Utils/my_colors.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider({Key? key,required this.val,required this.onChange,required this.min,required this.max,this.divisions}) : super(key: key);
  double val,min,max;
  int?divisions;
  final Function(double)? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
              thumbColor: MyColors().grey,
              trackShape: CustomTrackShape(),
              // disabledActiveTrackColor: Colors.red,
              // disabledInactiveTrackColor: Colors.red,
              activeTrackColor:  MyColors().lightGrey2,
              activeTickMarkColor:  MyColors().lightGrey2,
              inactiveTrackColor: MyColors().grey,
              inactiveTickMarkColor: MyColors().grey,
              trackHeight: 8
          ),
          child: Slider(
            value: val,
            min: min,
            max: max,
            divisions: divisions??19,
            onChanged:onChange,
          )
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

