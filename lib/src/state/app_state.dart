import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import '../services/user_profile_service.dart';
import '../core/models/weather_now.dart';
import '../core/services/location_service.dart';
import '../core/services/weather_service.dart';
import '../models/account.dart';
import '../services/auth_service.dart';
import '../utils/password_hasher.dart';

class AppState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final UserProfileService _userProfileService = UserProfileService();
  late SharedPreferences _prefs;

  final List<Account> _accounts = [];
  Account? _current;

  WeatherNow? _weather;
  bool _isWeatherLoading = false;
  String? _weatherError;

  bool _initialized = false;

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _current != null;
  Account? get current => _current;

  WeatherNow? get weather => _weather;
  WeatherNow? get currentWeather => _weather;
  bool get isWeatherLoading => _isWeatherLoading;
  String? get weatherError => _weatherError;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final loadedAccounts = await _authService.loadAccounts(_prefs);
    _accounts.addAll(loadedAccounts);

    _restoreSession();

    _initialized = true;
    notifyListeners();
  }

  void _restoreSession() {
    final username = _authService.getSessionUser(_prefs);
    if (username != null) {
      final match = _accounts.where((a) => a.username == username).toList();
      if (match.isEmpty) {
        _authService.clearSession(_prefs);
        _current = null;
      } else {
        _current = match.first;
      }
    }
  }

  Future<void> refreshWeather() async {
    _isWeatherLoading = true;
    _weatherError = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      _weather = await _weatherService.fetchCurrentWeather(
        lat: position.latitude,
        lon: position.longitude,
      );
    } catch (e) {
      _weatherError = e.toString();
    } finally {
      _isWeatherLoading = false;
      notifyListeners();
    }
  }

  Future<String?> register({
    required String username,
    required String email,
    required String password,
    required bool isFamilyAccount,
    String? fullName,
    String? gender,
    String? femaleMode,
  }) async {
    if (_accounts.any((a) => a.username == username)) {
      return 'Kullanıcı adı dolu.';
    }

    if (_accounts.any((a) => a.email == email)) {
      return 'E-posta dolu.';
    }

    try {
      final credential = await _firebaseAuthService.register(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        return 'Kullanıcı hesabı oluşturulamadı.';
      }

      try {
        await _userProfileService.createUserProfile(
          uid: firebaseUser.uid,
          username: username,
          email: email,
          fullName: fullName,
          gender: gender,
          femaleMode: femaleMode,
          isFamilyAccount: isFamilyAccount,
        );
      } catch (_) {
        try {
          await firebaseUser.delete();
        } catch (_) {}
        return 'Profil verisi kaydedilemedi. Lütfen tekrar deneyin.';
      }

      // Geçici köprü:
      // Login ekranın henüz local sistemle çalıştığı için
      // bu hesabı şimdilik local'e de kaydediyoruz.
      final salt = PasswordHasher.generateSalt();
      final hashed = PasswordHasher.hash(password, salt);

      final secureAccount = Account(
        username: username.trim(),
        email: email.trim(),
        salt: salt,
        passwordHash: hashed,
        isFamilyAccount: isFamilyAccount,
      );

      await _authService.saveAccount(_prefs, _accounts, secureAccount);

      _current = secureAccount;
      await _authService.persistSession(_prefs, secureAccount.username);

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Bu e-posta zaten kullanımda.';
        case 'invalid-email':
          return 'Geçerli bir e-posta adresi girin.';
        case 'weak-password':
          return 'Şifre çok zayıf.';
        default:
          return e.message ?? 'Kayıt sırasında hata oluştu.';
      }
    } catch (_) {
      return 'Kayıt sırasında beklenmeyen bir hata oluştu.';
    }
  }

  Future<String?> login({required String username, required String password}) async {
    try {
      final candidate = _accounts.firstWhere(
            (a) => (a.username == username || a.email == username),
      );

      if (candidate.salt.trim().isEmpty || candidate.passwordHash.trim().isEmpty) {
        return 'Güvenlik güncellemesi nedeniyle lütfen yeniden kayıt olun.';
      }

      final computed = PasswordHasher.hash(password, candidate.salt);
      if (computed != candidate.passwordHash) {
        return 'Kullanıcı adı veya şifre hatalı.';
      }

      _current = candidate;
      await _authService.persistSession(_prefs, candidate.username);
      notifyListeners();
      return null;
    } catch (_) {
      return 'Kullanıcı adı veya şifre hatalı.';
    }
  }

  Future<void> logout() async {
    _current = null;
    _weather = null;
    _weatherError = null;
    await _authService.clearSession(_prefs);
    notifyListeners();
  }
}