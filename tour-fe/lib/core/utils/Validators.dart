// lib/presentation/widgets/Validators.dart
class Validators {
  static String? required(String? v, String msg) {
    if (v == null || v.trim().isEmpty) return msg;
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập email';
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(v.trim())) return 'Email không hợp lệ';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Nhập mật khẩu';
    if (v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    if (v == null || v.isEmpty) return 'Nhập xác nhận mật khẩu';
    if (v != original) return 'Mật khẩu xác nhận không khớp';
    return null;
  }
}
