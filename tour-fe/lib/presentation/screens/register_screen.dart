// lib/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'verify_code_screen.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/Button.dart';
import '../widgets/TextField.dart';
import '../../core/utils/Validators.dart';
import '../../core/utils/Snackbar.dart';
import 'package:tour_fe/core/constants/color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;
  final _repo = AuthRepository();

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

    final res = await _repo.register(
      userName: _userNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      confirmPassword: _confirmCtrl.text,
    );

    setState(() => _loading = false);
    final message = res['message']?.toString() ?? '';
    SnackbarUtils.show(context, message);

    if (res['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VerifyCodeScreen(email: _emailCtrl.text.trim(), from: "register"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(gradient: background1),
          ),

          // Illustration
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/illustration.png',
              fit: BoxFit.cover,
              height: 230,
            ),
          ),

          // Form container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.70,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Đăng ký",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Username
                      CustomTextField(
                        controller: _userNameCtrl,
                        label: "Tên đăng nhập",
                        validator: (v) =>
                            Validators.required(v, 'Nhập tên đăng nhập'),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      CustomTextField(
                        controller: _emailCtrl,
                        label: "Email",
                        validator: Validators.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      CustomTextField(
                        controller: _passwordCtrl,
                        label: "Mật khẩu",
                        obscure: _obscurePassword,
                        toggleObscure: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      CustomTextField(
                        controller: _confirmCtrl,
                        label: "Xác nhận mật khẩu",
                        obscure: _obscureConfirmPassword,
                        toggleObscure: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                        validator: (v) =>
                            Validators.confirmPassword(v, _passwordCtrl.text),
                      ),

                      const SizedBox(height: 24),

                      // Register button
                      PrimaryButton(
                        text: "Đăng ký",
                        loading: _loading,
                        onPressed: _submit,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.app_registration, color: Colors.white),
                            SizedBox(width: 8),
                            Text("Đăng ký",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Link to login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Đã có tài khoản? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Đăng nhập",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
