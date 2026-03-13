import 'package:flutter/material.dart';

class OnboardingResponsiveGrid {
  static const double _minTileWidth = 185; // ✅ 210 -> 185 (2 kolon daha geç)
  static const double _spacing = 12;

  static int crossAxisCountFor(double width) {
    // Telefon aralığında 2 kolonu koru (1'e çok erken düşmesin)
    if (width >= 200 && width < 560) return 2;

    final raw = ((width + _spacing) / (_minTileWidth + _spacing)).floor();
    return raw.clamp(1, 3);
  }

  static double childAspectRatioFor(double width, {required int crossAxisCount}) {
    if (crossAxisCount >= 3) return 0.92;
    if (crossAxisCount == 2) return 0.72; // ✅ daha uzun kart
    return 1.55;
  }

  static SliverGridDelegate delegateForWidth(double width) {
    final cross = crossAxisCountFor(width);
    final ratio = childAspectRatioFor(width, crossAxisCount: cross);

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: cross,
      crossAxisSpacing: _spacing,
      mainAxisSpacing: _spacing,
      childAspectRatio: ratio,
    );
  }
}
