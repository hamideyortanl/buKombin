import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'register_screen.dart';
import '../home/root_shell.dart';

import 'widgets/auth_header_back.dart';
import 'widgets/login/login_form.dart';
import '../../utils/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _showPass = false;
  String? _error;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final state = context.read<AppState>();
    setState(() => _error = null);

    final key = _userController.text.trim();
    final pass = _passController.text;

    // --- GÜVENLİK DUVARI 1: Boşluk Kontrolü ---
    if (key.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Lütfen tüm alanları doldurun.');
      return;
    }

    // --- GÜVENLİK DUVARI 2: Gelişmiş E-posta/Kullanıcı Adı Kontrolü ---
    if (key.contains('@')) {
      // E-posta formatı kontrolü (Basit ama etkili Regex)
      final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (!emailRegex.hasMatch(key)) {
        setState(() => _error = 'Lütfen geçerli bir e-posta adresi girin.');
        return;
      }
    } else {
      // Kullanıcı adı kontrolü (Sadece harf ve rakam, sembol yok)
      if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(key)) {
        setState(() => _error = 'Geçersiz kullanıcı adı formatı.');
        return;
      }
    }

    // --- GÜVENLİ İLETİŞİM ---
    // Şifre ASLA print edilmez, doğrudan AppState'e (oradan da Backend'e) gönderilir.
    final err = await state.login(username: key, password: pass);

    if (err != null && mounted) {
      setState(() => _error = err);
      return;
    }

    // Başarılıysa yönlendir
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootShell()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = 480.0;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const AuthHeaderBack(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: LoginForm(
                              userController: _userController,
                              passController: _passController,
                              showPass: _showPass,
                              errorText: _error,
                              onTogglePass: () => setState(() => _showPass = !_showPass),
                              onForgotPass: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Şifre sıfırlama ekranına gidiliyor...')),
                              ),
                              onLogin: _login,
                              onGoogle: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Google ile giriş tetiklendi')),
                              ),
                              onFacebook: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Facebook ile giriş tetiklendi')),
                              ),
                              onGoRegister: () => Navigator.of(context).pushReplacement( // Geri dönüş yığınını temiz tutmak için pushReplacement
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}