// lib/data/repositories/profile_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/profile_model.dart';

class ProfileRepository {
  /// Lấy thông tin hồ sơ người dùng
  Future<ProfileModel> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  /// Cập nhật thông tin hồ sơ người dùng
  Future<void> updateProfile(String token, Map<String, String> data,
      XFile? avatar, XFile? background) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConstants.baseUrl}/profile'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(data);

    if (avatar != null) {
      final avatarBytes = await avatar.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        avatarBytes,
        filename: avatar.name,
      ));
    }

    if (background != null) {
      final backgroundBytes = await background.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'background',
        backgroundBytes,
        filename: background.name,
      ));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to update profile: $responseBody');
    }
  }
}
