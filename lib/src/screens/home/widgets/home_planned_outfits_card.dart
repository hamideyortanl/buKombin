import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_theme.dart';

class HomePlannedOutfitsCard extends StatelessWidget {
  const HomePlannedOutfitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM, EEE', 'tr_TR');
    final items = List<DateTime>.generate(3, (i) => DateTime.now().add(Duration(days: i + 1)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.event_note, color: BuKombinColors.brown2),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Planlanan Kombinler',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // ✅ right overflow fix
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...items.map(
                  (d) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  fmt.format(d),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'AI önerisi hazır (demo)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: BuKombinColors.stone),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Plan detayı (demo)')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
