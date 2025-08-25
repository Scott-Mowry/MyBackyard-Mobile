import 'package:flutter/cupertino.dart';

extension TargetPlatformExtension on TargetPlatform {
  bool get isIOS => this == TargetPlatform.iOS;

  bool get isAndroid => this == TargetPlatform.android;
}
