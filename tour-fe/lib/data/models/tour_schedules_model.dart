// lib/data/models/tour_schedules_model.dart

class TourScheduleModel {
  final int scheduleId;
  final int tourId;
  final String tourName;
  final int dayNumber;
  final String? description;

  TourScheduleModel({
    required this.scheduleId,
    required this.tourId,
    required this.tourName,
    required this.dayNumber,
    this.description,
  });

  factory TourScheduleModel.fromJson(Map<String, dynamic> json) {
    return TourScheduleModel(
      scheduleId: json['schedule_id'] ?? 0,
      tourId: json['tour_id'] ?? 0,
      tourName: json['tour_name'] ?? 'Không rõ',
      dayNumber: json['day_number'] ?? 0,
      description: json['description']?.toString(),
    );
  }
}

class ScheduleTourListModel {
  final int id;
  final String name;

  ScheduleTourListModel({
    required this.id,
    required this.name,
  });

  factory ScheduleTourListModel.fromJson(Map<String, dynamic> json) {
    return ScheduleTourListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Không rõ',
    );
  }
}
