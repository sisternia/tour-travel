import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/tour_locations_model.dart';

class TourLocationsService {
  // Lấy tất cả địa điểm (admin dùng)
  Future<List<TourLocationModel>> fetchAllLocations() async {
    final response = await http.get(Uri.parse(ApiConstants.tourLocations));

    if (response.statusCode != 200) {
      throw Exception("Failed: ${response.statusCode}");
    }

    final jsonBody = jsonDecode(response.body);

    if (jsonBody is Map && jsonBody.containsKey("data")) {
      return (jsonBody["data"] as List)
          .map((e) => TourLocationModel.fromJson(e))
          .toList();
    }

    return [];
  }

  // Lấy địa điểm theo tour cho người dùng
  Future<List<TourLocationModel>> fetchLocationsByTour(int tourId) async {
    final response =
        await http.get(Uri.parse(ApiConstants.tourLocationsByTour(tourId)));

    if (response.statusCode != 200) {
      throw Exception("Failed: ${response.statusCode}");
    }

    final jsonBody = jsonDecode(response.body);

    if (jsonBody is Map && jsonBody.containsKey("data")) {
      return (jsonBody["data"] as List)
          .map((e) => TourLocationModel.fromJson(e))
          .toList();
    }

    return [];
  }
}
