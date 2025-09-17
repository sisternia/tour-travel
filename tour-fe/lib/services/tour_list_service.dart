import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/tours.model.dart';

class TourListService {
  Future<List<TourModel>> fetchTours() async {
    final response = await http.get(Uri.parse(ApiConstants.tours));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TourModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tours');
    }
  }
}
