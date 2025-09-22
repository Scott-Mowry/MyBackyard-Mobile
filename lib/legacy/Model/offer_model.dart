import 'package:backyard/legacy/Model/category_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@CopyWith()
@JsonSerializable()
class Offer extends Equatable {
  final int? id;
  final int? offerId;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? image;
  final int? categoryId;
  final int? ownerId;

  @JsonKey(fromJson: doubleFromJson)
  final double? actualPrice;

  @JsonKey(fromJson: doubleFromJson)
  final double? discountPrice;

  final int? rewardPoints;
  final String? shortDetail;
  final String? description;
  final String? address;
  final CategoryModel? category;

  @JsonKey(fromJson: boolFromJson)
  final bool isAvailed;

  @JsonKey(fromJson: boolFromJson)
  final bool isClaimed;

  const Offer({
    this.id,
    this.offerId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.image,
    this.categoryId,
    this.ownerId,
    this.actualPrice,
    this.discountPrice,
    this.rewardPoints,
    this.shortDetail,
    this.description,
    this.address,
    this.category,
    this.isAvailed = false,
    this.isClaimed = false,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

  @override
  List<Object?> get props => [
    id,
    offerId,
    userId,
    createdAt,
    updatedAt,
    title,
    image,
    categoryId,
    ownerId,
    actualPrice,
    discountPrice,
    rewardPoints,
    shortDetail,
    description,
    address,
    category,
    isAvailed,
    isClaimed,
  ];
}

double? doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool boolFromJson(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1' || value.toLowerCase() == 'true';
  return false;
}
