// Injectable named tags
import 'package:backyard/flavors.dart';
import 'package:flutter/material.dart';

const kMyBackyardApiClient = 'myBackyardApiClient';
const kGoogleMapsApiClient = 'googleMapsApiClient';

// Push notification topics
late final kFcmTopicAll = '${appBuildFlavor.name.toLowerCase()}.fcm.topic.all';

// Dimensions
final kMinVisualDensity = VisualDensity(
  horizontal: VisualDensity.minimumDensity,
  vertical: VisualDensity.minimumDensity,
);

// Map
const kMinMapRadiusInMiles = 5.0;
const kMaxMapRadiusInMiles = 50.0;
const kMapRadiusFilterDivisions = 10;
const kDefaultMapRadiusInMiles = 50;

// External links
const privacyPolicyUrl = 'https://mybackyardusa.com/privacy';
const termsOfUseUrl = 'https://mybackyardusa.com/terms';
const plansUrl = 'https://mybackyardusa.com/#pricing';
