// lib/data/models/auth_model.dart
class AuthModel {
  final String userId;
  final String userName;
  final String email;

  AuthModel({
    required this.userId,
    required this.userName,
    required this.email,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'email': email,
      };
}
