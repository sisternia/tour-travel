import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repositories/verify_repository.dart';
import 'RegisterScreen.dart';
import 'LoginScreen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String from; // "register" hoặc "login"

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
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode()); // focus cho từng ô
  final VerifyRepository _repository = VerifyRepository();
  bool _loading = false;

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
    setState(() => _loading = true);
    final res = await _repository.verifyAccount(widget.email, code);
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'] ?? '')),
    );
    if (res['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
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
  }

  void _goBack() {
    if (widget.from == "register") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Widget _buildOtpField(int i) {
    return SizedBox(
      width: 40,
      child: RawKeyboardListener(
        focusNode: FocusNode(), // để lắng nghe key events
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            final current = _controllers[i];
            if (current.text.isEmpty && i > 0) {
              // Trường hợp 2: ô trống, lùi về ô trước và xóa luôn ô trước
              _controllers[i - 1].text = '';
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            }
          }
        },
        child: TextField(
          controller: _controllers[i],
          focusNode: _focusNodes[i],
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(counterText: ""),
          onChanged: (val) {
            if (val.isNotEmpty) {
              if (i < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
              }
            } else {
              // Trường hợp 1: ô đang có ký tự bị xóa
              // giữ focus ở ô hiện tại
              if (i > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[i]);
              }
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
                    ? const CircularProgressIndicator()
                    : const Text("Xác nhận"),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _goBack,
                  child: const Text("Trở về"),
                ),
                TextButton(
                  onPressed: _loading ? null : _resend,
                  child: const Text("Gửi lại mã"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
