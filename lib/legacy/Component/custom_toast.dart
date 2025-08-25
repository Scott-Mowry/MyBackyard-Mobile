import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  CustomColors colors = CustomColors();
  void showToast({String? message, Toast? toastLength, int? timeInSecForIosWeb}) {
    Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
    );
  }
}
