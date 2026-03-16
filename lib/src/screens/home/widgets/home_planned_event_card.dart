import 'package:flutter/material.dart';

import 'home_glass_card.dart';

class HomePlannedEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String outfit;
  final IconData icon;
  final String? recommendation;
  final bool isUrgent;
  final VoidCallback? onTap;

  const HomePlannedEventCard({
    super.key,
    required this.title,
    required this.date,
    required this.outfit,
    required this.icon,
    this.recommendation,
    this.isUrgent = false,
    this.onTap,
  });

  static const _textBrown = Color(0xFF4A3428);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return HomeGlassCard(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Row(
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(color: _textBrown, fontWeight: FontWeight.w800),
                            ),
                          ),
                          if (isUrgent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C4033).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Yakın',
                                style: TextStyle(
                                  color: _textBrown,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
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
            if (recommendation != null && recommendation!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, size: 18, color: _textBrown.withOpacity(0.85)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation!,
                        style: const TextStyle(
                          color: _textBrown,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
