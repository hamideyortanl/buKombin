import 'package:flutter/material.dart';

import 'home_glass_card.dart';

class HomePlannedEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String outfit;
  final IconData icon;

  const HomePlannedEventCard({
    super.key,
    required this.title,
    required this.date,
    required this.outfit,
    required this.icon,
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
                colors: [Color(0xFFB4A193), Color(0xFFD4C5B9)],
              ),
            ),
            child: Icon(icon, color: _textBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _textBrown, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: _textMuted)),
                const SizedBox(height: 6),
                Text(
                  outfit,
                  style: TextStyle(color: _textBrown.withOpacity(0.90), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _textMuted),
        ],
      ),
    );
  }
}
