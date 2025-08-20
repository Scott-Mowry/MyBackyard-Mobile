import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class StateManagement {
  static List<SingleChildWidget> providersList = [
    ChangeNotifierProvider(
        create: (context) => UserController(context: context)),
    ChangeNotifierProvider(
        create: (context) => HomeController(context: context)),
  ];
}
