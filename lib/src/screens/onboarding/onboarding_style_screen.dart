import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'onboarding_avatar_screen.dart';

import 'widgets/style/onboarding_style_background.dart';
import 'widgets/style/onboarding_style_footer.dart';
import 'widgets/style/onboarding_style_header.dart';
import 'widgets/style/onboarding_style_palette_row.dart';
import 'widgets/style/onboarding_style_responsive_grid.dart';
import 'widgets/style/onboarding_style_section_text.dart';
import 'widgets/style/onboarding_style_select_card.dart';

import 'widgets/style/onboarding_icon_assets.dart';

class OnboardingStyleScreen extends StatefulWidget {
  final String? gender; // 'female' | 'male'
  final String? femaleMode;  // null | open | closed (sadece female)
  const OnboardingStyleScreen({
    super.key,
    this.gender,
    this.femaleMode,
  });

  @override
  State<OnboardingStyleScreen> createState() => _OnboardingStyleScreenState();
}

class _OnboardingStyleScreenState extends State<OnboardingStyleScreen> {
  final Set<String> _styles = {};
  final Set<String> _events = {};
  final Set<int> _selectedPalettes = {};
  String? _error;

  static final List<String> _styleOptions = [
    'Klasik',
    'Sokak',
    'Minimal',
    'Bohem',
    'Spor Şık',
    'Vintage',
    'Ofis',
    'Elegant',
    'Günlük',
  ];

  static final List<String> _eventOptions = [
    'İş',
    'Okul',
    'Düğün',
    'Kahve',
    'Spor',
    'Seyahat',
    'Parti',
    'Günlük',
    'Özel Davet',
  ];

  static final List<List<Color>> _palettes = [
    [const Color(0xFF3E2723), const Color(0xFFE8DDD5), const Color(0xFFB4A193)],
    [const Color(0xFF4A3428), const Color(0xFFD4C5B9), const Color(0xFF8B8680)],
    [const Color(0xFF5C4033), const Color(0xFFC9B8A8), const Color(0xFF6B675F)],
    [const Color(0xFF0F172A), const Color(0xFFE5E7EB), const Color(0xFF94A3B8)],
    [const Color(0xFF111827), const Color(0xFFF5F5F4), const Color(0xFFB45309)],
    [const Color(0xFF1F2937), const Color(0xFFFAF7F2), const Color(0xFFCA8A04)],
    [const Color(0xFF0B1320), const Color(0xFFD6E4FF), const Color(0xFF3B82F6)],
    [const Color(0xFF1B4332), const Color(0xFFD8F3DC), const Color(0xFF2D6A4F)],
    [const Color(0xFF2C2A4A), const Color(0xFFF2E9E4), const Color(0xFF9A8C98)],
    [const Color(0xFF22223B), const Color(0xFFF2E9E4), const Color(0xFF4A4E69)],
    [const Color(0xFF3D405B), const Color(0xFFF4F1DE), const Color(0xFFE07A5F)],
    [const Color(0xFF283618), const Color(0xFFFEFAE0), const Color(0xFFDDA15E)],
    [const Color(0xFF2F3E46), const Color(0xFFCAD2C5), const Color(0xFF84A98C)],
    [const Color(0xFF432818), const Color(0xFFFFEDD8), const Color(0xFF99582A)],
    [const Color(0xFF1D3557), const Color(0xFFF1FAEE), const Color(0xFFE63946)],
    [const Color(0xFF2D3047), const Color(0xFFE5E5E5), const Color(0xFF419D78)],
    [const Color(0xFF0B3C5D), const Color(0xFFD9B310), const Color(0xFF328CC1)],
    [const Color(0xFF4C1D95), const Color(0xFFF3E8FF), const Color(0xFF7C3AED)],
    [const Color(0xFF7F1D1D), const Color(0xFFFFF1F2), const Color(0xFFBE123C)],
    [const Color(0xFF064E3B), const Color(0xFFECFDF5), const Color(0xFF10B981)],
    [const Color(0xFF0A9396), const Color(0xFFE9D8A6), const Color(0xFF005F73)],
    [const Color(0xFF001219), const Color(0xFFFFE3C4), const Color(0xFFEE9B00)],
    [const Color(0xFF3A0CA3), const Color(0xFFFDE2E4), const Color(0xFF7209B7)],
    [const Color(0xFF2B2D42), const Color(0xFFEDF2F4), const Color(0xFFEF233C)],
    [const Color(0xFF14213D), const Color(0xFFE5E5E5), const Color(0xFFFCA311)],
    [const Color(0xFF2A9D8F), const Color(0xFFF4A261), const Color(0xFFE76F51)],
    [const Color(0xFF0F766E), const Color(0xFFCCFBF1), const Color(0xFF134E4A)],
    [const Color(0xFF374151), const Color(0xFFF9FAFB), const Color(0xFF9CA3AF)],
    [const Color(0xFF3F3D56), const Color(0xFFF8FAFC), const Color(0xFF60A5FA)],
    [const Color(0xFF3B2F2F), const Color(0xFFF2E8CF), const Color(0xFF6F1D1B)],
    [const Color(0xFF222222), const Color(0xFFF7F7F7), const Color(0xFFB08968)],
  ];

