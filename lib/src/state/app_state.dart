import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account.dart';
import '../models/weather_model.dart';
import '../services/auth_service.dart';
import '../services/weather_service.dart';
import '../utils/password_hasher.dart';

class AppState extends ChangeNotifier {
  // Servisler (İşçiler)
  final AuthService _authService = AuthService();
  final WeatherService _weatherService = WeatherService();

  late SharedPreferences _prefs;

  // State Verileri (Hafıza)
  final List<Account> _accounts = [];
  Account? _current;

  // Hava Durumu Verileri
  WeatherModel? _weather;
  bool _isWeatherLoading = false;
  String? _weatherError;

  bool _initialized = false;

  // Getter'lar (Dışarıya bilgi verme)
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _current != null;
  Account? get current => _current;

  WeatherModel? get weather => _weather;
  bool get isWeatherLoading => _isWeatherLoading;
  String? get weatherError => _weatherError;

  // Uygulama açılışında çalışır
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // AuthService'den hesapları yükle
    final loadedAccounts = await _authService.loadAccounts(_prefs);
    _accounts.addAll(loadedAccounts);

    // Oturum kontrolü
    _restoreSession();

    _initialized = true;
    notifyListeners();
  }

  void _restoreSession() {
    final username = _authService.getSessionUser(_prefs);
    if (username != null) {
      // Güvenli geri yükleme: hesap bulunamazsa oturum temizlenir.
      final match = _accounts.where((a) => a.username == username).toList();
      if (match.isEmpty) {
        _authService.clearSession(_prefs);
        _current = null;
      } else {
        _current = match.first;
      }
      // Kullanıcı giriş yaptıysa, hemen hava durumunu da çekelim mi?
      // İstersen burada fetchWeather('Istanbul') diyebilirsin.
    }
  }

  // --- HAVA DURUMU İŞLEMLERİ ---

  Future<void> fetchWeather(String cityName) async {
    _isWeatherLoading = true;
    _weatherError = null;
    notifyListeners();

    try {
      // WeatherService işi yapıyor
      _weather = await _weatherService.getWeather(cityName);
    } catch (e) {
      _weatherError = e.toString();
    } finally {
      _isWeatherLoading = false;
      notifyListeners();
    }
  }

  // --- KULLANICI İŞLEMLERİ ---

  Future<String?> register({
    required String username,
    required String email,
    required String password,
    required bool isFamilyAccount,
  }) async {
    // Basit validasyonlar
    if (_accounts.any((a) => a.username == username)) return 'Kullanıcı adı dolu.';
    if (_accounts.any((a) => a.email == email)) return 'E-posta dolu.';

    final newAccount = Account(
        username: username,
        email: email,
        salt: PasswordHasher.generateSalt(),
        passwordHash: '',
        isFamilyAccount: isFamilyAccount
    );

    // Şifreyi düz metin saklamıyoruz: salt + sha256.
    final hashed = PasswordHasher.hash(password, newAccount.salt);
    final secureAccount = Account(
      username: newAccount.username,
      email: newAccount.email,
      salt: newAccount.salt,
      passwordHash: hashed,
      isFamilyAccount: newAccount.isFamilyAccount,
    );

    // AuthService işi yapıyor
    await _authService.saveAccount(_prefs, _accounts, secureAccount);

    // Otomatik giriş yap
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

      // Eski hesaplarda salt boş olabilir (eski format). Bu durumda giriş güvenli değil;
      // kullanıcıdan yeniden kayıt olması istenebilir. Şimdilik: salt yoksa giriş başarısız.
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
    _weather = null; // Çıkış yapınca hava durumu da sıfırlansın
    await _authService.clearSession(_prefs);
    notifyListeners();
  }
}