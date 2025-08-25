import 'dart:io';
import 'package:backyard/core/enum/enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_form.g.dart';

@CopyWith()
@JsonSerializable()
class SignUpForm extends Equatable {
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? zipCode;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? isPushNotify;
  final UserRoleEnum? role;

  // Business-specific fields (optional for customers)
  final String? description;
  final String? subId;
  final int? categoryId;
  final List<BusinessScheduling>? days;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? confirmPassword;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? profileImage;

  const SignUpForm({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.zipCode,
    this.address,
    this.latitude,
    this.longitude,
    this.isPushNotify,
    this.role,
    this.description,
    this.subId,
    this.categoryId,
    this.days,
    this.confirmPassword,
    this.profileImage,
  });

  factory SignUpForm.fromJson(Map<String, dynamic> json) => _$SignUpFormFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpFormToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [
    email,
    password,
    firstName,
    lastName,
    phone,
    zipCode,
    address,
    latitude,
    longitude,
    isPushNotify,
    role,
    description,
    subId,
    categoryId,
    days,
    confirmPassword,
    profileImage,
  ];
}

@CopyWith()
@JsonSerializable()
class BusinessScheduling extends Equatable {
  final String? day;
  final String? startTime;
  final String? endTime;

  const BusinessScheduling({this.day, this.startTime, this.endTime});

  factory BusinessScheduling.fromJson(Map<String, dynamic> json) => _$BusinessSchedulingFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessSchedulingToJson(this);

  @override
  List<Object?> get props => [day, startTime, endTime];
}
