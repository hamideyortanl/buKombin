import 'package:flutter/material.dart';
import 'glass_field_shell.dart';

class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool show;
  final VoidCallback onToggle;
  final String hintText;
  final bool showToggle;

  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final Color hintColor;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.show,
    required this.onToggle,
    required this.hintText,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.hintColor,
    this.showToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassFieldShell(
      borderColor: borderColor,
      child: TextField(
        controller: controller,
        obscureText: !show, // Şifre noktaları (Artık çökmeyecek!)
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(Icons.lock_outline, color: iconColor),
          suffixIcon: showToggle
              ? IconButton(
            onPressed: onToggle,
            icon: Icon(show ? Icons.visibility_off : Icons.visibility, color: iconColor),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}