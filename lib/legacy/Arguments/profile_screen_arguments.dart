import 'package:backyard/core/model/user_profile_model.dart';

class ProfileScreenArguments {
  bool? isMe, isUser;
  UserProfileModel? user;
  bool? isBusinessProfile;
  ProfileScreenArguments({this.isBusinessProfile, this.isMe, this.isUser, this.user});
}
