import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _bg1 = Color(0xFFE8DDD5);
  static const _bg2 = Color(0xFFD4C5B9);
  static const _bg3 = Color(0xFFC9B8A8);

  static const _textDark = Color(0xFF3E2723);
  static const _textBrown = Color(0xFF4A3428);
  static const _textMuted = Color(0xFF6B675F);

  static const _borderSoft = Color(0x66B4A193); // #B4A193/40
  static const _glass = Color(0x99FFFFFF); // white/60-ish

  static const _g1 = Color(0xFF5C4033);
  static const _g2 = Color(0xFF4A3428);
  static const _g3 = Color(0xFF3E2723);

  @override
  Widget build(BuildContext context) {
    final current = context.watch<AppState>().current;

    return Scaffold(
      // Ortak tema: tüm sayfalarda arka plan beyaz.
      body: SafeArea(
        child: Column(
          children: [
            _Header(
                name: current?.username,
                temperature: '24°',
                city: 'İstanbul',
                condition: 'Parçalı Bulutlu',
                high: '26°',
                low: '18°',
                onNotif: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bildirimler (demo)')),
                  );
                },
              ),

              // --- Scroll content ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                children: [
                    // Günün Kombini
                    _SectionHeader(
                      title: 'Günün Kombini',
                      actionText: 'Değiştir',
                      onAction: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kombin değiştir (demo)')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _TodaysOutfitCard(
                      title: 'Kahve Tonlarında Şıklık',
                      subtitle: 'Modern, zarif ve kışa uygun',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Günün kombini açıldı (demo)')),
                        );
                      },
                    ),

                    const SizedBox(height: 22),

                    // Hızlı Bakış
                    const _SectionTitleOnly(title: 'Hızlı Bakış'),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Expanded(
                          child: _QuickStatCard(
                            title: 'Dolabım',
                            value: '128',
                            subtitle: 'Parça',
                            icon: Icons.checkroom,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF5C4033), Color(0xFF4A3428)],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _QuickStatCard(
                            title: 'Kombin',
                            value: '34',
                            subtitle: 'Hazır',
                            icon: Icons.auto_awesome,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8B8680), Color(0xFF6B675F)],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _QuickStatCard(
                            title: 'Favori',
                            value: '12',
                            subtitle: 'Parça',
                            icon: Icons.favorite,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFB4A193), Color(0xFFD4C5B9)],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Sürdürülebilirlik Skoru
                    _SectionHeader(
                      title: 'Sürdürülebilirlik Skoru',
                      actionText: 'Detaylar',
                      onAction: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sürdürülebilirlik detay (demo)')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const _SustainabilityCard(
                      scoreText: '85/100',
                      subtitle: 'Harika! Çevre dostu seçimler yapıyorsunuz.',
                      progress: 0.85,
                    ),

                    const SizedBox(height: 22),

                    // Son Aktiviteler
                    const _SectionTitleOnly(title: 'Son Aktiviteler'),
                    const SizedBox(height: 12),
                    const _ActivityRow(
                      icon: Icons.check_circle,
                      title: 'Yeni kombin oluşturuldu',
                      subtitle: '2 saat önce',
                    ),
                    const SizedBox(height: 10),
                    const _ActivityRow(
                      icon: Icons.add_circle,
                      title: 'Dolaba yeni parça eklendi',
                      subtitle: '1 gün önce',
                    ),
                    const SizedBox(height: 10),
                    const _ActivityRow(
                      icon: Icons.favorite,
                      title: 'Favori parça seçildi',
                      subtitle: '3 gün önce',
                    ),

                    const SizedBox(height: 22),

                    _SectionHeader(
                      title: 'Planlanan Etkinlikler',
                      actionText: 'Tümü',
                      onAction: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Etkinlikler (demo)')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const _PlannedEventCard(
                      title: 'Ofis Toplantısı',
                      date: 'Salı • 10:00',
                      outfit: 'Klasik Ofis Kombini',
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 10),
                    const _PlannedEventCard(
                      title: 'Kahve Buluşması',
                      date: 'Çarşamba • 18:30',
                      outfit: 'Günlük Şık Kombin',
                      icon: Icons.coffee,
                    ),
                    const SizedBox(height: 10),
                    const _PlannedEventCard(
                      title: 'Özel Davet',
                      date: 'Cumartesi • 20:00',
                      outfit: 'Elegant Gece Kombini',
                      icon: Icons.celebration,
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

/* --------------------  UI building blocks -------------------- */

class _Header extends StatelessWidget {
  final String? name;
  final String temperature;
  final String city;
  final String condition;
  final String high;
  final String low;
  final VoidCallback onNotif;

  const _Header({
    required this.name,
    required this.temperature,
    required this.city,
    required this.condition,
    required this.high,
    required this.low,
    required this.onNotif,
  });

  static const _textDark = Color(0xFF3E2723);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3428).withOpacity(0.30),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF5C4033), Color(0xFF4A3428), Color(0xFF3E2723)],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Merhaba${(name != null && name!.isNotEmpty) ? ', $name' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFE8DDD5),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: onNotif,
                icon: const Icon(Icons.notifications_none, color: Color(0xFFE8DDD5)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Weather card (glass, like TSX)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.20)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.wb_sunny, color: Color(0xFFE8DDD5)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$city • $condition',
                            style: TextStyle(color: Colors.white.withOpacity(0.90)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$high / $low',
                            style: TextStyle(color: Colors.white.withOpacity(0.70)),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      temperature,
                      style: const TextStyle(
                        color: Color(0xFFE8DDD5),
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  static const _textBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _textBrown,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: _textBrown,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          child: Text(actionText),
        ),
      ],
    );
  }
}

