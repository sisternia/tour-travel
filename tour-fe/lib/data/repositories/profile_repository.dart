// data/repositories/profile_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tour_fe/core/constants/api.dart'; // Assuming you have an API constants file

class ProfileRepository {
  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> updateProfile(
      String token, Map<String, String> data, XFile? avatar, XFile? background) async {
    var request = http.MultipartRequest('PUT', Uri.parse('${ApiConstants.baseUrl}/profile'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(data);

    if (avatar != null) {
      final avatarBytes = await avatar.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('avatar', avatarBytes, filename: avatar.name));
    }

    if (background != null) {
      final backgroundBytes = await background.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('background', backgroundBytes, filename: background.name));
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to update profile: ${response.reasonPhrase}, $responseBody');
    }
  }
}
