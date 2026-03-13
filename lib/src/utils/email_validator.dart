import 'package:flutter/material.dart';

class EmailValidator {
  /// ✅ Kayıt ekranında izin verilen e‑posta sağlayıcıları.
  /// İsterseniz ileride buraya yeni domain ekleyebilirsiniz.
  static const Set<String> allowedRegisterDomains = {
    'gmail.com',
    'googlemail.com',
    'hotmail.com',
    'hotmail.com.tr',
    'outlook.com',
    'outlook.com.tr',
    'live.com',
    'yahoo.com',
    'yahoo.com.tr',
    'ymail.com',
  };

  // Yaygın sağlayıcılar (kısıtlamak için değil, kullanıcı mesajlarını iyileştirmek / hızlı kontrol için)
  static const Set<String> commonDomains = {
    'gmail.com',
    'googlemail.com',
    'hotmail.com',
    'hotmail.com.tr',
    'outlook.com',
    'outlook.com.tr',
    'live.com',
    'yahoo.com',
    'yahoo.com.tr',
    'ymail.com',
    'icloud.com',
    'me.com',
    'mac.com',
    'aol.com',
    'proton.me',
    'protonmail.com',
    'gmx.com',
    'mail.com',
    'yandex.com',
    'yandex.ru',
  };

  // RFC'nin tamamı değil; mobil form doğrulama için pratik, “@ sonrası yanlışsa geçirmez”.
  static final RegExp _basic = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    r"[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?"
    r"(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$",
  );

  static bool isValid(String email) {
    final e = email.trim();
    if (!_basic.hasMatch(e)) return false;

    final at = e.lastIndexOf('@');
    if (at <= 0 || at == e.length - 1) return false;

    final domain = e.substring(at + 1).toLowerCase();

    // domain mutlaka nokta içermeli (ör: a@gmail -> ❌)
    if (!domain.contains('.')) return false;

    // Son parça (TLD) en az 2 harf olmalı (ör: a@b.c -> ✅, a@b.1 -> ❌)
    final parts = domain.split('.');
    final tld = parts.isNotEmpty ? parts.last : '';
    if (tld.length < 2 || !RegExp(r'^[a-z]{2,}$').hasMatch(tld)) return false;

    return true;
  }

  static bool isAllowedRegisterDomain(String email) {
    final e = email.trim();
    final at = e.lastIndexOf('@');
    if (at <= 0 || at == e.length - 1) return false;
    final domain = e.substring(at + 1).toLowerCase();
    return allowedRegisterDomains.contains(domain);
  }

  static String? validate(String? email) {
    final e = (email ?? '').trim();
    if (e.isEmpty) return 'E-posta boş olamaz.';
    if (!isValid(e)) return 'Lütfen geçerli bir e-posta girin (ör: ad@gmail.com).';
    return null;
  }

  /// Register için: format + domain kısıtı.
  static String? validateForRegister(String? email) {
    final baseErr = validate(email);
    if (baseErr != null) return baseErr;

    final e = (email ?? '').trim();
    if (!isAllowedRegisterDomain(e)) {
      return 'Lütfen @gmail.com, @hotmail.com, @yahoo.com, @outlook.com gibi geçerli bir e-posta sağlayıcısı kullanın.';
    }
    return null;
  }

  // İstersen ileride “gmail.com mu demek istediniz?” gibi öneri üretmek için kullanılabilir.
  static String? commonDomainHint(String email) {
    final e = email.trim();
    final at = e.lastIndexOf('@');
    if (at < 0) return null;
    final domain = e.substring(at + 1).toLowerCase();
    if (domain.isEmpty) return null;

    if (domain.contains('.') && commonDomains.contains(domain)) return null;

    // kullanıcı sadece "gmail" yazdıysa hızlı ipucu
    if (!domain.contains('.') && commonDomains.contains('$domain.com')) {
      return 'Şunu mu demek istediniz: @$domain.com ?';
    }
    return null;
  }
}
