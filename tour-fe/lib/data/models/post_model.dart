// lib/data/models/post_model.dart

class PostModel {
  final String postId;
  final String userId;
  final String userName;
  final String content;
  final String privacy;
  final DateTime createdAt;
  final List<PostImageModel> images;

  PostModel({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.privacy,
    required this.createdAt,
    required this.images,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'],
      userId: json['user_id'],
      userName: json['user_name'] ?? "",
      content: json['content'] ?? "",
      privacy: json['privacy'] ?? "public",
      createdAt: DateTime.parse(json['created_at']),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => PostImageModel.fromJson(e))
          .toList(),
    );
  }
}

class PostImageModel {
  final String imageId;
  final String postId;
  final String imageUrl;

  PostImageModel({
    required this.imageId,
    required this.postId,
    required this.imageUrl,
  });

  factory PostImageModel.fromJson(Map<String, dynamic> json) {
    return PostImageModel(
      imageId: json['image_id'],
      postId: json['post_id'],
      imageUrl: json['image_url'],
    );
  }
}
