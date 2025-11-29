// lib/presentation/widgets/TextField.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback? toggleObscure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.toggleObscure,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: onTap,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.disabled,
          validator: validator,
          mouseCursor: SystemMouseCursors.basic,
          decoration: InputDecoration(
            prefixIcon:
                icon != null ? Icon(icon, color: Colors.blueAccent) : null,
            labelText: label,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
            suffixIcon: toggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: toggleObscure,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
