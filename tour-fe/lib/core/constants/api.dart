// core/constants/api.dart
class ApiConstants {
  static const String baseServerUrl = 'http://localhost:3000'; // Base server URL without /api
  static const String baseUrl = '$baseServerUrl/api'; // Base API URL

  // Auth Endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String sendVerifyCode = '$baseUrl/auth/send-verify-code';
  static const String verifyAccount = '$baseUrl/auth/verify-account';
  static const String resetPassword = '$baseUrl/auth/reset-password';
}