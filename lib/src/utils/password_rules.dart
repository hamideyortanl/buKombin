import 'package:flutter/material.dart';

class PasswordRules {
  static const int minLen = 8;

  static final RegExp _hasLower = RegExp(r'[a-z]');
  static final RegExp _hasUpper = RegExp(r'[A-Z]');
  static final RegExp _hasDigit = RegExp(r'\d');

  // ✅ özel karakter seti: - . " ' , / \
  // Dart regex char class: [-\.\,"'\/\\]
  static final RegExp _hasSpecial = RegExp(r'[-\.\,"\\/\\]');

  static String? validate(String v) {
  if (v.isEmpty) return 'Şifre boş bırakılamaz.';
  if (v.length < minLen) return 'Şifre en az 8 karakter olmalı.';
  if (!_hasLower.hasMatch(v)) return 'Şifre en az 1 küçük harf içermeli.';
  if (!_hasUpper.hasMatch(v)) return 'Şifre en az 1 büyük harf içermeli.';
  if (!_hasDigit.hasMatch(v)) return 'Şifre en az 1 rakam içermeli.';
  if (!_hasSpecial.hasMatch(v)) {
  return 'Şifre en az 1 özel karakter içermeli: - . " \' , / \\';
  }
  return null;
  }

  /// 0.0 (boş) - 1.0 (güçlü)
  static double progress(String v) {
    if (v.isEmpty) return 0.0;

    int score = 0;
    if (v.length >= minLen) score++;
    if (_hasLower.hasMatch(v)) score++;
    if (_hasUpper.hasMatch(v)) score++;
    if (_hasDigit.hasMatch(v)) score++;
    if (_hasSpecial.hasMatch(v)) score++;

    // 0..5 => 0..1
    return (score / 5.0).clamp(0.0, 1.0);
  }

  /// 0: none, 1: weak, 2: medium, 3: strong
  static int level(String v) {
    if (v.isEmpty) return 0;

    final okLen = v.length >= minLen;
    final okL = _hasLower.hasMatch(v);
    final okU = _hasUpper.hasMatch(v);
    final okD = _hasDigit.hasMatch(v);
    final okS = _hasSpecial.hasMatch(v);

    final count = [okLen, okL, okU, okD, okS].where((e) => e).length;

    if (count <= 2) return 1; // weak
    if (count <= 4) return 2; // medium
    return 3; // strong
  }
}
