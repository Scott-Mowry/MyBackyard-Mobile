import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/legacy/Model/day_schedule.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@CopyWith()
@JsonSerializable()
class UserProfileModel extends Equatable {
  @JsonKey(fromJson: intFromJson)
  final int? id;

  final UserRoleEnum? role;
  final String? name;
  final String? profileImage;
  final String? zipCode;
  final String? address;

  @JsonKey(fromJson: doubleFromJson)
  final double? latitude;

  @JsonKey(fromJson: doubleFromJson)
  final double? longitude;

  final String? email;
  final String? bearerToken;
  final String? emailOtp;
  final String? emailVerifiedAt;
  final String? phone;

  @JsonKey(fromJson: intToBool, toJson: boolToInt, defaultValue: false)
  final bool isProfileCompleted;

  @JsonKey(fromJson: intToBool, toJson: boolToInt, defaultValue: false)
  final bool isPushNotify;

  final String? deviceType;
  final String? deviceToken;
  final String? socialType;
  final String? socialToken;

  @JsonKey(fromJson: intFromJson)
  final int? categoryId;

  final String? description;

  @JsonKey(fromJson: _daysFromJson)
  final List<BusinessSchedulingModel>? days;

  @JsonKey(fromJson: intToBool, toJson: boolToInt, defaultValue: false)
  final bool isBlocked;

  @JsonKey(fromJson: intToBool, toJson: boolToInt, defaultValue: false)
  final bool isVerified;

  @JsonKey(fromJson: intToBool, toJson: boolToInt, defaultValue: false)
  final bool isForgot;

  final String? status;
  final int? subId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? offerCount;

  const UserProfileModel({
    this.id,
    this.role,
    this.name,
    this.profileImage,
    this.bearerToken,
    this.zipCode,
    this.address,
    this.latitude,
    this.longitude,
    this.days,
    this.description,
    this.categoryId,
    this.email,
    this.emailOtp,
    this.emailVerifiedAt,
    this.phone,
    this.subId,
    this.isProfileCompleted = false,
    this.isPushNotify = false,
    this.deviceType,
    this.deviceToken,
    this.socialType,
    this.socialToken,
    this.isBlocked = false,
    this.isVerified = false,
    this.isForgot = false,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.offerCount,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  static List<BusinessSchedulingModel>? _daysFromJson(dynamic json) {
    if (json == null) return [];
    return sortingDays(List<BusinessSchedulingModel>.from(json.map((x) => BusinessSchedulingModel.fromJson(x))));
  }

  static List<BusinessSchedulingModel> sortingDays(List<BusinessSchedulingModel> schedules) {
    final days = WeekDayEnum.values.map((e) => e.name).toList();
    final list = List.of(schedules);

    int daysSorting(String val) {
      return switch (val) {
        'monday' => 0,
        'tuesday' => 1,
        'wednesday' => 2,
        'thursday' => 3,
        'friday' => 4,
        'saturday' => 5,
        'sunday' => 6,
        _ => -1,
      };
    }

    for (var value in list) days.remove(value.day);
    if (days.isNotEmpty) {
      for (var day in days) list.add(BusinessSchedulingModel(day: day));
    }

    final retList = <BusinessSchedulingModel>[];
    retList.addAll(list);

    for (var element in list) retList[daysSorting(element.day ?? '')] = element;
    return retList;
  }

  @override
  List<Object?> get props => [
    id,
    role,
    name,
    profileImage,
    zipCode,
    address,
    latitude,
    longitude,
    email,
    bearerToken,
    emailOtp,
    emailVerifiedAt,
    phone,
    isProfileCompleted,
    isPushNotify,
    deviceType,
    deviceToken,
    socialType,
    socialToken,
    categoryId,
    description,
    isBlocked,
    isVerified,
    isForgot,
    status,
    subId,
    createdAt,
    updatedAt,
    days,
    offerCount,
  ];
}

@CopyWith()
@JsonSerializable()
class BusinessSchedulingModel extends Equatable {
  final int? id;
  final int? ownerId;
  final String? day;
  final String? startTime;
  final String? endTime;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessSchedulingModel({
    this.id,
    this.ownerId,
    this.day,
    this.startTime,
    this.endTime,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessSchedulingModel.fromJson(Map<String, dynamic> json) => _$BusinessSchedulingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessSchedulingModelToJson(this);

  @override
  List<Object?> get props => [id, ownerId, day, startTime, endTime, status, createdAt, updatedAt];
}

bool intToBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1';
  return false;
}

int boolToInt(bool? value) {
  if (value == null) return 0;
  return value ? 1 : 0;
}

extension UserProfileModelExtension on UserProfileModel {
  LatLng? get latLng => latitude != null && longitude != null ? LatLng(latitude!, longitude!) : null;
}

double? doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? intFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value.toInt();
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

bool boolFromJson(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final lower = value.toLowerCase();
    return lower == '1' || lower == 'true' || lower == 'yes';
  }
  return false;
}
