// lib/services/tour_prices_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/tour_prices_model.dart';

class TourPricesService {
  Future<List<TourPriceModel>> fetchPrices() async {
    final response = await http.get(Uri.parse(ApiConstants.tourPrices));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => TourPriceModel.fromJson(e)).toList();
      }
    }
    throw Exception('Không thể tải danh sách bảng giá');
  }

  Future<List<TourPriceAssignmentModel>> fetchAssignments() async {
    final response = await http.get(Uri.parse(ApiConstants.tourAssignments));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => TourPriceAssignmentModel.fromJson(e)).toList();
      }
    }
    throw Exception('Không thể tải danh sách gán tour');
  }

  Future<List<TourPriceAssignmentModel>> fetchAssignmentByTour(
      int tourId) async {
    final response =
        await http.get(Uri.parse(ApiConstants.tourAssignmentByTour(tourId)));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => TourPriceAssignmentModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchTours() async {
    final response = await http.get(Uri.parse(ApiConstants.tourPriceTours));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return List<Map<String, dynamic>>.from(body);
      }
    }
    throw Exception('Không thể tải danh sách tour');
  }
}
