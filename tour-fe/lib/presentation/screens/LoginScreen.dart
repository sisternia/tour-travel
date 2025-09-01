// lib/presentation/screens/LoginScreen.dart
import 'package:flutter/material.dart';
import 'package:tour_fe/data/repositories/verify_repository.dart';
import 'RegisterScreen.dart';
import 'ForgotPassword.dart';
import '../../data/repositories/auth_repository.dart';
import 'HomeScreen.dart';
import 'VerifyCode.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  final AuthRepository _repo = AuthRepository();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final res = await _repo.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    setState(() => _loading = false);

    final message = res['message']?.toString() ?? '';

    if (res['success'] == true) {
      // Đăng nhập thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      final status = res['status'];
      if (status == 403) {
        // Chưa xác nhận tài khoản
        _showVerifyDialog(_emailCtrl.text.trim());
      } else {
        // Sai mật khẩu / lỗi khác
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  void _showVerifyDialog(String email) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tài khoản chưa được xác nhận"),
        content: const Text("Bạn cần xác nhận tài khoản để tiếp tục."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // đóng dialog

              // Gửi lại mã xác thực
              final verifyRepo = VerifyRepository();
              final res = await verifyRepo.sendCode(email);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(res['message'] ?? '')),
              );

              // Chuyển tới VerifyCode
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VerifyCodeScreen(
                    email: email,
                    from: "login",
                  ),
                ),
              );
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nhập mật khẩu';
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPassword()));
                  },
                  child: const Text("Quên mật khẩu"),
                ),
              ),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()));
                },
                child: const Text("Chưa có tài khoản? Đăng ký"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
