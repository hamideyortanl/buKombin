import 'package:flutter/material.dart';

class WelcomeButtons extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const WelcomeButtons({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PrimaryButton(text: 'Giriş Yap', onTap: onLogin),
        const SizedBox(height: 16),
        _SecondaryButton(text: 'Hesap Oluştur', onTap: onRegister),
      ],
    );
  }
}

// 🌟 Ana Buton (Koyu/Premium)
class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A3428),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// 🌟 İkinci Buton (Açık/Minimal)
class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _SecondaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFB4A193), width: 1.5),
          foregroundColor: const Color(0xFF4A3428),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: const Color(0xFFB4A193).withOpacity(0.05), // Çok hafif dolgu
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}