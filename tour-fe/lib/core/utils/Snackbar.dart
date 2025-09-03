// lib/presentation/widgets/Snackbar.dart
import 'package:flutter/material.dart';

class SnackbarUtils {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
