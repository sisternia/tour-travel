// lib/models/tours_model.dart
class TourModel {
  final int id;
  final String name;
  final double priceAdult;
  final double priceChild;
  final String destinationAddress;
  final String location;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final String image;

  TourModel({
    required this.id,
    required this.name,
    required this.priceAdult,
    required this.priceChild,
    required this.destinationAddress,
    required this.location,
    this.startDate,
    this.endDate,
    this.status,
    this.image =
        'https://danangfantasticity.com/wp-content/uploads/2020/03/da-nang-khong-to-chuc-le-ky-niem-45-nam-ngay-giai-phong.jpg',
  });

  // Convert JSON -> Model
  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      priceAdult: (json['price_adult'] is int)
          ? (json['price_adult'] as int).toDouble()
          : (json['price_adult'] as num).toDouble(),
      priceChild: (json['price_child'] is int)
          ? (json['price_child'] as int).toDouble()
          : (json['price_child'] as num).toDouble(),
      destinationAddress: json['destination_address'] ?? '',
      location: json['location'] ?? '',
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      status: json['status'],
      image: json['image'] ??
          'https://danangfantasticity.com/wp-content/uploads/2020/03/da-nang-khong-to-chuc-le-ky-niem-45-nam-ngay-giai-phong.jpg',
    );
  }

  // Convert Model -> JSON (khi POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price_adult': priceAdult,
      'price_child': priceChild,
      'destination_address': destinationAddress,
      'location': location,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'image': image,
    };
  }
}
