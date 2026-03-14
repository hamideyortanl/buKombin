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
    _accounts
      ..clear()
      ..addAll(loadedAccounts);

    final firebaseUser = _firebaseAuthService.currentUser;

    if (firebaseUser != null) {
      final profile = await _userProfileService.getUserProfile(firebaseUser.uid);
      if (profile != null) {
        _current = _accountFromProfile(profile);

        final username = (profile['username'] ?? '').toString();
        final email = (profile['email'] ?? '').toString();

        if (username.isNotEmpty && email.isNotEmpty) {
          await _userProfileService.ensureUsernameMapping(
            uid: firebaseUser.uid,
            username: username,
            email: email,
          );
        }
      }
    } else {
      _current = null;
      await _authService.clearSession(_prefs);
    }

    _initialized = true;
    notifyListeners();
  }

  Account _accountFromProfile(Map<String, dynamic> profile) {
    return Account(
      username: (profile['username'] ?? '') as String,
      email: (profile['email'] ?? '') as String,
      passwordHash: '',
      salt: '',
      isFamilyAccount: (profile['isFamilyAccount'] ?? false) as bool,
    );
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
    final normalizedUsername = _userProfileService.normalizeUsername(username);

    if (_accounts.any((a) => a.username.trim().toLowerCase() == normalizedUsername)) {
      return 'Bu kullanıcı adı zaten kullanımda.';
    }

    if (_accounts.any((a) => a.email.trim().toLowerCase() == email.trim().toLowerCase())) {
      return 'Bu e-posta zaten kullanımda.';
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
      } on UsernameTakenException {
        try {
          await firebaseUser.delete();
        } catch (_) {}
        return 'Bu kullanıcı adı zaten kullanımda.';
      } catch (_) {
        try {
          await firebaseUser.delete();
        } catch (_) {}
        return 'Profil verisi kaydedilemedi. Lütfen tekrar deneyin.';
      }

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

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    try {
      final resolvedEmail =
      await _userProfileService.resolveEmailForLogin(username);

      if (resolvedEmail == null) {
        return 'Kullanıcı adı veya e-posta hatalı.';
      }

      final credential = await _firebaseAuthService.login(
        email: resolvedEmail,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        return 'Giriş yapılamadı.';
      }

      final profile = await _userProfileService.getUserProfile(firebaseUser.uid);
      if (profile == null) {
        return 'Kullanıcı profili bulunamadı.';
      }

      final profileUsername = (profile['username'] ?? '').toString();
      final profileEmail = (profile['email'] ?? '').toString();

      if (profileUsername.isNotEmpty && profileEmail.isNotEmpty) {
        await _userProfileService.ensureUsernameMapping(
          uid: firebaseUser.uid,
          username: profileUsername,
          email: profileEmail,
        );
      }

      _current = _accountFromProfile(profile);
      await _authService.persistSession(_prefs, _current!.username);

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Kullanıcı adı/e-posta veya şifre hatalı.';
        case 'invalid-email':
          return 'Geçerli bir e-posta adresi girin.';
        default:
          return e.message ?? 'Giriş sırasında hata oluştu.';
      }
    } catch (_) {
      return 'Giriş sırasında beklenmeyen bir hata oluştu.';
    }
  }

  Future<void> logout() async {
    _current = null;
    _weather = null;
    _weatherError = null;

    await _firebaseAuthService.logout();
    await _authService.clearSession(_prefs);

    notifyListeners();
  }
}