class _SectionTitleOnly extends StatelessWidget {
  final String title;
  const _SectionTitleOnly({required this.title});

  static const _textBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _textBrown,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  static const _borderSoft = Color(0x66B4A193);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _borderSoft),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TodaysOutfitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TodaysOutfitCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const _textDark = Color(0xFF3E2723);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Placeholder image area (TSX'de gerçek görsel)
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4C5B9).withOpacity(0.60),
                  ),
                  child: const Icon(Icons.image, size: 46, color: Color(0xFF6B675F)),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.60),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.85)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF5C4033), Color(0xFF4A3428), Color(0xFF3E2723)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A3428).withOpacity(0.25),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Detayları Gör',
                    style: TextStyle(
                      color: Color(0xFFE8DDD5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          // ('daki metin/yerleşim korunuyor)
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;

  const _QuickStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3428).withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Color(0xFFE8DDD5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFE8DDD5), size: 20),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              '$title • $subtitle',
              style: TextStyle(color: const Color(0xFFE8DDD5).withOpacity(0.85), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _SustainabilityCard extends StatelessWidget {
  final String scoreText;
  final String subtitle;
  final double progress;

  const _SustainabilityCard({
    required this.scoreText,
    required this.subtitle,
    required this.progress,
  });

  static const _textBrown = Color(0xFF4A3428);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Row(
        children: [
          // badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF86A361), Color(0xFF6B8E4E)],
              ),
            ),
            child: const Icon(Icons.eco, color: Colors.white),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scoreText,
                  style: const TextStyle(
                    color: _textBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: _textMuted, height: 1.3),
                ),
                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 8,
                    color: Colors.white.withOpacity(0.60),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress.clamp(0, 1),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF86A361), Color(0xFF6B8E4E)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const _textBrown = Color(0xFF4A3428);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD4C5B9), Color(0xFFC9B8A8)],
              ),
            ),
            child: Icon(icon, color: _textBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: _textBrown, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: _textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannedEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String outfit;
  final IconData icon;

  const _PlannedEventCard({
    required this.title,
    required this.date,
    required this.outfit,
    required this.icon,
  });

  static const _textBrown = Color(0xFF4A3428);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB4A193), Color(0xFFD4C5B9)],
              ),
            ),
            child: Icon(icon, color: _textBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _textBrown, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: _textMuted)),
                const SizedBox(height: 6),
                Text(
                  outfit,
                  style: TextStyle(color: _textBrown.withOpacity(0.90), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _textMuted),
        ],
      ),
    );
  }
}
