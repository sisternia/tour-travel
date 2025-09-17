// lib/core/constants/api.dart
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Cấu hình base URL cho nhiều môi trường.
/// - Web: mặc định dùng http://localhost:3000
/// - Android emulator (Android Studio): http://10.0.2.2:3000
/// - iOS simulator / macOS: http://localhost:3000
///
/// Nếu bạn chạy trên thiết bị thật (physical device),
/// hãy gán ApiConstants.androidHost = '192.168.x.x' (IP máy dev của bạn).
class ApiConstants {
  static String androidHost = '10.0.2.2';
  static String iosHost = 'localhost';
  static String webHost = 'localhost';
  static int port = 3000;

  static String get baseUrl {
    if (kIsWeb) return 'http://$webHost:$port';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://$androidHost:$port';
    } else {
      return 'http://$iosHost:$port';
    }
  }

  static String get register => '$baseUrl/api/auth/register';
  static String get login => '$baseUrl/api/auth/login';
  static String get sendVerifyCode => '$baseUrl/api/auth/send-verify-code';
  static String get verifyAccount => '$baseUrl/api/auth/verify-account';
  static String get resetPassword => '$baseUrl/api/auth/reset-password';
  // ---------------- TOUR TYPE ----------------
  static String get tourtype => '$baseUrl/api/tour-types/tour_type';
  // ---------------- TOURS ----------------
  static String get tours => '$baseUrl/api/tours'; // lấy tất cả tour
  static String get latestTours => '$baseUrl/api/tours/latest'; // tour mới nhất
  static String tourById(int id) => '$baseUrl/api/tours/$id'; // tour theo id
  static String updateTour(int id) => '$baseUrl/api/tours/$id'; // PUT cập nhật
  static String deleteTour(int id) => '$baseUrl/api/tours/$id'; // DELETE
  static String get createTour => '$baseUrl/api/tours'; // POST tạo tour
}
