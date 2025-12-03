import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api.dart';
import '../data/models/review_model.dart';
import '../services/token_service.dart';

class ReviewService {
  static Future<bool> submitReview({
    required int tourId,
    required int rating,
    required String review,
  }) async {
    final tokenService = TokenService();
    final userId = await tokenService.getUserId();

    if (userId == null) {
      print("ERROR: userId bị NULL khi gửi đánh giá");
      return false;
    }

    final res = await http.post(
      Uri.parse(ApiConstants.submitRating(tourId)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "rating": rating,
        "comment": review,
      }),
    );

    return res.statusCode == 200;
  }

  static Future<List<ReviewModel>> getReviews(int tourId) async {
    final res = await http.get(Uri.parse(ApiConstants.getRating(tourId)));

    if (res.statusCode == 200) {
      List json = jsonDecode(res.body);
      return json.map((e) => ReviewModel.fromJson(e)).toList();
    }

    return [];
  }
}
