import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Utils/my_colors.dart';

class CustomToast {
  MyColors colors = MyColors();
  void showToast(
      {String? message, Toast? toastLength, int? timeInSecForIosWeb}) {
    Fluttertoast.showToast(
        msg: message ?? "",
        toastLength: toastLength ?? Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: timeInSecForIosWeb ?? 1);
  }
}
