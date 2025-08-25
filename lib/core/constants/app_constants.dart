// Injectable named tags
import 'package:backyard/flavors.dart';

const kMyBackyardApiClient = 'myBackyardApiClient';

final kUnregisteredApiRoutes = ['/users/sign_in'];

// Push notification topics
late final kFcmTopicAll = '${appBuildFlavor.name.toLowerCase()}.fcm.topic.all';
