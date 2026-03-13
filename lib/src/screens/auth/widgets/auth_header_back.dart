import 'package:flutter/material.dart';

class AuthHeaderBack extends StatelessWidget {
  const AuthHeaderBack({super.key});

  static const iconBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back, color: iconBrown, size: 24),
        ),
      ),
    );
  }
}
