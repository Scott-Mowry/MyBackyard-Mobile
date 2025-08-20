import 'package:backyard/Model/category_model.dart';

class Offer {
  int? id;
  int? offerId;
  int? userId;
  int? isClaimed;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  String? image;
  int? categoryId;
  int? ownerId;
  double? actualPrice;
  double? discountPrice;
  int? rewardPoints;
  String? shortDetail;
  String? description;
  String? address;
  CategoryModel? category;
  int? isAvailed;

  Offer({
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

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        offerId: json["offer_id"],
        userId: json["user_id"],
        isClaimed: json["is_claimed"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        title: json["title"],
        image: json["image"],
        categoryId: json["category_id"],
        ownerId: json["owner_id"],
        actualPrice: double.parse(json["actual_price"].toString()),
        discountPrice: double.parse(json["discount_price"].toString()),
        rewardPoints: json["reward_points"],
        shortDetail: json["short_detail"],
        description: json["description"],
        address: json["address"],
        category: json["category"] == null
            ? null
            : CategoryModel.fromJson(json["category"]),
        isAvailed: json["is_availed"],
      );
}
