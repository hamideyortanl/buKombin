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
  static const inputFill = Color(0xFFFCFBFA);
  static const pageBackground = Color(0xFFFCFBFA);
}

class BuKombinMetrics {
  static const double pageHorizontalPadding = 24;
  static const double pageTopGap = 18;
  static const double headerBottomRadius = 32;
  static const double headerHorizontalPadding = pageHorizontalPadding;
  static const double headerTopPadding = 18;
  static const double headerBottomPadding = 22;
  static const double sectionGap = 16;
  static const double cardRadius = 18;
  static const double inputRadius = 18;
  static const EdgeInsets pageBodyPadding = EdgeInsets.fromLTRB(
    pageHorizontalPadding,
    18,
    pageHorizontalPadding,
    24,
  );
  static const EdgeInsets standardHeaderPadding = EdgeInsets.fromLTRB(
    headerHorizontalPadding,
    headerTopPadding,
    headerHorizontalPadding,
    headerBottomPadding,
  );
}

class BuKombinDecorations {
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      BuKombinColors.brown1,
      BuKombinColors.brown2,
      BuKombinColors.brown3,
    ],
  );

  static BoxDecoration headerBox({double opacity = 0.30}) {
    return BoxDecoration(
      gradient: headerGradient,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(BuKombinMetrics.headerBottomRadius),
      ),
      boxShadow: [
        BoxShadow(
          color: BuKombinColors.brown2.withValues(alpha: opacity),
          blurRadius: 40,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration inputShell({Color? borderColor}) {
    return BoxDecoration(
      color: BuKombinColors.inputFill,
      borderRadius: BorderRadius.circular(BuKombinMetrics.inputRadius),
      border: Border.all(
        color: borderColor ?? BuKombinColors.accent.withValues(alpha: 0.34),
        width: 1,
      ),
    );
  }

  static BoxDecoration glassSurface({double alpha = 0.10, double borderAlpha = 0.22}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: alpha),
      borderRadius: BorderRadius.circular(BuKombinMetrics.cardRadius),
      border: Border.all(color: Colors.white.withValues(alpha: borderAlpha)),
    );
  }

  static BoxDecoration softCard({double borderAlpha = 0.26}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(BuKombinMetrics.cardRadius),
      border: Border.all(color: BuKombinColors.accent.withValues(alpha: borderAlpha)),
    );
  }
}

class BuKombinInputStyles {
  static InputDecoration authField({
    required String hintText,
    required IconData prefixIcon,
    Color iconColor = BuKombinColors.stone,
    Color hintColor = BuKombinColors.stone2,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor),
      prefixIcon: Icon(prefixIcon, color: iconColor),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static InputDecoration headerSearch({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(prefixIcon, color: Colors.white.withValues(alpha: 0.94)),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class BuKombinTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: BuKombinColors.brown2,
      primary: BuKombinColors.brown2,
      secondary: BuKombinColors.accent,
      surface: Colors.white,
      background: BuKombinColors.pageBackground,
      onPrimary: BuKombinColors.beige1,
      onSecondary: BuKombinColors.brown3,
      onSurface: BuKombinColors.brown3,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BuKombinColors.pageBackground,
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
        fillColor: BuKombinColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BuKombinMetrics.inputRadius),
          borderSide: BorderSide(color: BuKombinColors.accent.withValues(alpha: 0.34)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BuKombinMetrics.inputRadius),
          borderSide: BorderSide(color: BuKombinColors.accent.withValues(alpha: 0.34)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BuKombinMetrics.inputRadius),
          borderSide: const BorderSide(color: BuKombinColors.brown2, width: 1.15),
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
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(BuKombinMetrics.cardRadius)),
          side: BorderSide(color: BuKombinColors.accent.withValues(alpha: 0.30)),
        ),
      ),
    );
  }
}

LinearGradient buKombinBackgroundGradient() {
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
  return const BoxDecoration(color: BuKombinColors.pageBackground);
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
