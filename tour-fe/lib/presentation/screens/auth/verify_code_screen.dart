// lib/presentation/screens/auth/verify_code_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/verify_repository.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';
import '../../widgets/Button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String from;

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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nhập đủ 6 số')));
      return;
    }

    setState(() => _loading = true);
    final res = await _repository.verifyAccount(widget.email, code,
        type: widget.from == 'forgot' ? 'forgot' : 'register');
    setState(() => _loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res['message'] ?? '')));

    if (res['success'] == true) {
      if (widget.from == 'forgot') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(email: widget.email)),
        );
      } else {
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

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res['message'] ?? '')));

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
            if (_controllers[i].text.isEmpty && i > 0) {
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
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(counterText: ""),
          onChanged: (val) {
            if (val.isNotEmpty) {
              if (i < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
              } else {
                _focusNodes[i].unfocus();
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
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mã sẽ được gửi tới: ${widget.email}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (i) => _buildOtpField(i)),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "Xác nhận",
                      loading: _loading,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: _goBack, child: const Text("Trở về")),
                      TextButton(
                          onPressed: _loading ? null : _resend,
                          child: const Text("Gửi lại mã")),
                    ],
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
