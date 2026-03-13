import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class HomeAiSuggestionCard extends StatelessWidget {
  const HomeAiSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: BuKombinColors.brown2),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Bugün için AI Kombin Önerisi',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI öneri (demo)')),
              ),
              child: const Text('Göster'),
            ),
          ],
        ),
      ),
    );
  }
}
