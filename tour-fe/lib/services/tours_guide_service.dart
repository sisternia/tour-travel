// lib/services/tours_guide_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';
import '../data/models/tours_guide_model.dart';

class TourGuideService {
  Future<List<TourGuideModel>> getAllGuides() async {
    final res = await http.get(Uri.parse(ApiConstants.tourGuides));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      return TourGuideList.fromJson(decoded).guides;
    }
    return [];
  }

  Future<List<TourGuideModel>> getGuidesByTour(int tourId) async {
    final res =
        await http.get(Uri.parse(ApiConstants.tourGuidesByTour(tourId)));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      return TourGuideList.fromJson(decoded).guides;
    }
    return [];
  }
}
