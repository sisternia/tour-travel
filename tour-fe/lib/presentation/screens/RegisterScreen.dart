// lib/presentation/screens/RegisterScreen.dart
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'VerifyCode.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  final AuthRepository _repo = AuthRepository();

  @override
  void dispose() {
    _userNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final result = await _repo.register(
      userName: _userNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      confirmPassword: _confirmCtrl.text,
    );

    setState(() => _loading = false);

    final message = result['message']?.toString() ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (result['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyCodeScreen(
            email: _emailCtrl.text.trim(),
            from: "register",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _userNameCtrl,
                  decoration: const InputDecoration(labelText: "Tên đăng nhập"),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nhập tên đăng nhập'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Nhập email';
                    final emailRegex =
                        RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
                    if (!emailRegex.hasMatch(v.trim())) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Nhập mật khẩu';
                    if (v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: "Xác nhận mật khẩu",
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Nhập xác nhận mật khẩu';
                    if (v != _passwordCtrl.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text("Xác nhận"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text("Đã có tài khoản? Đăng nhập"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
