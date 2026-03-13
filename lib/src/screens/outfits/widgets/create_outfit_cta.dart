import 'package:flutter/material.dart';

import '../painters/outfit_line_painter.dart';
import 'glass_card.dart';

class CreateOutfitCta extends StatelessWidget {
  final VoidCallback onTap;
  const CreateOutfitCta({super.key, required this.onTap});

  static const _textDark = Color(0xFF3E2723);
  static const _textMuted = Color(0xFF6B675F);

  static const _g1 = Color(0xFF5C4033);
  static const _g2 = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_g1, _g2],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A3428).withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: CustomPaint(painter: OutfitLinePainter()),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Yeni Kombin Oluştur',
              style: TextStyle(color: _textDark, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text(
            'AI destekli kombin önerileriyle stilinizi keşfedin',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textMuted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: const Color(0xFFE8DDD5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onTap,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [_g1, _g2],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A3428).withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text('Hemen Başla', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
