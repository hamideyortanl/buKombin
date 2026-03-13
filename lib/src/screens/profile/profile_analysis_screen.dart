import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ProfileAnalysisScreen extends StatelessWidget {
  const ProfileAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analiz')),
      body: Container(
        decoration: buKombinBackgroundDecoration(context),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _StatCard(title: 'En Çok Giyilen', value: 'Krem Blazer'),
            _StatCard(title: 'Haftalık Kombin', value: '6'),
            _StatCard(title: 'Dolap Doluluğu', value: '%72'),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(color: BuKombinColors.stone)),
            ),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
