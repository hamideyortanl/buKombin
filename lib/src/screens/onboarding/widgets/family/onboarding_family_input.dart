import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingFamilyInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final List<TextInputFormatter>? inputFormatters;

  const OnboardingFamilyInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.inputFormatters,
  });

  static const textDark = Color(0xFF3E2723);
  static const borderSoft = Color(0x66B4A193);
  static const placeholder = Color(0xFF8B8680);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: textDark),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: placeholder),
        prefixIcon: Icon(icon, color: const Color(0xFF6B675F)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.80),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4A3428), width: 1.2),
        ),
      ),
    );
  }
}
