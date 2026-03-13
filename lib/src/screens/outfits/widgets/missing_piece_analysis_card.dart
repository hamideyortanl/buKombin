import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class MissingPieceAnalysisCard extends StatelessWidget {
  const MissingPieceAnalysisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Eksik Parça Analizi', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text(
              'Dolabında "bej ceket" ile uyumlu "açık ton pantolon" az görünüyor. Bir adet eklemek kombin çeşitliliğini artırır.',
              style: TextStyle(color: BuKombinColors.stone),
            ),
          ],
        ),
      ),
    );
  }
}
