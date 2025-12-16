// lib/services/tour_category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/tour_category_model.dart';

class ToursCategoryService {
  Future<List<ToursCategoryModel>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/tour-categories'),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List && body.isEmpty) return [];

        if (body is Map && body.containsKey('data')) {
          return (body['data'] as List)
              .map((e) => ToursCategoryModel.fromJson(e))
              .toList();
        }

        if (body is List) {
          return body.map((e) => ToursCategoryModel.fromJson(e)).toList();
        }

        throw Exception("Dữ liệu không hợp lệ từ server");
      } else {
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
