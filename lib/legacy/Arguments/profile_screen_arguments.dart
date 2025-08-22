import 'package:backyard/legacy/Model/user_model.dart';

class ProfileScreenArguments {
  bool? isMe, isUser;
  User? user;
  bool? isBusinessProfile;
  ProfileScreenArguments({this.isBusinessProfile, this.isMe, this.isUser, this.user});
}
