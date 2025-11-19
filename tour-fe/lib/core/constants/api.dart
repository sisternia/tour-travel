// lib/core/constants/api.dart
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

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

  static String get baseServerUrl => baseUrl;

  // Auth routes
  static String get register => '$baseUrl/api/auth/register';
  static String get login => '$baseUrl/api/auth/login';
  static String get sendVerifyCode => '$baseUrl/api/auth/send-verify-code';
  static String get verifyAccount => '$baseUrl/api/auth/verify-account';
  static String get resetPassword => '$baseUrl/api/auth/reset-password';

  // Profile routes
  static String get profile => '$baseUrl/api/profile';
  static String get updateProfile => '$baseUrl/api/profile';

  // Tour Type routes
  static String get tourtype => '$baseUrl/api/tour-types/tour_type';

  // Tour Categories routes
  static String get tourcategories => '$baseUrl/api/tour-categories';

  // Tour routes
  static String get tours => '$baseUrl/api/tours';
  static String get latestTours => '$baseUrl/api/tours/latest';
  static String tourById(int id) => '$baseUrl/api/tours/$id';
  static String updateTour(int id) => '$baseUrl/api/tours/$id';
  static String deleteTour(int id) => '$baseUrl/api/tours/$id';
  static String get createTour => '$baseUrl/api/tours';

  // Tour Prices routes
  static String get tourPrices => '$baseUrl/api/tour-prices/prices';
  static String get tourAssignments => '$baseUrl/api/tour-prices/assignments';
  static String get tourPriceTours => '$baseUrl/api/tour-prices/tours';
  static String tourAssignmentByTour(int tourId) =>
      '$baseUrl/api/tour-prices/assignment/$tourId';

  // Tour Images routes
  static String firstImage(int tourId) =>
      '$baseUrl/api/tour-images/first/$tourId';
  static String allImages(int tourId) => '$baseUrl/api/tour-images/all/$tourId';

  // Tour Locations routes
  static String get tourLocations => '$baseUrl/api/tour-locations';
  static String tourLocationsByTour(int tourId) =>
      '$baseUrl/api/tour-locations/$tourId';
}
