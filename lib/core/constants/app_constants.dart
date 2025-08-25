// Injectable named tags
import 'package:backyard/flavors.dart';

const kMyBackyardApiClient = 'myBackyardApiClient';

// Push notification topics
late final kFcmTopicAll = '${appBuildFlavor.name.toLowerCase()}.fcm.topic.all';
