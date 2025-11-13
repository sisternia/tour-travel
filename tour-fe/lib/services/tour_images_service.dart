// lib/services/tour_images_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';
import '../data/models/tour_images_model.dart';

class TourImagesService {
  Future<TourImageModel?> getFirstImage(int tourId) async {
    try {
      final response =
          await http.get(Uri.parse(ApiConstants.firstImage(tourId)));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TourImageModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load first image: $e");
    }
  }

  Future<List<TourImageModel>> getAllImages(int tourId) async {
    final res = await http.get(Uri.parse(ApiConstants.allImages(tourId)));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      return TourImageList.fromJson(decoded).images;
    }
    return [];
  }
}
