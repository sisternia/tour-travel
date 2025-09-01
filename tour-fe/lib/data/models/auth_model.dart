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
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': userName,
        'email': email,
      };
}
