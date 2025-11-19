// lib/core/constants/api.dart
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiConstants {
  static String androidHost = '192.168.88.123';
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

  /// URL gốc của server (để load ảnh, asset)
  static String get baseServerUrl => baseUrl;

  /// Auth routes
  static String get register => '$baseUrl/api/auth/register';
  static String get login => '$baseUrl/api/auth/login';
  static String get sendVerifyCode => '$baseUrl/api/auth/send-verify-code';
  static String get verifyAccount => '$baseUrl/api/auth/verify-account';
  static String get resetPassword => '$baseUrl/api/auth/reset-password';

  /// Profile routes
  static String get profile => '$baseUrl/api/profile';
  static String get updateProfile => '$baseUrl/api/profile';

  /// Tour Type routes
  static String get tourtype => '$baseUrl/api/tour-types/tour_type';

  /// Tour routes
  static String get tours => '$baseUrl/api/tours';
  static String get latestTours => '$baseUrl/api/tours/latest';
  static String tourById(int id) => '$baseUrl/api/tours/$id';
  static String updateTour(int id) => '$baseUrl/api/tours/$id';
  static String deleteTour(int id) => '$baseUrl/api/tours/$id';
  static String get createTour => '$baseUrl/api/tours';
}
