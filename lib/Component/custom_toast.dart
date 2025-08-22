import 'package:backyard/Utils/my_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  MyColors colors = MyColors();
  void showToast({String? message, Toast? toastLength, int? timeInSecForIosWeb}) {
    Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
    );
  }
}
