import 'package:flutter/material.dart';

class OnboardingFamilyDashedAddButton extends StatelessWidget {
  final VoidCallback onTap;
  const OnboardingFamilyDashedAddButton({super.key, required this.onTap});

  static const textBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18), // ✅ boş ekran olmasın
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFB4A193),
            width: 2,
            style: BorderStyle.solid,
          ),
          color: Colors.white.withOpacity(0.20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: textBrown),
            SizedBox(width: 10),
            Text('Aile Üyesi Ekle', style: TextStyle(color: textBrown)),
          ],
        ),
      ),
    );
  }
}
