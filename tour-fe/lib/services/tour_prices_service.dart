// lib\services\tour_prices_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/tour_prices_model.dart';

class TourPricesService {
  // Lấy danh sách bảng giá
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

  // Lấy danh sách gán tour - bảng giá
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

  // Lấy danh sách tour có thể gán
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

  // Tạo bảng giá mới
  Future<bool> createPrice(TourPriceModel price) async {
    final response = await http.post(
      Uri.parse(ApiConstants.tourPrices),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(price.toJson()),
    );
    return response.statusCode == 201;
  }

  // Cập nhật bảng giá
  Future<bool> updatePrice(int id, TourPriceModel price) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.tourPrices}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(price.toJson()),
    );
    return response.statusCode == 200;
  }

  // Xóa bảng giá
  Future<bool> deletePrice(int id) async {
    final response =
        await http.delete(Uri.parse('${ApiConstants.tourPrices}/$id'));
    return response.statusCode == 200;
  }

  // Gán tour với bảng giá
  Future<bool> assignTour(int tourId, int priceId) async {
    final response = await http.post(
      Uri.parse(ApiConstants.tourAssignments),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tour_id': tourId, 'price_id': priceId}),
    );
    return response.statusCode == 201;
  }

  // Hủy gán tour
  Future<bool> deleteAssignment(int id) async {
    final response =
        await http.delete(Uri.parse('${ApiConstants.tourAssignments}/$id'));
    return response.statusCode == 200;
  }
}
