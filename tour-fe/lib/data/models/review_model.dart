class ReviewModel {
  final int ratingId;
  final int rating;
  final String comment;
  final String userName;
  final DateTime createdAt;

  ReviewModel({
    required this.ratingId,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      ratingId: json["rating_id"],
      rating: json["rating_value"],
      comment: json["comment"] ?? "",
      userName: json["user_name"] ?? "Ẩn danh",
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
