// lib/data/models/tours_category_model.dart

class ToursCategoryModel {
  final int categoryId;
  final String categoryName;
  final String image;

  ToursCategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.image,
  });

  factory ToursCategoryModel.fromJson(Map<String, dynamic> json) {
    return ToursCategoryModel(
      categoryId: json['category_id'] as int,
      categoryName: json['categories_name'].toString(),
      image: json['image'].toString(),
    );
  }
}
