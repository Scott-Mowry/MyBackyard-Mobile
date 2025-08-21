import 'package:flutter/material.dart';

class Responsive {
  double? blockSizeHorizontal;
  double? blockSizeVertical;
  double? textRatio;

  void setContext(context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    textRatio = MediaQuery.textScaleFactorOf(context);
    blockSizeHorizontal = width / 100; // 4
    blockSizeVertical = height / 100; // 6
  }

  double setWidth(val) {
    return blockSizeHorizontal! * val;
  }

  double setHeight(val) {
    return blockSizeVertical! * val;
  }

  double setTextScale(val) {
    return textRatio! * val;
  }

  double setFormLabelWidth() {
    return setWidth(2);
  }

  double setFormLabelHeight() {
    return setHeight(2);
  }
}
