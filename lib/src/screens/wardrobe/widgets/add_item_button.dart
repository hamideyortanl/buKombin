import 'package:flutter/material.dart';

import '../wardrobe_palette.dart';

/// Akıllı Bakımın üstündeki "Ekle" butonu.
class AddItemButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddItemButton({super.key, required this.onTap});

  static const _textLight = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: WardrobePalette.headerGradient,
          boxShadow: [
            BoxShadow(
              color: WardrobePalette.textBrown.withOpacity(0.22),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: _textLight),
            SizedBox(width: 10),
            Text(
              'Ekle',
              style: TextStyle(
                color: _textLight,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
