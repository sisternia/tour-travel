// services/profile_service.dart
import 'package:image_picker/image_picker.dart';
import 'package:tour_fe/data/repositories/profile_repository.dart';

class ProfileService {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Map<String, dynamic>> getProfile(String token) async {
    return await _profileRepository.getProfile(token);
  }

  Future<void> updateProfile(
      String token, Map<String, String> data, XFile? avatar, XFile? background) async {
    await _profileRepository.updateProfile(token, data, avatar, background);
  }
}
