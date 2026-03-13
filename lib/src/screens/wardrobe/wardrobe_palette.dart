import 'package:flutter/material.dart';

/// Wardrobe sayfasında kullanılan ortak renk/gradient sabitleri.
///
/// Amaç: widget'ların içinde aynı sabitleri tekrar tekrar tanımlamamak.
class WardrobePalette {
  // backgrounds
  static const bg1 = Color(0xFFE8DDD5);
  static const bg2 = Color(0xFFD4C5B9);
  static const bg3 = Color(0xFFC9B8A8);

  // texts
  static const textDark = Color(0xFF3E2723);
  static const textBrown = Color(0xFF4A3428);
  static const textMuted = Color(0xFF6B675F);
  static const muted2 = Color(0xFF8B8680);

  // borders
  static const borderSoft = Color(0x66B4A193); // #B4A193/40

  // gradients
  static const g1 = Color(0xFF5C4033);
  static const g2 = Color(0xFF4A3428);
  static const g3 = Color(0xFF3E2723);
  static const headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [g1, g2, g3],
  );

  static const tileBg1 = Color(0xFFF5F1ED);
  static const tileBg2 = Color(0xFFE8DDD5);
  static const tileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tileBg1, tileBg2],
  );
}
