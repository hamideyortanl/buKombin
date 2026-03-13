import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class ProfileFamilyScreen extends StatelessWidget {
  const ProfileFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isFamily = state.current?.isFamilyAccount == true;

    return Scaffold(
      appBar: AppBar(title: const Text('Aile')),
      body: Container(
        decoration: buKombinBackgroundDecoration(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Ortak Dolap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('Aile üyeleriyle ortak giysi yönetimi (v2 içerik, v6 stil).'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!isFamily)
                  const Text(
                    'Bu hesap aile hesabı değil. Aile özellikleri kısıtlı görünüyor.',
                    style: TextStyle(color: BuKombinColors.stone),
                  )
                else ...[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.group_outlined),
                      title: const Text('Aile Üyeleri'),
                      subtitle: const Text('Üyeleri görüntüle ve yönet'),
                      onTap: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Aile üyeleri yönetimi (demo)'))),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.checkroom_outlined),
                      title: const Text('Ortak Giysiler'),
                      subtitle: const Text('Paylaşılan parçalar'),
                      onTap: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Ortak giysiler (demo)'))),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
