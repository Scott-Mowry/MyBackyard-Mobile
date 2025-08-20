class CategoryModel {
  int? id;
  String? categoryName;
  String? categoryIcon;

  CategoryModel({
    this.id,
    this.categoryName,
    this.categoryIcon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        categoryName: json["category_name"],
        categoryIcon: json["category_icon"],
      );
}
