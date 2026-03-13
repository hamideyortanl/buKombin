import 'package:flutter/material.dart';

import 'home_glass_card.dart';

class HomeSustainabilityCard extends StatelessWidget {
  final String scoreText;
  final String subtitle;
  final double progress;

  const HomeSustainabilityCard({
    super.key,
    required this.scoreText,
    required this.subtitle,
    required this.progress,
  });

  static const _textBrown = Color(0xFF4A3428);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return HomeGlassCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF86A361), Color(0xFF6B8E4E)],
              ),
            ),
            child: const Icon(Icons.eco, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scoreText,
                  style: const TextStyle(
                    color: _textBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: _textMuted, height: 1.3)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 8,
                    color: Colors.white.withOpacity(0.60),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress.clamp(0, 1),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF86A361), Color(0xFF6B8E4E)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
