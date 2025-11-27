// lib/services/tour_schedules_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/tour_schedules_model.dart';

class TourSchedulesService {
  /// Lấy toàn bộ lịch trình
  Future<List<TourScheduleModel>> fetchAllSchedules() async {
    final response = await http.get(Uri.parse(ApiConstants.schedules));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => TourScheduleModel.fromJson(e)).toList();
      }
    }
    throw Exception('Không thể tải danh sách lịch trình');
  }

  /// Lấy lịch trình theo tour
  Future<List<TourScheduleModel>> fetchSchedulesByTour(int tourId) async {
    final response =
        await http.get(Uri.parse(ApiConstants.schedulesByTour(tourId)));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => TourScheduleModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  /// Lấy danh sách tour để hiển thị tên
  Future<List<ScheduleTourListModel>> fetchScheduleTours() async {
    final response = await http.get(Uri.parse(ApiConstants.scheduleTours));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => ScheduleTourListModel.fromJson(e)).toList();
      }
    }
    throw Exception('Không thể tải danh sách tour cho lịch trình');
  }
}
