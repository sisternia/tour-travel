// lib\data\models\tour_prices_model.dart

class TourPriceModel {
  final int priceId;
  final double priceAdult;
  final double priceChild;
  final String? validFrom;
  final String? validTo;

  TourPriceModel({
    required this.priceId,
    required this.priceAdult,
    required this.priceChild,
    this.validFrom,
    this.validTo,
  });

  factory TourPriceModel.fromJson(Map<String, dynamic> json) {
    return TourPriceModel(
      priceId: json['price_id'] ?? 0,
      priceAdult: (json['price_adult'] as num).toDouble(),
      priceChild: (json['price_child'] as num).toDouble(),
      validFrom: json['valid_from']?.toString(),
      validTo: json['valid_to']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_adult': priceAdult,
      'price_child': priceChild,
      'valid_from': validFrom,
      'valid_to': validTo,
    };
  }
}

/// Gán tour với bảng giá
class TourPriceAssignmentModel {
  final int id;
  final String tourName;
  final double priceAdult;
  final double priceChild;
  final String? validFrom;
  final String? validTo;

  TourPriceAssignmentModel({
    required this.id,
    required this.tourName,
    required this.priceAdult,
    required this.priceChild,
    this.validFrom,
    this.validTo,
  });

  factory TourPriceAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TourPriceAssignmentModel(
      id: json['id'] ?? 0,
      tourName: json['tour_name'] ?? 'Không rõ',
      priceAdult: (json['price_adult'] as num?)?.toDouble() ?? 0.0,
      priceChild: (json['price_child'] as num?)?.toDouble() ?? 0.0,
      validFrom: json['valid_from']?.toString(),
      validTo: json['valid_to']?.toString(),
    );
  }
}
