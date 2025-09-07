// lib/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/verify_repository.dart';
import 'home_screen.dart';
import 'verify_code_screen.dart';
import '../widgets/Button.dart';
import '../widgets/TextField.dart';
import '../../core/utils/Validators.dart';
import '../../core/utils/Dialogs.dart';
import '../../core/utils/Snackbar.dart';
import 'package:tour_fe/core/constants/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  final _repo = AuthRepository();

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
      SnackbarUtils.show(context, message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (res['status'] == 403) {
        AppDialogs.showVerifyDialog(
          context: context,
          onConfirm: () async {
            final verifyRepo = VerifyRepository();
            final r = await verifyRepo.sendCode(_emailCtrl.text.trim());
            SnackbarUtils.show(context, r['message'] ?? '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyCodeScreen(
                  email: _emailCtrl.text.trim(),
                  from: "login",
                ),
              ),
            );
          },
        );
      } else {
        SnackbarUtils.show(context, message);
      }
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

          // Illustration image
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
                        "Welcome back!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 24),

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

                      const SizedBox(height: 8),

                      // Remember me + Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (_) {}),
                              const Text("Ghi nhớ tôi"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ForgotPassword()),
                              );
                            },
                            child: const Text(
                              "Quên mật khẩu?",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Button đăng nhập
                      PrimaryButton(
                        text: "Sign in",
                        loading: _loading,
                        onPressed: _submit,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, color: Colors.white),
                            SizedBox(width: 8),
                            Text("Đăng nhập",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Text("Hoặc đăng nhập với"),
                      const SizedBox(height: 12),

                      // Social login icons
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.facebook, size: 32, color: Colors.blue),
                          Icon(Icons.alternate_email,
                              size: 32, color: Colors.lightBlue),
                          Icon(Icons.g_mobiledata, size: 40, color: Colors.red),
                          Icon(Icons.apple, size: 32, color: Colors.black),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Chưa có tài khoản? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Đăng ký",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
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
