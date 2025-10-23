// lib/data/models/profile_model.dart
class ProfileModel {
  final String? userId;
  final String? userName;
  final String? email;
  final String? phone;
  final String? dob; // Date of Birth
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
      userName: json['user_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      dob: json['dob']?.toString(),
      bio: json['bio']?.toString(),
      citizenId: json['citizen_id']?.toString(),
      address: json['address']?.toString(),
      avatar: json['avatar']?.toString(),
      background: json['background']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'email': email,
      'phone': phone,
      'dob': dob,
      'bio': bio,
      'citizen_id': citizenId,
      'address': address,
      'avatar': avatar,
      'background': background,
    };
  }

  ProfileModel copyWith({
    String? userId,
    String? userName,
    String? email,
    String? phone,
    String? dob,
    String? bio,
    String? citizenId,
    String? address,
    String? avatar,
    String? background,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      bio: bio ?? this.bio,
      citizenId: citizenId ?? this.citizenId,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      background: background ?? this.background,
    );
  }

  @override
  String toString() {
    return 'ProfileModel(userId: $userId, userName: $userName, email: $email, '
        'phone: $phone, dob: $dob, bio: $bio, citizenId: $citizenId, '
        'address: $address, avatar: $avatar, background: $background)';
  }
}
