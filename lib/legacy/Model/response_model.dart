import 'dart:convert';

import 'package:backyard/core/model/user_profile_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

@JsonSerializable()
class ResponseModel {
  @JsonKey(fromJson: intToBool, toJson: boolToInt, defaultValue: false)
  final bool status;
  final String? message;
  final dynamic data;

  const ResponseModel({this.status = false, required this.message, required this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
