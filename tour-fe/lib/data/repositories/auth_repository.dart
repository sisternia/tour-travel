import '../../services/auth_service.dart';
import '../../services/token_service.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final AuthService service;
  final TokenService _tokenService = TokenService();

  AuthRepository({AuthService? service}) : service = service ?? AuthService();

  // ------------------------
  // REGISTER
  // ------------------------
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

  // ------------------------
  // LOGIN
  // ------------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      return {'success': false, 'message': 'Email không được để trống'};
    }
    if (password.isEmpty) {
      return {'success': false, 'message': 'Mật khẩu không được để trống'};
    }

    final res = await service.login(email: email, password: password);

    if (res['success'] == true) {
      final data = res['data'];

      // TOKEN
      final token = data is Map ? data['token'] : null;
      if (token != null) {
        await _tokenService.saveToken(token);
      }

      AuthModel? user;
      if (data is Map && data['user'] is Map) {
        try {
          final userMap = Map<String, dynamic>.from(data['user']);

          // Parse user object
          user = AuthModel.fromJson(userMap);

          // ⭐ LƯU USER_ID (VARCHAR)
          if (userMap['user_id'] != null) {
            await _tokenService.saveUserId(userMap['user_id'].toString());
          }
        } catch (e) {
          print("Lỗi parse user: $e");
        }
      }

      return {
        'success': true,
        'message': data['message'] ?? 'Đăng nhập thành công',
        'token': token,
        'user': user
      };
    }

    // ------------------------
    // LOGIN FAILED
    // ------------------------
    return {
      'success': false,
      'message': res['message'] ?? 'Lỗi đăng nhập',
      'status': res['status']
    };
  }
}
