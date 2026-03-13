import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../onboarding/onboarding_style_screen.dart';
import 'widgets/register/register_form.dart';
import 'widgets/auth_header_back.dart'; // Geri butonu için (varsa)
import '../../utils/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameC = TextEditingController();
  final _usernameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _pass2C = TextEditingController();

  bool _showPass = false;
  bool _isFamily = false;
  bool _accept = false;
  String? _error;

  String? _gender; // null | 'female' | 'male'
  String? _femaleMode; // null | 'open' | 'closed'

  @override
  void dispose() {
    _fullNameC.dispose();
    _usernameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    _pass2C.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);

    final u = _usernameC.text.trim();
    final e = _emailC.text.trim();
    final p = _passC.text;
    final p2 = _pass2C.text;

    if (u.isEmpty || e.isEmpty || p.isEmpty) {
      setState(() => _error = 'Lütfen tüm alanları doldurun.');
      return;
    }
    if (p != p2) {
      setState(() => _error = 'Şifreler uyuşmuyor.');
      return;
    }
    if (!_accept) {
      setState(() => _error = 'Kullanım şartlarını kabul etmelisiniz.');
      return;
    }
    if (_gender == null) {
      setState(() => _error = 'Lütfen cinsiyet seçiniz.');
      return;
    }
    if (_gender == 'female' && _femaleMode == null) {
      setState(() => _error = 'Lütfen giyim tarzınızı belirtiniz.');
      return;
    }

    final state = context.read<AppState>();

    // YENİ APPSTATE YAPISINA UYGUN ÇAĞRI
    final err = await state.register(
      username: u,
      email: e,
      password: p,
      isFamilyAccount: _isFamily,
      fullName: _fullNameC.text.trim().isEmpty ? null : _fullNameC.text.trim(),
      gender: _gender,
      femaleMode: _femaleMode,
    );

    if (!mounted) return;

    if (err != null) {
      setState(() => _error = err);
      return;
    }

    // Başarılı Kayıt! Onboarding'e (Tarz Seçimi) geçiyoruz
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OnboardingStyleScreen(
          gender: _gender!,
          femaleMode: _femaleMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Eğer özel bir başlık veya geri butonu varsa (Login'deki gibi)
                      const AuthHeaderBack(),
                      const SizedBox(height: 16),

                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: RegisterForm(
                            fullNameC: _fullNameC,
                            usernameC: _usernameC,
                            emailC: _emailC,
                            passC: _passC,
                            pass2C: _pass2C,
                            showPass: _showPass,
                            onToggleShowPass: () => setState(() => _showPass = !_showPass),
                            isFamily: _isFamily,
                            onFamilyChanged: (v) => setState(() => _isFamily = v),
                            accept: _accept,
                            onAcceptChanged: (v) => setState(() => _accept = v),
                            gender: _gender,
                            onGenderChanged: (v) {
                              setState(() {
                                _gender = v;
                                if (_gender != 'female') _femaleMode = null;
                              });
                            },
                            femaleMode: _femaleMode,
                            onFemaleModeChanged: (v) => setState(() => _femaleMode = v),
                            errorText: _error,
                            onSubmit: _submit,
                          ),
                        ),
                      ),
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