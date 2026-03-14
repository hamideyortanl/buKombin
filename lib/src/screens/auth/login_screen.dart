import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'register_screen.dart';
import '../home/root_shell.dart';

import 'widgets/auth_header_back.dart';
import 'widgets/login/login_form.dart';

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

    if (key.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Lütfen tüm alanları doldurun.');
      return;
    }

    final err = await state.login(username: key, password: pass);

    if (err != null && mounted) {
      setState(() => _error = err);
      return;
    }

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootShell()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                                const SnackBar(
                                  content: Text('Şifre sıfırlama ekranı daha sonra eklenecek.'),
                                ),
                              ),
                              onLogin: _login,
                              onGoogle: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Google ile giriş henüz aktif değil')),
                              ),
                              onFacebook: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Facebook ile giriş henüz aktif değil')),
                              ),
                              onGoRegister: () => Navigator.of(context).pushReplacement(
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