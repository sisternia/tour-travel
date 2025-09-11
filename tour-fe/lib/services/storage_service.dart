import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/auth_model.dart';

class StorageService {
  static Future<void> saveLogin({
    required String token,
    required AuthModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString(
        'user_name', user.userName.isNotEmpty ? user.userName : 'Unknown');
    await prefs.setString('email', user.email);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
