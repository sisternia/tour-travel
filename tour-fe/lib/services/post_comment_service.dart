// lib/services/post_comment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';

class PostCommentService {
  Future<Map<String, dynamic>> addComment({
    required String postId,
    required String userId,
    required String content,
  }) async {
    final res = await http.post(
      Uri.parse(ApiConstants.postComments),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "post_id": postId,
        "user_id": userId,
        "content": content,
      }),
    );

    return json.decode(res.body);
  }

  Future<List<dynamic>> getComments(String postId) async {
    final res = await http.get(
      Uri.parse(ApiConstants.postCommentsByPost(postId)),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    }

    throw Exception("Failed to load comments");
  }

  Future<int> getCommentCount(String postId) async {
    final res = await http.get(
      Uri.parse(ApiConstants.postCommentCount(postId)),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data["count"] ?? 0;
    }

    return 0;
  }

  Future<bool> updateComment({
    required String commentId,
    required String content,
  }) async {
    final res = await http.put(
      Uri.parse(ApiConstants.updateComment(commentId)),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"content": content}),
    );

    return res.statusCode == 200;
  }

  Future<bool> deleteComment(String commentId) async {
    final res = await http.delete(
      Uri.parse(ApiConstants.deleteComment(commentId)),
    );

    return res.statusCode == 200;
  }
}





