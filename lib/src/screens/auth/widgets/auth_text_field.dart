import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'glass_field_shell.dart';

enum AuthInputPolicy { fullName, username, email }

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;
  final TextInputType keyboardType;

  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final Color hintColor;

  final AuthInputPolicy inputPolicy;
  final ValueChanged<String>? onInvalidInput;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    required this.keyboardType,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.hintColor,
    required this.inputPolicy,
    this.onInvalidInput,
  });

  @override
  Widget build(BuildContext context) {
    final formatters = <TextInputFormatter>[
      _PolicyFormatter(
        policy: inputPolicy,
        onInvalid: (msg) => onInvalidInput?.call(msg),
      ),
    ];

    return GlassFieldShell(
      borderColor: borderColor,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor, fontSize: 16),
        inputFormatters: formatters,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(prefixIcon, color: iconColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

/// ✅ Karakter daha yazılırken engellenir + SnackBar/uyarı için callback
class _PolicyFormatter extends TextInputFormatter {
  final AuthInputPolicy policy;
  final ValueChanged<String>? onInvalid;

  _PolicyFormatter({required this.policy, this.onInvalid});

  static int _lastWarnMs = 0;

  void _warn(String msg) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastWarnMs < 700) return; // spam engeli
    _lastWarnMs = now;
    onInvalid?.call(msg);
  }

  bool _isAllowedFullName(String s) {
    // Türkçe dahil harf + boşluk
    return RegExp(r'^[A-Za-zÇĞİÖŞÜçğıöşü ]*$').hasMatch(s);
  }

  bool _isAllowedUsername(String s) {
    // sadece A-Z a-z 0-9
    return RegExp(r'^[A-Za-z0-9]*$').hasMatch(s);
  }

  bool _isAllowedEmailChars(String s) {
    // e-mail field'ında yazılabilecek karakter seti (boşluk yok)
    return RegExp(r'^[A-Za-z0-9@._%+\-]*$').hasMatch(s);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final t = newValue.text;

    if (t == oldValue.text) return newValue;

    switch (policy) {
      case AuthInputPolicy.fullName:
        if (!_isAllowedFullName(t)) {
          _warn('Ad Soyad sadece harf ve boşluk içerebilir.');
          return oldValue;
        }
        return newValue;

      case AuthInputPolicy.username:
        if (!_isAllowedUsername(t)) {
          _warn('Kullanıcı adı sadece A-Z, a-z ve 0-9 içerebilir. Türkçe/boşluk/sembol yok.');
          return oldValue;
        }
        if (t.isNotEmpty && RegExp(r'^\d').hasMatch(t)) {
          _warn('Kullanıcı adı rakamla başlayamaz.');
          return oldValue;
        }
        return newValue;

      case AuthInputPolicy.email:
        if (!_isAllowedEmailChars(t)) {
          _warn('E-posta alanında boşluk veya geçersiz karakter kullanılamaz.');
          return oldValue;
        }
        if (t.isNotEmpty && RegExp(r'^\d').hasMatch(t)) {
          _warn('E-posta rakamla başlayamaz.');
          return oldValue;
        }
        return newValue;
    }
  }
}