  static const _bg1 = Color(0xFFE8DDD5);
  static const _bg2 = Color(0xFFD4C5B9);
  static const _bg3 = Color(0xFFC9B8A8);

  static const _textMuted = Color(0xFF6B675F);

  bool get _canContinue =>
      _styles.isNotEmpty && _events.isNotEmpty && _selectedPalettes.isNotEmpty;

  void _toggle(Set<String> set, String value) {
    setState(() {
      if (set.contains(value)) {
        set.remove(value);
      } else {
        set.add(value);
      }
    });
  }

  void _togglePalette(int idx) {
    setState(() {
      if (_selectedPalettes.contains(idx)) {
        _selectedPalettes.remove(idx);
      } else {
        _selectedPalettes.add(idx);
      }
    });
  }

  void _next() {
    setState(() => _error = null);

    if (!_canContinue) {
      setState(() => _error = 'Lütfen her bölümden en az bir tane seçiniz.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingAvatarScreen(
          gender: widget.gender,
          femaleMode: widget.femaleMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = context.watch<AppState>().current;
    final gender = widget.gender ?? 'female';

    return Scaffold(
      body: Container(
        decoration: buKombinBackgroundDecoration(context),
        child: Stack(
          children: [
            const OnboardingStyleBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OnboardingStyleHeader(
                              title: 'Tarzınızı Keşfedin',
                              stepText: '1/3',
                              progress: 1 / 3,
                              onBack: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(height: 14),

                            if (current != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '@${current.username}',
                                  style: const TextStyle(color: _textMuted),
                                ),
                              ),

                            if (_error != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(_error!,
                                    style: const TextStyle(color: Colors.red)),
                              ),

                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.only(bottom: 140),
                                children: [
                                  const SizedBox(height: 6),
                                  const OnboardingSectionTitle(title: 'Stil Tercihleriniz'),
                                  const OnboardingSectionSub(
                                    text:
                                    'En az bir stil seçin (birden fazla seçebilirsiniz)',
                                  ),
                                  const SizedBox(height: 12),

                                  LayoutBuilder(
                                    builder: (context, c) {
                                      return GridView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _styleOptions.length,
                                        gridDelegate: OnboardingResponsiveGrid.delegateForWidth(c.maxWidth),
                                        itemBuilder: (context, i) {
                                          final label = _styleOptions[i];
                                          final selected = _styles.contains(label);

                                          final isHijab = (gender != 'male') && (widget.femaleMode == 'closed');

                                          final asset = OnboardingIconAssets.styleAssetPath(
                                            label: label,
                                            gender: gender,
                                            hijab: isHijab,
                                          );

                                          final emoji = OnboardingIconAssets.emojiForStyle(label, gender);

                                          return OnboardingSelectCard(
                                            emoji: emoji,
                                            label: label,
                                            selected: selected,
                                            onTap: () => _toggle(_styles, label),
                                            assetPath: asset,
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 26),

                                  const OnboardingSectionTitle(title: 'Etkinlik Türleri'),
                                  const OnboardingSectionSub(
                                    text:
                                    'En az bir etkinlik seçin (birden fazla seçebilirsiniz)',
                                  ),
                                  const SizedBox(height: 12),

                                  LayoutBuilder(
                                    builder: (context, c) {
                                      return GridView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _eventOptions.length,
                                        gridDelegate: OnboardingResponsiveGrid.delegateForWidth(c.maxWidth),
                                        itemBuilder: (context, i) {
                                          final label = _eventOptions[i];
                                          final selected = _events.contains(label);

                                          final asset = OnboardingIconAssets.activityAssetPath(
                                            label: label,
                                          );

                                          final emoji = OnboardingIconAssets.emojiForEvent(label, gender);

                                          return OnboardingSelectCard(
                                            emoji: emoji,
                                            label: label,
                                            selected: selected,
                                            onTap: () => _toggle(_events, label),
                                            assetPath: asset, // ✅ EVENT GÖRSELLERİ EKLENDİ
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 26),

                                  const OnboardingSectionTitle(title: 'Renk Tercihleri'),
                                  const OnboardingSectionSub(
                                      text: 'Tercih ettiğiniz renk paletlerini seçin'),
                                  const SizedBox(height: 12),

                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _palettes.length,
                                    separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                    itemBuilder: (context, idx) {
                                      final selected =
                                      _selectedPalettes.contains(idx);
                                      final colors = _palettes[idx];

                                      return OnboardingPaletteRow(
                                        label: 'Palet ${idx + 1}',
                                        colors: colors,
                                        selected: selected,
                                        onTap: () => _togglePalette(idx),
                                        // NOT: bubbleSize param senden gelen widget dosyana bağlı.
                                        // Eğer hata verirse bunu kaldıracağız ya da widget'a ekleyeceğiz.
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: OnboardingStyleFooter(
                            enabled: _canContinue,
                            onTap: _next,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
