// lib/services/post_reaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';

class PostReactionService {
  Future<Map<String, dynamic>> addReaction({
    required String postId,
    required String userId,
    required String reactionType,
  }) async {
    final res = await http.post(
      Uri.parse(ApiConstants.postReactions),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "post_id": postId,
        "user_id": userId,
        "reaction_type": reactionType,
      }),
    );

    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> removeReaction({
    required String postId,
    required String userId,
  }) async {
    final res = await http.delete(
      Uri.parse(ApiConstants.postReactions),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "post_id": postId,
        "user_id": userId,
      }),
    );

    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> getReactions(String postId) async {
    final res = await http.get(
      Uri.parse(ApiConstants.postReactionsByPost(postId)),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    }

    throw Exception("Failed to load reactions");
  }

  Future<Map<String, dynamic>?> getUserReaction(String userId, String postId) async {
    final res = await http.get(
      Uri.parse(ApiConstants.userReaction(userId, postId)),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data;
    }

    return null;
  }
}





