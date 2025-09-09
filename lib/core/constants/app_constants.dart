// Injectable named tags
import 'package:backyard/flavors.dart';
import 'package:flutter/material.dart';

const kMyBackyardApiClient = 'myBackyardApiClient';

// Push notification topics
late final kFcmTopicAll = '${appBuildFlavor.name.toLowerCase()}.fcm.topic.all';

// Dimensions
final kMinVisualDensity = VisualDensity(
  horizontal: VisualDensity.minimumDensity,
  vertical: VisualDensity.minimumDensity,
);

// External links
const privacyPolicyUrl = 'https://mybackyardusa.com/privacy';
const termsOfUseUrl = 'https://mybackyardusa.com/terms';
const aboutUsUrl = 'https://mybackyardusa.com/#about';
