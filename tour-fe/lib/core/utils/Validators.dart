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

  // NEW — Phone
  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập số điện thoại';
    final regex = RegExp(r'^[0-9]{9,11}$');
    if (!regex.hasMatch(v.trim())) return 'Số điện thoại không hợp lệ';
    return null;
  }

  // NEW — Citizen ID
  static String? citizenId(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập CCCD';
    if (v.length != 12) return 'CCCD phải gồm 12 số';
    if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'CCCD chỉ chứa số';
    return null;
  }

  // NEW — Address
  static String? address(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập địa chỉ';
    return null;
  }

  // NEW — Bio
  static String? bio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập mô tả';
    if (v.length < 10) return 'Mô tả tối thiểu 10 ký tự';
    return null;
  }

  // NEW — Date of Birth
  static String? dob(String? v) {
    if (v == null || v.trim().isEmpty) return 'Chọn ngày sinh';
    return null;
  }
}
