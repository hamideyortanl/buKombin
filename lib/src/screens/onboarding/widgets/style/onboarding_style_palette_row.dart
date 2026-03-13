import 'package:flutter/material.dart';

class OnboardingPaletteRow extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final bool selected;
  final VoidCallback onTap;

  // ✅ senin hatandaki bubbleSize için parametre EKLENDİ
  final double bubbleSize;

  const OnboardingPaletteRow({
    super.key,
    required this.label,
    required this.colors,
    required this.selected,
    required this.onTap,
    this.bubbleSize = 26,
  });

  static const _borderSoft = Color(0x66B4A193);
  static const _textBrown = Color(0xFF4A3428);
  static const _textLight = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
    final c = colors.length >= 3
        ? colors.take(3).toList()
        : [...colors, ...List.filled(3 - colors.length, Colors.transparent)];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: 2,
            color: selected ? const Color(0xFF4A3428) : _borderSoft,
          ),
          gradient: selected
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5C4033), Color(0xFF4A3428)],
          )
              : null,
          color: selected ? null : Colors.white.withOpacity(0.60),
          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFF4A3428).withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ]
              : null,
        ),
        child: Row(
          children: [
            Row(
              children: [
                for (final col in c)
                  Container(
                    width: bubbleSize,
                    height: bubbleSize,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: col,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.30), width: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? _textLight : _textBrown,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check : Icons.circle_outlined,
              color: selected ? _textLight : const Color(0xFF8B8680),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
