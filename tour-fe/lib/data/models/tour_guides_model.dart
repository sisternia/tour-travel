// lib/data/models/tours_guide_model.dart

class TourGuideModel {
  final int? guideId;
  final String? guideName;
  final String? email;
  final String? phone;
  final String? birthday;
  final String? gender;
  final String? languageJob;
  final String? certification;
  final String? address;
  final String? avatarImage;

  TourGuideModel({
    this.guideId,
    this.guideName,
    this.email,
    this.phone,
    this.birthday,
    this.gender,
    this.languageJob,
    this.certification,
    this.address,
    this.avatarImage,
  });

  factory TourGuideModel.fromJson(Map<String, dynamic> json) {
    return TourGuideModel(
      guideId: json['guide_id'],
      guideName: json['guide_name'],
      email: json['email'],
      phone: json['phone'],
      birthday: json['birthday'],
      gender: json['gender'],
      languageJob: json['language_job'],
      certification: json['certification'],
      address: json['address'],
      avatarImage: json['avatar_image']?.toString(),
    );
  }
}

class TourGuideList {
  final List<TourGuideModel> guides;

  TourGuideList(this.guides);

  factory TourGuideList.fromJson(List<dynamic> json) {
    return TourGuideList(
      json.map((e) => TourGuideModel.fromJson(e)).toList(),
    );
  }
}
