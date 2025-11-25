// lib/presentation/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/Video_Background.dart';
import '../../widgets/Sliding_Form.dart';
import '../../widgets/Button.dart';
import '../../widgets/TextField.dart';
import '../../../core/utils/Validators.dart';
import '../../../core/utils/Snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import 'login_screen.dart';
import 'verify_code_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _ob1 = true;
  bool _ob2 = true;
  bool _loading = false;

  final _repo = AuthRepository();

  @override
  void dispose() {
    _userCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final res = await _repo.register(
      userName: _userCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      confirmPassword: _confirmCtrl.text,
    );

    setState(() => _loading = false);

    SnackbarUtils.show(context, res['message'] ?? '');

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
    final formHeight = MediaQuery.of(context).size.height * 0.75;

    return Scaffold(
      body: Stack(
        children: [
          const VideoBackground(),
          SlidingForm(
            formHeight: formHeight,
            child: _buildForm(formHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(double h) {
    return Container(
      height: h,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                "Đăng ký",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _userCtrl,
                label: "Tên đăng nhập",
                validator: (v) => Validators.required(v, "Nhập tên đăng nhập"),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailCtrl,
                label: "Email",
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passCtrl,
                label: "Mật khẩu",
                obscure: _ob1,
                toggleObscure: () => setState(() => _ob1 = !_ob1),
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmCtrl,
                label: "Xác nhận mật khẩu",
                obscure: _ob2,
                toggleObscure: () => setState(() => _ob2 = !_ob2),
                validator: (v) => Validators.confirmPassword(v, _passCtrl.text),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: "Đăng ký",
                loading: _loading,
                onPressed: _submit,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Đã có tài khoản? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
