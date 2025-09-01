// lib/data/services/verify_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api.dart';

class VerifyService {
  final http.Client client;
  VerifyService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> sendCode(String email) async {
    final uri = Uri.parse(ApiConstants.sendVerifyCode);
    final body = jsonEncode({'email': email});
    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': decoded};
      } else {
        return {
          'success': false,
          'message': decoded['message']?.toString() ??
              'Lỗi server (${response.statusCode})'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> verifyAccount(
      String email, String verifyCode) async {
    final uri = Uri.parse(ApiConstants.verifyAccount);
    final body = jsonEncode({'email': email, 'verify_code': verifyCode});
    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': decoded};
      } else {
        return {
          'success': false,
          'message': decoded['message']?.toString() ??
              'Lỗi server (${response.statusCode})'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }
}
