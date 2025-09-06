// lib/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'verify_code_screen.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/Button.dart';
import '../widgets/TextField.dart';
import '../../core/utils/Validators.dart';
import '../../core/utils/Snackbar.dart';

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
      // ❌ Bỏ AppBar giống LoginScreen
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
                    "Đăng ký",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _userNameCtrl,
                    label: "Tên đăng nhập",
                    validator: (v) =>
                        Validators.required(v, 'Nhập tên đăng nhập'),
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _confirmCtrl,
                    label: "Xác nhận mật khẩu",
                    obscure: _obscureConfirmPassword,
                    toggleObscure: () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                    validator: (v) =>
                        Validators.confirmPassword(v, _passwordCtrl.text),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "Xác nhận",
                    loading: _loading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 12),
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
      ),
    );
  }
}
