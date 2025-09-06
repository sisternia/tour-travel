// lib/data/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api.dart';

class AuthService {
  final http.Client client;
  AuthService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> register({
    required String userName,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.register);
    final body = jsonEncode({
      'user_name': userName,
      'email': email,
      'password': password,
    });

    try {
      final response = await client
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 15));

      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': decoded};
      } else {
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Lỗi server (${response.statusCode})';
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.login);
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await client
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 15));

      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': decoded};
      } else {
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Lỗi server (${response.statusCode})';
        return {
          'success': false,
          'message': msg,
          'status': response.statusCode
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }
}
