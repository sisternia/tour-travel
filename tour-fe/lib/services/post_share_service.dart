// lib/services/post_share_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';

class PostShareService {
  Future<Map<String, dynamic>> sharePost({
    required String postId,
    required String userId,
    required String sharedFromUserId,
  }) async {
    final res = await http.post(
      Uri.parse(ApiConstants.postShares),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "post_id": postId,
        "user_id": userId,
        "shared_from_user_id": sharedFromUserId,
      }),
    );

    return json.decode(res.body);
  }

  Future<List<dynamic>> getShares(String postId) async {
    final res = await http.get(
      Uri.parse(ApiConstants.postSharesByPost(postId)),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    }

    throw Exception("Failed to load shares");
  }

  Future<int> getShareCount(String postId) async {
    final res = await http.get(
      Uri.parse(ApiConstants.postShareCount(postId)),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data["count"] ?? 0;
    }

    return 0;
  }
}





