import 'package:flutter/material.dart';

import 'home_glass_card.dart';

class HomeActivityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const HomeActivityRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const _textBrown = Color(0xFF4A3428);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return HomeGlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD4C5B9), Color(0xFFC9B8A8)],
              ),
            ),
            child: Icon(icon, color: _textBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _textBrown, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: _textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
