// lib/data/models/profile_model.dart
class ProfileModel {
  final String? userId;
  final String? userName;
  final String? email;
  final String? phone;
  final String? dob;
  final String? bio;
  final String? citizenId;
  final String? address;
  final String? avatar;
  final String? background;

  ProfileModel({
    this.userId,
    this.userName,
    this.email,
    this.phone,
    this.dob,
    this.bio,
    this.citizenId,
    this.address,
    this.avatar,
    this.background,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id']?.toString(),
      userName: json['user_name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      bio: json['bio'],
      citizenId: json['citizen_id'],
      address: json['address'],
      avatar: json['avatar'], // <-- TRỰC TIẾP URL CLOUDINARY
      background: json['background'], // <-- TRỰC TIẾP URL CLOUDINARY
    );
  }
}
