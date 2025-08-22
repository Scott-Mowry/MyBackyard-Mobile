import 'package:backyard/core/firebase_options/firebase_options_prod.dart' as firebase_options_prod;
import 'package:backyard/core/firebase_options/firebase_options_stg.dart' as firebase_options_stg;
import 'package:backyard/flavors.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseOptions get currentFirebasePlatform => switch (appBuildFlavor) {
  AppBuildFlavorEnum.PROD => firebase_options_prod.DefaultFirebaseOptions.currentPlatform,
  AppBuildFlavorEnum.STG => firebase_options_stg.DefaultFirebaseOptions.currentPlatform,
};
