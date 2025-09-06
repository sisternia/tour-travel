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
      // ❌ Bỏ AppBar đi
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Đăng nhập",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _emailCtrl,
                    label: "Email",
                    validator: Validators.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _passwordCtrl,
                    label: "Mật khẩu",
                    obscure: _obscurePassword,
                    toggleObscure: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPassword()),
                        );
                      },
                      child: const Text("Quên mật khẩu?"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "Đăng nhập",
                    loading: _loading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text("Chưa có tài khoản? Đăng ký"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
