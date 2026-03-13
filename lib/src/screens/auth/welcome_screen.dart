import 'package:flutter/material.dart';
import '../../widgets/icons/outfit_line_icon.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'widgets/welcome/welcome_buttons.dart';
import 'widgets/welcome/welcome_logo_card.dart';
import 'widgets/welcome/welcome_progress.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF3E2723);
    const textMuted = Color(0xFF6B675F);

    return Scaffold(      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    // Padding'i %8 gibi esnek bir değere çektik ki dar ekranlarda yer kalsın
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.08,
                    ),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // Orijinal Kahverengi Çerçeveli İkon
                        // ✅ Welcome ekranındaki logo/ikon: projedeki orijinal hali
                        // (renk/çizim burada değiştirilmez)
                        const WelcomeLogoCard(
                          icon: OutfitLineIcon(size: 80),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'buKombin',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Kombinlerinizi profesyonelce yönetin,\ntarzınızı her gün yeniden keşfedin.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Butonlar - Taşmayı önleyen esnek yapı
                        // Artık sabit bir minimum genişlik (280 gibi) yok, ekrana göre daralıyor
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 340),
                          child: WelcomeButtons(
                            onLogin: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            ),
                            onRegister: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        const WelcomeProgressDots(activeIndex: 0),

                        const SizedBox(height: 24),

                        const Text(
                          'ZARİF • ŞIK • MODERN',
                          style: TextStyle(
                            color: textMuted,
                            letterSpacing: 2.5,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
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