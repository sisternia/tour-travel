// lib/services/tours.service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';
import '../data/models/tour_images_model.dart';
import '../data/models/tours_model.dart';
import 'tour_images_service.dart';

class ToursService {
  final TourImagesService _imgService = TourImagesService();
  Future<List<ToursModel>> fetchTours() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.tours));

      if (response.statusCode != 200) {
        throw Exception('Failed to load tours. Status: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      List<ToursModel> tours = [];

      if (body is List) {
        tours = body.map((e) => ToursModel.fromJson(e)).toList();
      }

      await Future.wait(tours.map((t) async {
        final img = await _imgService.getFirstImage(t.id);
        t.firstImage = img?.tourImg ?? "";
      }));

      return tours;
    } catch (e) {
      throw Exception("Failed to fetch tours: $e");
    }
  }

  Future<List<ToursModel>> fetchAllTours() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.tours));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load all tours. Status: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      List<ToursModel> tours = [];

      if (body is List) {
        tours = body.map((e) => ToursModel.fromJson(e)).toList();
      }

      await Future.wait(tours.map((t) async {
        final img = await _imgService.getFirstImage(t.id);
        t.firstImage = img?.tourImg ?? "";
      }));

      return tours;
    } catch (e) {
      throw Exception("Failed to fetch all tours: $e");
    }
  }

  Future<List<ToursModel>> fetchLatestTours() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.latestTours));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load latest tours. Status: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      List<ToursModel> tours = [];

      if (body is List) {
        tours = body.map((e) => ToursModel.fromJson(e)).toList();
      }
      await Future.wait(tours.map((t) async {
        final img = await _imgService.getFirstImage(t.id);
        t.firstImage = img?.tourImg ?? "";
      }));

      return tours;
    } catch (e) {
      throw Exception("Failed to fetch latest tours: $e");
    }
  }

  Future<List<TourImageModel>> fetchAllImages(int tourId) async {
    return await _imgService.getAllImages(tourId);
  }
}
