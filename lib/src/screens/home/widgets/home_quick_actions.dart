import 'package:flutter/material.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hızlı İşlemler', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            // ✅ Wrap zaten küçük ekranda alt alta düşürür, overflow yapmaz.
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _pill(context, Icons.camera_alt_outlined, 'Kıyafet Ekle'),
                _pill(context, Icons.palette_outlined, 'Kombin Oluştur'),
                _pill(context, Icons.auto_fix_high, 'Stil Analizi'),
                _pill(context, Icons.eco_outlined, 'Çevre'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _pill(BuildContext context, IconData icon, String text) {
    return OutlinedButton.icon(
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$text (demo)')),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
