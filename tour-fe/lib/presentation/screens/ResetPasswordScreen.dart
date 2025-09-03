// lib/presentation/screens/ResetPassword.dart
import 'package:flutter/material.dart';
import '../../data/repositories/verify_repository.dart';
import 'LoginScreen.dart';
import 'VerifyCode.dart';
import '../widgets/Button.dart';
import '../widgets/TextField.dart';
import '../../core/utils/Snackbar.dart';
import '../../core/utils/Validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _repo = VerifyRepository();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final err = Validators.password(_passCtrl.text) ??
        Validators.confirmPassword(_confirmCtrl.text, _passCtrl.text);
    if (err != null) {
      SnackbarUtils.show(context, err);
      return;
    }

    setState(() => _loading = true);
    final res = await _repo.resetPassword(widget.email, _passCtrl.text);
    setState(() => _loading = false);

    SnackbarUtils.show(context, res['message'] ?? '');

    if (res['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyCodeScreen(email: widget.email, from: 'forgot'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Đặt mật khẩu mới cho: ${widget.email}'),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _passCtrl,
              label: "Mật khẩu",
              obscure: _obscurePass,
              toggleObscure: () => setState(() => _obscurePass = !_obscurePass),
              validator: Validators.password,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _confirmCtrl,
              label: "Xác nhận mật khẩu",
              obscure: _obscureConfirm,
              toggleObscure: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              validator: (v) => Validators.confirmPassword(v, _passCtrl.text),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: "Xác nhận",
              loading: _loading,
              onPressed: _submit,
            ),
            TextButton(onPressed: _goBack, child: const Text('Trở về')),
          ],
        ),
      ),
    );
  }
}
