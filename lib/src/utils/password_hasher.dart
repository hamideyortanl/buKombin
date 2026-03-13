import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'sha256.dart';

class PasswordHasher {
  static String generateSalt({int bytes = 16}) {
    final r = Random.secure();
    final raw = List<int>.generate(bytes, (_) => r.nextInt(256));
    return base64UrlEncode(raw);
  }

  /// Returns a hex encoded SHA-256 of "salt + password".
  ///
  /// Note: For a production backend you should use a slow hash (bcrypt/argon2/scrypt).
  /// This is only to avoid storing plaintext passwords in local SharedPreferences.
  static String hash(String password, String salt) {
    final bytes = utf8.encode('$salt$password');
    return sha256Hex(Uint8List.fromList(bytes));
  }
}
