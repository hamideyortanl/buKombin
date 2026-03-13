import 'package:flutter/material.dart';

class BuKombinColors {
  static const beige1 = Color(0xFFE8DDD5);
  static const beige2 = Color(0xFFD4C5B9);
  static const beige3 = Color(0xFFC9B8A8);

  static const brown1 = Color(0xFF5C4033);
  static const brown2 = Color(0xFF4A3428);
  static const brown3 = Color(0xFF3E2723);

  static const stone = Color(0xFF6B675F);
  static const stone2 = Color(0xFF8B8680);
  static const accent = Color(0xFFB4A193);

  static const whiteGlass = Color(0x99FFFFFF);
}

class BuKombinTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: BuKombinColors.brown2,
      primary: BuKombinColors.brown2,
      secondary: BuKombinColors.accent,
      surface: Colors.white,
      background: Colors.white,
      onPrimary: BuKombinColors.beige1,
      onSecondary: BuKombinColors.brown3,
      onSurface: BuKombinColors.brown3,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      // Material 3'te bazı bileşenler (özellikle Card) otomatik "surface tint" uygular.
      // Uygulama genelinde arka plan beyaz ve temiz kalsın diye kapatıyoruz.
      textTheme: base.textTheme.apply(
        bodyColor: BuKombinColors.brown3,
        displayColor: BuKombinColors.brown3,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: BuKombinColors.brown3,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BuKombinColors.whiteGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: BuKombinColors.accent.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: BuKombinColors.accent.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BuKombinColors.brown2, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: BuKombinColors.stone2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: BuKombinColors.beige1,
          backgroundColor: BuKombinColors.brown2,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      // Topluluk akışı / takipçi kartları dahil, tüm kartlar aynı: beyaz zemin + hafif çerçeve.
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: BuKombinColors.accent.withOpacity(0.35)),
        ),
      ),
    );
  }
}

LinearGradient buKombinBackgroundGradient() {
  // Geriye dönük uyumluluk için: eski gradient fonksiyonu.
  // Yeni sayfalarda `buKombinBackgroundDecoration(context)` kullanılıyor (tema ile uyumlu).
  return const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BuKombinColors.beige1,
      BuKombinColors.beige2,
      BuKombinColors.beige3,
    ],
  );
}

BoxDecoration buKombinBackgroundDecoration(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  // İstenen ortak tema: tüm sayfalarda arka plan **beyaz**.
  // (İleride koyu tema eklerseniz burada koşullu olarak değiştirebilirsiniz.)
  return BoxDecoration(color: cs.background);
}
LinearGradient buKombinPrimaryButtonGradient() {
  return const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      BuKombinColors.brown1,
      BuKombinColors.brown2,
      BuKombinColors.brown3,
    ],
  );
}
