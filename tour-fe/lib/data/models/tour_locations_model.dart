class TourLocationModel {
  final int locationId;
  final int tourId;
  final String tourName;
  final String locationName;
  final String description;
  final double latitude;
  final double longitude;

  TourLocationModel({
    required this.locationId,
    required this.tourId,
    required this.tourName,
    required this.locationName,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory TourLocationModel.fromJson(Map<String, dynamic> json) {
    return TourLocationModel(
      locationId: json['location_id'] as int,
      tourId: json['tour_id'] as int,
      tourName: json['tour_name']?.toString() ?? "",
      locationName: json['location_name']?.toString() ?? "",
      description: json['description']?.toString() ?? "",
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
