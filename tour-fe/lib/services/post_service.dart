// lib/services/post_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/constants/api.dart';

class PostService {
  Future<List<dynamic>> getPosts() async {
    final res = await http.get(Uri.parse(ApiConstants.posts));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    }

    throw Exception("Failed to load posts");
  }

  Future<Map<String, dynamic>> createPost({
    required String userId,
    required String userName,
    required String content,
    required String privacy,
    required List<Uint8List> images,
  }) async {
    final uri = Uri.parse(ApiConstants.posts);
    final req = http.MultipartRequest("POST", uri);

    req.fields["user_id"] = userId;
    req.fields["user_name"] = userName;
    req.fields["content"] = content;
    req.fields["privacy"] = privacy;

    for (int i = 0; i < images.length; i++) {
      req.files.add(http.MultipartFile.fromBytes(
        "images",
        images[i],
        filename: "img_$i.jpg",
        contentType: MediaType("image", "jpeg"),
      ));
    }

    final response = await req.send();
    final body = await response.stream.bytesToString();
    return json.decode(body);
  }

  /// Update Post
  Future<bool> updatePost({
    required String postId,
    required String userName,
    required String content,
    required String privacy,
    required List<Uint8List> imagesBytes,
  }) async {
    final uri = Uri.parse(ApiConstants.updatePost(postId));
    final req = http.MultipartRequest('PUT', uri);

    req.fields['user_name'] = userName;
    req.fields['content'] = content;
    req.fields['privacy'] = privacy;

    for (int i = 0; i < imagesBytes.length; i++) {
      req.files.add(http.MultipartFile.fromBytes(
        'images',
        imagesBytes[i],
        filename: 'image_$i.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final streamed = await req.send();
    return streamed.statusCode == 200;
  }

  /// Delete Post
  Future<bool> deletePost({
    required String postId,
    required String userName,
  }) async {
    final res = await http.delete(
      Uri.parse(ApiConstants.deletePost(postId)),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user_name": userName}),
    );

    return res.statusCode == 200;
  }

  /// Get Posts by User ID
  Future<List<dynamic>> getPostsByUserId(String userId) async {
    final res = await http.get(Uri.parse(ApiConstants.postsByUser(userId)));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    }

    throw Exception("Failed to load posts");
  }
}
