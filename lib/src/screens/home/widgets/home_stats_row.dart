import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class HomeStatsRow extends StatelessWidget {
  const HomeStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Çok dar ekranda Row sıkıştırır, Expanded ile taşmaz.
    return Row(
      children: const [
        Expanded(child: _StatCard(title: 'Dolap', value: '128', icon: Icons.checkroom_outlined)),
        SizedBox(width: 12),
        Expanded(child: _StatCard(title: 'Favori', value: '22', icon: Icons.favorite_border)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: BuKombinColors.brown2),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: BuKombinColors.stone),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
