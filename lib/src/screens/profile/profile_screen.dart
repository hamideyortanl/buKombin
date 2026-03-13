import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bukombin_top_header.dart';
import '../auth/welcome_screen.dart';
import 'profile_analysis_screen.dart';
import 'profile_environment_screen.dart';
import 'profile_family_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.current;

    return Scaffold(
      body: Container(
        decoration: buKombinBackgroundDecoration(context),
        child: Column(
          children: [
            // ✅ Profil sayfasında da diğer sayfalardakiyle aynı üst kahverengi alan
            BuKombinTopHeader(
              title: 'Profil',
              // İstenen: kahverengi alan biraz daha geniş + kullanıcı adı vb. burada görünsün.
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
              content: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.20)),
                    ),
                    child: const Icon(Icons.person, color: BuKombinColors.beige1),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.username ?? 'Misafir',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: BuKombinColors.beige1,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Hesap & Ayarlar',
                          style: TextStyle(
                            color: BuKombinColors.beige1,
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _menuTile(
                    context,
                    icon: Icons.insights_outlined,
                    title: 'Analiz',
                    subtitle: 'Stil ve dolap istatistikleri',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileAnalysisScreen()),
                    ),
                  ),
                  _menuTile(
                    context,
                    icon: Icons.public_outlined,
                    title: 'Çevre',
                    subtitle: 'Sürdürülebilirlik ve etki',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileEnvironmentScreen()),
                    ),
                  ),
                  _menuTile(
                    context,
                    icon: Icons.family_restroom_outlined,
                    title: 'Aile',
                    subtitle: 'Ortak dolap ve üyeler',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileFamilyScreen()),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _sectionTitle('Hesap'),
                  const SizedBox(height: 10),
                  _menuTile(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Ayarlar',
                    subtitle: 'Bildirimler, gizlilik (demo)',
                    onTap: () => _snack(context, 'Ayarlar (demo)'),
                  ),
                  _menuTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Yardım',
                    subtitle: 'SSS ve destek (demo)',
                    onTap: () => _snack(context, 'Yardım (demo)'),
                  ),
                  _menuTile(
                    context,
                    icon: Icons.logout,
                    title: 'Çıkış Yap',
                    subtitle: 'Welcome sayfasına dön',
                    onTap: () async {
                      await context.read<AppState>().logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                        (r) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        color: BuKombinColors.brown3,
        fontSize: 16,
      ),
    );
  }

  static Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BuKombinColors.accent.withOpacity(0.30)),
          ),
          child: ListTile(
            leading: Icon(icon, color: BuKombinColors.brown2),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  static void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
