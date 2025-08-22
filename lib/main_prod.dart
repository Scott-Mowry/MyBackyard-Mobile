import 'package:backyard/boot.dart';
import 'package:backyard/flavors.dart';

void main() {
  appBuildFlavor = AppBuildFlavorEnum.PROD;
  boot();
}
