import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/account.dart';

class AuthService {
  static const _kAccounts = 'bukombin_accounts';
  static const _kSessionUser = 'bukombin_session_user';

  // Kayıtlı hesapları diskten getirir
  Future<List<Account>> loadAccounts(SharedPreferences prefs) async {
    final raw = prefs.getString(_kAccounts);
    if (raw == null || raw.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Account.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  // Yeni hesap kaydeder
  Future<void> saveAccount(SharedPreferences prefs, List<Account> accounts, Account newAccount) async {
    accounts.add(newAccount);
    final raw = jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString(_kAccounts, raw);
  }

  // Oturumu kaydeder (Login olunca)
  Future<void> persistSession(SharedPreferences prefs, String username) async {
    await prefs.setString(_kSessionUser, username);
  }

  // Oturumu siler (Logout olunca)
  Future<void> clearSession(SharedPreferences prefs) async {
    await prefs.remove(_kSessionUser);
  }

  // Kayıtlı oturum var mı diye bakar
  String? getSessionUser(SharedPreferences prefs) {
    return prefs.getString(_kSessionUser);
  }
}