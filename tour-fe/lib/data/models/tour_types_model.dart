// lib\data\models\tours_places_model.dart
class TouristPlacesModel {
  final int typeId;
  final String typeName;
  final String images;

  TouristPlacesModel({
    required this.typeId,
    required this.typeName,
    required this.images,
  });

  factory TouristPlacesModel.fromJson(Map<String, dynamic> json) {
    return TouristPlacesModel(
      typeId: json['type_id'] as int,
      typeName: json['type_name'].toString(),
      images: json['image'].toString(),
    );
  }
}
