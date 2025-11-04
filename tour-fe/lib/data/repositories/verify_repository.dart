// lib/data/repositories/verify_repository.dart
import '../../services/verify_service.dart';

class VerifyRepository {
  final VerifyService service;
  VerifyRepository({VerifyService? service})
      : service = service ?? VerifyService();

  Future<Map<String, dynamic>> sendCode(String email) async {
    if (email.trim().isEmpty) {
      return {'success': false, 'message': 'Email không được để trống'};
    }
    return await service.sendCode(email);
  }

  Future<Map<String, dynamic>> verifyAccount(String email, String verifyCode,
      {String type = 'register'}) async {
    if (email.trim().isEmpty) {
      return {'success': false, 'message': 'Email không được để trống'};
    }
    if (verifyCode.trim().length != 6) {
      return {'success': false, 'message': 'Mã xác nhận phải có 6 số'};
    }
    return await service.verifyAccount(email, verifyCode, type: type);
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    if (email.trim().isEmpty) {
      return {'success': false, 'message': 'Email không được để trống'};
    }
    if (newPassword.length < 6) {
      return {'success': false, 'message': 'Mật khẩu tối thiểu 6 ký tự'};
    }
    return await service.resetPassword(email, newPassword);
  }
}
