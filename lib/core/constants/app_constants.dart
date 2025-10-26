// Injectable named tags
import 'package:backyard/core/helper/target_platform_helper.dart';
import 'package:backyard/flavors.dart';
import 'package:flutter/foundation.dart';
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

// Webview user agents
@visibleForTesting
const kIosWebviewUserAgent =
    'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1';

@visibleForTesting
const kAndroidWebviewUserAgent =
    'Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

final kWebviewUserAgent = defaultTargetPlatform.isIOS ? kIosWebviewUserAgent : kAndroidWebviewUserAgent;

const kGenericExceptionMessage = 'Oh no! Something went wrong.';
