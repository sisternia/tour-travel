// lib/data/models/verify_model.dart
class VerifyModel {
  final String verifyId;
  final String userId;
  final String verifyCode;
  final int verifyStatus;

  VerifyModel({
    required this.verifyId,
    required this.userId,
    required this.verifyCode,
    required this.verifyStatus,
  });

  factory VerifyModel.fromJson(Map<String, dynamic> json) {
    return VerifyModel(
      verifyId: json['verify_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      verifyCode: json['verify_code']?.toString() ?? '',
      verifyStatus: int.tryParse(json['verify_status']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'verify_id': verifyId,
        'user_id': userId,
        'verify_code': verifyCode,
        'verify_status': verifyStatus,
      };
}
