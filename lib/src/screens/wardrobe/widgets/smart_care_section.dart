import 'dart:ui';

import 'package:flutter/material.dart';

import '../wardrobe_palette.dart';
import 'smart_care_tile.dart';

class SmartCareSection extends StatelessWidget {
  final VoidCallback onTap;
  const SmartCareSection({super.key, required this.onTap});

  static const _textLight = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: WardrobePalette.borderSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(colors: [WardrobePalette.g1, WardrobePalette.g2]),
                    ),
                    child: const Icon(Icons.notifications_active_outlined, color: _textLight, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Akıllı Bakım',
                      style: TextStyle(
                        color: WardrobePalette.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.chevron_right, color: WardrobePalette.muted2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SmartCareTile(
                emoji: '⚠️',
                title: 'Gri Sweatshirt',
                subtitle: 'Yıkanma zamanı',
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFF59E0B).withOpacity(0.18),
                    const Color(0xFFF97316).withOpacity(0.14),
                  ],
                ),
                onTap: onTap,
              ),
              const SizedBox(height: 10),
              SmartCareTile(
                emoji: '💧',
                title: 'Kahverengi Bot',
                subtitle: 'Bakım önerisi',
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.14),
                    const Color(0xFF06B6D4).withOpacity(0.12),
                  ],
                ),
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
