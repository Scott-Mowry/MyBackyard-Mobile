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
  final int? isClaimed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? image;
  final int? categoryId;
  final int? ownerId;

  @JsonKey(fromJson: _parseDouble)
  final double? actualPrice;

  @JsonKey(fromJson: _parseDouble)
  final double? discountPrice;

  final int? rewardPoints;
  final String? shortDetail;
  final String? description;
  final String? address;
  final CategoryModel? category;
  final int? isAvailed;

  const Offer({
    this.id,
    this.offerId,
    this.userId,
    this.isClaimed,
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
    this.isAvailed,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    offerId,
    userId,
    isClaimed,
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
  ];
}
