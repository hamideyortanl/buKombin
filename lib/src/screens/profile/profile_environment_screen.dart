import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ProfileEnvironmentScreen extends StatelessWidget {
  const ProfileEnvironmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Çevre')),
      body: Container(
        decoration: buKombinBackgroundDecoration(context),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _MetricCard(title: 'Karbon Ayak İzi', value: '2.8 kg CO₂/hafta', subtitle: 'Son 7 gün tahmini'),
            _MetricCard(title: 'Yeniden Kullanım', value: '%34', subtitle: 'Dolabındaki parçaların yeniden kombinlenme oranı'),
            _MetricCard(title: 'Akıllı Bakım', value: '3 öneri', subtitle: 'Yıkama, havalandırma ve saklama hatırlatmaları'),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _MetricCard({required this.title, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: BuKombinColors.brown2)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: BuKombinColors.stone)),
          ],
        ),
      ),
    );
  }
}
