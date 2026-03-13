import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }) async {
    if (_accounts.any((a) => a.username == username)) return 'Kullanıcı adı dolu.';
    if (_accounts.any((a) => a.email == email)) return 'E-posta dolu.';

    final newAccount = Account(
      username: username,
      email: email,
      salt: PasswordHasher.generateSalt(),
      passwordHash: '',
      isFamilyAccount: isFamilyAccount,
    );

    final hashed = PasswordHasher.hash(password, newAccount.salt);
    final secureAccount = Account(
      username: newAccount.username,
      email: newAccount.email,
      salt: newAccount.salt,
      passwordHash: hashed,
      isFamilyAccount: newAccount.isFamilyAccount,
    );

    await _authService.saveAccount(_prefs, _accounts, secureAccount);

    _current = secureAccount;
    await _authService.persistSession(_prefs, username);
    notifyListeners();
    return null;
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