import 'package:flutter/material.dart';
//Flutter framework'ünün ilgili sınıflarını import etme, MaterialApp, StatelessWidget, BuildContext buradan gelir
import 'package:provider/provider.dart';
// State management için provider paketi
import '../state/app_state.dart';
import '../theme/app_theme.dart';
// import '../screens/common/video_splash_screen.dart'; // Artık buna gerek yok
import '../screens/auth/welcome_screen.dart';
import '../screens/home/root_shell.dart';

class BuKombinApp extends StatelessWidget {
  const BuKombinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'buKombin',
      debugShowCheckedModeBanner: false,
      theme: BuKombinTheme.light(),
      // Home artık daha akıllı bir router yapısına emanet
      home: const _BootRouter(),
    );
  }
}

class _BootRouter extends StatelessWidget {
  const _BootRouter();

  @override
  Widget build(BuildContext context) {
    // 🚀 OPTİMİZASYON YAPILDI:
    // context.watch yerine context.select kullanıldı.
    // Artık AppState içinde 100 tane veri değişse bile,
    // "isLoggedIn" değişmediği sürece bu sayfa yeniden çizilmez (rebuild olmaz).
    // Bu, büyük projelerde performans için hayati önem taşır.

    final isLoggedIn = context.select<AppState, bool>((state) => state.isLoggedIn);

    if (isLoggedIn) {
      return const RootShell();
    } else {
      return const WelcomeScreen();
    }
  }
}