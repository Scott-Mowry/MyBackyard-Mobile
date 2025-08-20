class ProductsModel {
  String id = '';
  String title = '';
  var price;
  String description = '';
  String category = '';
  List<String>? prodImages;
  Category? categoryId;
  String image = '';
  var avgRating;
  var myRating;
  // Rating? rating;
  int quantity = 1;
  int isFavourite = 0;
  bool isChecked = false;

  ProductsModel({
    this.id = '',
    this.title = '',
    this.price,
    this.description = '',
    this.category = '',
    this.image = '',
    // this.rating,
    this.prodImages,
    this.categoryId,
    this.avgRating,
    this.myRating,
    this.isChecked = false,
    this.quantity = 1,
    this.isFavourite = 0,
  });

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['product_id'] ?? '';
    title = json['title'] ?? '';
    price = json['price'];
    quantity = json['quantity'] ?? 1;
    isFavourite = json['is_favourite'] ?? 0;
    description = json['description'] ?? '';
    image = (json['prod_images'] as List?) != null
        ? ((json['prod_images'] as List).isNotEmpty
            ? (json['prod_images'] as List)[0]
            : '')
        : '';
    avgRating = json['avg_rating'] ?? 0.0;
    myRating = json['my_rating'];
    categoryId = (json['category_id'] as Map<String, dynamic>?) != null
        ? Category.fromJson(json['category_id'] as Map<String, dynamic>)
        : null;
    category = categoryId?.categoryName ?? '';
    prodImages = (json['prod_images'] as List?)
        ?.map((dynamic e) => e as String)
        .toList();
    // rating = (json['rating'] as Map<String,dynamic>?) != null ? Rating.fromJson(json['rating'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_id'] = id;
    json['title'] = title;
    json['price'] = price;
    json['description'] = description;
    json['category_name'] = category;
    json['quantity'] = quantity;
    json['image'] = image;
    json['my_rating'] = myRating;
    json['is_favourite'] = isFavourite;
    json['avg_rating'] = avgRating;
    json['prod_images'] = prodImages;
    json['category_id'] = categoryId?.toJson();
// json['rating'] = rating?.toJson();
    return json;
  }
}

class Category {
  String id = '';
  String categoryName = '';

  Category({
    this.id = '',
    this.categoryName = '',
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    categoryName = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = categoryName;
    return json;
  }
}
