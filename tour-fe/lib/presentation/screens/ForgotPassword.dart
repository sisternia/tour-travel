// lib/presentation/screens/ForgotPassword.dart
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import '../../data/repositories/verify_repository.dart';
import 'VerifyCode.dart';
import '../widgets/Button.dart';
import '../widgets/TextField.dart';
import '../../core/utils/Snackbar.dart';
import '../../core/utils/Validators.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailCtrl = TextEditingController();
  final _repo = VerifyRepository();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty) {
      SnackbarUtils.show(context, 'Nhập email');
      return;
    }

    setState(() => _loading = true);
    final res = await _repo.sendCode(_emailCtrl.text.trim());
    setState(() => _loading = false);

    SnackbarUtils.show(context, res['message'] ?? '');

    if (res['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VerifyCodeScreen(email: _emailCtrl.text.trim(), from: 'forgot'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quên mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _emailCtrl,
              label: "Email",
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: "Xác nhận",
              loading: _loading,
              onPressed: _submit,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text("Trở về"),
            ),
          ],
        ),
      ),
    );
  }
}
