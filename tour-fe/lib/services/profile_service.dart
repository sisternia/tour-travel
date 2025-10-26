// lib/data/services/profile_service.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/profile_model.dart';

class ProfileService {
  /// Lấy thông tin hồ sơ người dùng
  Future<ProfileModel> getProfile(String token) async {
    final response = await http.get(
      Uri.parse(ApiConstants.profile),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  /// Cập nhật hồ sơ người dùng (kèm upload avatar & background)
  Future<void> updateProfile(
    String token,
    Map<String, dynamic> data,
    XFile? avatar,
    XFile? background,
  ) async {
    final uri = Uri.parse(ApiConstants.updateProfile);
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token';

    // Add text fields
    data.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        request.fields[key] = value.toString();
      }
    });

    // Add avatar
    if (avatar != null) {
      if (kIsWeb) {
        // 🟩 WEB: dùng bytes
        final bytes = await avatar.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'avatar',
          bytes,
          filename: avatar.name,
        ));
      } else {
        // 📱 MOBILE: dùng path
        request.files
            .add(await http.MultipartFile.fromPath('avatar', avatar.path));
      }
    }

    // Add background
    if (background != null) {
      if (kIsWeb) {
        final bytes = await background.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'background',
          bytes,
          filename: background.name,
        ));
      } else {
        request.files.add(
            await http.MultipartFile.fromPath('background', background.path));
      }
    }

    // Gửi request
    final response = await request.send();

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw Exception(
          'Failed to update profile: ${response.statusCode} - $body');
    }
  }
}
