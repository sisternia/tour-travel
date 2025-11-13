// lib/data/models/tour_images_model.dart
class TourImageModel {
  final String? tourImg;
  final int? tourImgId;

  TourImageModel({
    this.tourImg,
    this.tourImgId,
  });

  factory TourImageModel.fromJson(Map<String, dynamic> json) {
    return TourImageModel(
      tourImg: json['tour_img'],
      tourImgId: json['tour_img_id'],
    );
  }
}

class TourImageList {
  final List<TourImageModel> images;

  TourImageList(this.images);

  factory TourImageList.fromJson(List<dynamic> json) {
    return TourImageList(json.map((e) => TourImageModel.fromJson(e)).toList());
  }
}
