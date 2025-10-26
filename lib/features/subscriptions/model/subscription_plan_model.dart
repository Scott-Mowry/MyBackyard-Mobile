import 'package:backyard/core/model/user_profile_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_plan_model.g.dart';

@CopyWith()
@JsonSerializable()
class SubscriptionPlanModel extends Equatable {
  final int id;
  final String name;
  final String type;

  @JsonKey(fromJson: doubleFromJson)
  final double? price;

  final String billingCycle;
  final String? description;

  @JsonKey(fromJson: boolFromJson)
  final bool isPopular;

  @JsonKey(fromJson: boolFromJson)
  final bool onShow;

  @JsonKey(fromJson: intFromJson)
  final int? sortOrder;

  final String? isDepreciated;
  final String? status;
  final List<String> subPoints;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.billingCycle,
    this.description,
    this.isPopular = false,
    this.onShow = false,
    this.sortOrder,
    this.isDepreciated,
    this.status,
    this.subPoints = const <String>[],
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPlanModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    price,
    billingCycle,
    description,
    isPopular,
    onShow,
    sortOrder,
    isDepreciated,
    status,
    subPoints,
    createdAt,
    updatedAt,
  ];
}
