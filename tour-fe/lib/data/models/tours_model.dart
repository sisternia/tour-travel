// lib/data/models/tours_model.dart
class ToursModel {
  final int id;
  final String name;
  final int numberOfPeople;
  final String startDate;
  final String endDate;
  final String departureAddress;
  final String destinationAddress;
  final String status;

  final String categoryName;
  final List<String> typeNames;

  String firstImage;
  List<String> allImages = [];

  final double priceAdult;
  final double priceChild;
  final double rating;

  ToursModel({
    required this.id,
    required this.name,
    required this.numberOfPeople,
    required this.startDate,
    required this.endDate,
    required this.departureAddress,
    required this.destinationAddress,
    required this.status,
    required this.categoryName,
    required this.typeNames,
    this.firstImage = "",
    required this.priceAdult,
    required this.priceChild,
    this.rating = 4.7,
  });

  static double parsePrice(dynamic value) {
    if (value == null) return 0;

    if (value is num) return value.toDouble();

    final cleaned = value.toString().replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.isEmpty) return 0;

    return double.tryParse(cleaned) ?? 0;
  }

  factory ToursModel.fromJson(Map<String, dynamic> json) {
    final types = json['type_names'];
    List<String> typeList = [];

    if (types is String) {
      typeList = types.split(',').map((e) => e.trim()).toList();
    } else if (types is List) {
      typeList = types.map((e) => e.toString()).toList();
    }

    return ToursModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      numberOfPeople: json['number_of_people'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      departureAddress: json['departure_address'] ?? '',
      destinationAddress: json['destination_address'] ?? '',
      status: json['status'] ?? '',
      categoryName: json['category_name'] ?? '',
      typeNames: typeList,
      priceAdult: parsePrice(json["price_adult"]),
      priceChild: parsePrice(json["price_child"]),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.7,
    );
  }
}
