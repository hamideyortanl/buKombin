import 'package:flutter/material.dart';
import '../../../../utils/password_rules.dart';

class PasswordStrengthBar extends StatelessWidget {
  final String password;
  const PasswordStrengthBar({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final level = PasswordRules.level(password);

    // ✅ Şifre boşsa hiç renk yok
    if (level == 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 10,
          color: Colors.black.withOpacity(0.08),
        ),
      );
    }

    double progress;
    Color color;

    // zayıf: %30 kırmızı, orta: %50 turuncu, güçlü: %100 yeşil
    if (level == 1) {
      progress = 0.30;
      color = Colors.red;
    } else if (level == 2) {
      progress = 0.50;
      color = Colors.orange;
    } else {
      progress = 1.00;
      color = Colors.green;
    }

    return LayoutBuilder(
      builder: (context, c) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 10,
            color: Colors.black.withOpacity(0.08),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: c.maxWidth * progress,
                height: 10,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}
