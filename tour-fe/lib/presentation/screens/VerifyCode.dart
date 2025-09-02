// lib/presentation/screens/VerifyCode.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repositories/verify_repository.dart';
import 'RegisterScreen.dart';
import 'LoginScreen.dart';
import 'ResetPasswordScreen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String from; // "register" hoặc "login" hoặc "forgot"

  const VerifyCodeScreen({
    super.key,
    required this.email,
    required this.from,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final VerifyRepository _repository = VerifyRepository();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // focus ô đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập đủ 6 số')),
      );
      return;
    }

    setState(() => _loading = true);
    final res = await _repository.verifyAccount(widget.email, code,
        type: widget.from == 'forgot' ? 'forgot' : 'register');
    setState(() => _loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'] ?? '')),
    );

    if (res['success'] == true) {
      if (widget.from == 'forgot') {
        // chuyển sang màn ResetPassword, truyền email
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        // register flow -> về Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  Future<void> _resend() async {
    setState(() => _loading = true);
    final res = await _repository.sendCode(widget.email);
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'] ?? '')),
    );
    // clear inputs and focus first
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _goBack() {
    if (widget.from == "register") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
    } else {
      // both login & forgot go back to LoginScreen (for forgot we may want Verify->Forgot but spec said back to Verify)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Widget _buildOtpField(int i) {
    return SizedBox(
      width: 48,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            final current = _controllers[i];
            if (current.text.isEmpty && i > 0) {
              // ô trống: lùi về ô trước và xóa ô trước
              _controllers[i - 1].text = '';
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            } else {
              // nếu có ký tự trong ô thì xóa ký tự trong ô hiện tại (TextField sẽ làm việc)
            }
          }
        },
        child: TextField(
          controller: _controllers[i],
          focusNode: _focusNodes[i],
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(counterText: ""),
          onChanged: (val) {
            if (val.isNotEmpty) {
              if (i < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
              } else {
                _focusNodes[i].unfocus();
              }
            } else {
              // Nếu vừa xóa ký tự ở ô có ký tự trước đó (trường hợp 1): giữ focus ở ô hiện tại
              // Nếu ô đã rỗng và backspace => onKey xử lý sẽ lùi và clear ô trước
              // Không cần làm gì thêm ở đây
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xác nhận tài khoản")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Mã sẽ được gửi tới: ${widget.email}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) => _buildOtpField(i)),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: _goBack, child: const Text("Trở về")),
                TextButton(
                    onPressed: _loading ? null : _resend,
                    child: const Text("Gửi lại mã")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
