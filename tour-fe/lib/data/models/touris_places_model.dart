// ignore_for_file: public_member_api_docs, sort_constructors_first
class TouristPlacesModel {
  final int type_id;
  final String type_name;
  final String images;

  TouristPlacesModel({
    required this.type_id,
    required this.type_name,
    required this.images,
  });

  factory TouristPlacesModel.fromJson(Map<String, dynamic> json) {
    return TouristPlacesModel(
      type_id: json['type_id'] as int,
      type_name: json['type_name'].toString(),
      images: json['image'].toString(),
    );
  }
}
