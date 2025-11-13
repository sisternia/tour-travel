// lib/services/tours.service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';
import '../data/models/tour_images_model.dart';
import '../data/models/tours.model.dart';
import 'tour_images_service.dart';

class ToursService {
  final TourImagesService _imgService = TourImagesService();

  Future<List<ToursModel>> fetchTours() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.tours));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        List<ToursModel> tours = [];

        if (body is List) {
          tours = body.map((e) => ToursModel.fromJson(e)).toList();
        } else if (body is Map && body.containsKey('data')) {
          tours = (body['data'] as List)
              .map((e) => ToursModel.fromJson(e))
              .toList();
        }

        for (var t in tours) {
          final img = await _imgService.getFirstImage(t.id);
          t.firstImage = img?.tourImg ?? "";
        }

        return tours;
      } else {
        throw Exception(
            'Failed to load tours. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<TourImageModel>> fetchAllImages(int tourId) async {
    return await _imgService.getAllImages(tourId);
  }
}
