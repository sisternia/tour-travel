// lib/data/repositories/auth_repository.dart
import '../services/auth_service.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final AuthService service;
  AuthRepository({AuthService? service}) : service = service ?? AuthService();

  /// Kiểm tra đơn giản phía client rồi gọi service.
  /// Trả về map: { success: bool, message: String?, user: AuthModel? }
  Future<Map<String, dynamic>> register({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (userName.trim().isEmpty) {
      return {'success': false, 'message': 'Tên đăng nhập không được để trống'};
    }
    if (email.trim().isEmpty) {
      return {'success': false, 'message': 'Email không được để trống'};
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return {'success': false, 'message': 'Email không hợp lệ'};
    }
    if (password.length < 6) {
      return {'success': false, 'message': 'Mật khẩu tối thiểu 6 ký tự'};
    }
    if (password != confirmPassword) {
      return {'success': false, 'message': 'Mật khẩu xác nhận không khớp'};
    }

    final res = await service.register(
      userName: userName,
      email: email,
      password: password,
    );

    if (res['success'] == true) {
      // Nếu backend trả về dữ liệu user, parse (không bắt buộc)
      AuthModel? user;
      final data = res['data'];
      if (data is Map && data['user'] is Map) {
        try {
          user = AuthModel.fromJson(Map<String, dynamic>.from(data['user']));
        } catch (_) {}
      }
      return {
        'success': true,
        'message': data is Map && data['message'] != null
            ? data['message']
            : 'Đăng ký thành công',
        'user': user
      };
    } else {
      return {'success': false, 'message': res['message'] ?? 'Lỗi đăng ký'};
    }
  }
}
