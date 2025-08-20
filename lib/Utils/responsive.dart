

import 'package:flutter/material.dart';

class Responsive {
  double? blockSizeHorizontal;
  double? blockSizeVertical;
  double? textRatio;

  setContext(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    textRatio = MediaQuery.of(context).textScaleFactor;
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