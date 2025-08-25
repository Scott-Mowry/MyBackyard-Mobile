import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_credentials.g.dart';

@CopyWith()
@JsonSerializable()
class TokenCredentials extends Equatable {
  const TokenCredentials({required this.accessToken, required this.refreshToken});

  @JsonKey(name: 'access-token', fromJson: headerFromJson, toJson: headertoJson)
  final String accessToken;

  @JsonKey(name: 'refresh-token', fromJson: headerFromJson, toJson: headertoJson)
  final String refreshToken;

  factory TokenCredentials.fromJson(Map<String, dynamic> json) => _$TokenCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$TokenCredentialsToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [accessToken, refreshToken];
}

String headerFromJson(List item) => item.first;

List headertoJson(String item) => [item];
