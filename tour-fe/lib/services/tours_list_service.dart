// lib/services/tours_list_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/tours.model.dart';

class TourListService {
  Future<List<TourModel>> fetchTours() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.tours));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List && body.isEmpty) return []; // ✅ rỗng
        if (body is List) {
          return body.map((e) => TourModel.fromJson(e)).toList();
        }
        if (body is Map && body.containsKey('data')) {
          return (body['data'] as List)
              .map((e) => TourModel.fromJson(e))
              .toList();
        }
        throw Exception('Dữ liệu không hợp lệ');
      } else {
        throw Exception('Failed to load tours: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load tours: $e');
    }
  }
}
