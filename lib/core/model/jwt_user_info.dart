import 'package:backyard/core/enum/enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jwt_user_info.g.dart';

@CopyWith()
@JsonSerializable()
class JwtUserInfo extends Equatable {
  const JwtUserInfo({required this.userId, required this.roleType, required this.roleId, this.organizationId});

  final String userId;
  final UserRoleEnum roleType;
  final String roleId;
  final String? organizationId;

  factory JwtUserInfo.fromJson(Map<String, dynamic> json) => _$JwtUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$JwtUserInfoToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [userId, roleType, roleId, organizationId];
}
