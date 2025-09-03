// lib/presentation/widgets/Dialogs.dart
import 'package:flutter/material.dart';

class AppDialogs {
  static void showVerifyDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tài khoản chưa được xác nhận"),
        content: const Text("Bạn cần xác nhận tài khoản để tiếp tục."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }
}
