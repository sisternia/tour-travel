import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/touris_places_model.dart';

class TourTypeService {
  Future<List<TouristPlacesModel>> fetchTourTypes() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.tourtype));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => TouristPlacesModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load tour types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
