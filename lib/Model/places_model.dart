class PlacesModel {
  int? id;
  String? name;
  double? topLeftLatitude;
  double? topLeftLongitude;
  double? bottomRightLatitude;
  double? bottomRightLongitude;
  int? isAllowed;
  DateTime? createdAt;
  DateTime? updatedAt;

  PlacesModel(
      {this.id,
      this.name,
      this.topLeftLatitude,
      this.topLeftLongitude,
      this.bottomRightLatitude,
      this.bottomRightLongitude,
      this.isAllowed,
      this.createdAt,
      this.updatedAt});

  factory PlacesModel.fromJson(Map<String, dynamic> json) => PlacesModel(
        id: json["id"],
        name: json["name"],
        topLeftLatitude: json["top_Left_latitude"]?.toDouble(),
        topLeftLongitude: json["top_Left_longitude"]?.toDouble(),
        bottomRightLatitude: json["bottom_right_latitude"]?.toDouble(),
        bottomRightLongitude: json["bottom_right_longitude"]?.toDouble(),
        isAllowed: json["is_allowed"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
