import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../theme/app_theme.dart';
import 'models/outfit.dart';
import 'widgets/header.dart';
import 'widgets/category_tabs.dart';
import 'widgets/outfit_card.dart';
import 'widgets/create_outfit_cta.dart';
import 'widgets/glass_card.dart';
import 'widgets/missing_piece_analysis_card.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  static const categories = ['Tümü', 'AI Önerileri', 'Favoriler', 'Son Oluşturulanlar'];

  static const bg1 = Color(0xFFE8DDD5);
  static const bg2 = Color(0xFFD4C5B9);
  static const bg3 = Color(0xFFC9B8A8);

  static const textMuted = Color(0xFF6B675F);
  static const textDark = Color(0xFF3E2723);
  static const muted2 = Color(0xFF8B8680);

  // demo outfits
  final List<Outfit> _outfits = const [
    Outfit(
      id: 1,
      name: 'Zarif İş Kombini',
      imageUrl:
      'https://images.unsplash.com/photo-1633821879282-0c4e91f96232?auto=format&fit=crop&w=900&q=80',
      items: 4,
      isAI: true,
      isFavorite: true,
      date: '2 gün önce',
    ),
    Outfit(
      id: 2,
      name: 'Rahat Hafta Sonu',
      imageUrl:
      'https://images.unsplash.com/photo-1589270216117-7972b3082c7d?auto=format&fit=crop&w=900&q=80',
      items: 3,
      isAI: false,
      isFavorite: false,
      date: '1 hafta önce',
    ),
    Outfit(
      id: 3,
      name: 'Akşam Yemeği',
      imageUrl:
      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=900&q=80',
      items: 5,
      isAI: true,
      isFavorite: true,
      date: '3 gün önce',
    ),
    Outfit(
      id: 4,
      name: 'Spor Chic',
      imageUrl:
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80',
      items: 3,
      isAI: false,
      isFavorite: false,
      date: '5 gün önce',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
    _tab.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<Outfit> _filteredForIndex(int index) {
    final list = _outfits.toList();
    if (index == 1) return list.where((o) => o.isAI).toList();
    if (index == 2) return list.where((o) => o.isFavorite).toList();
    if (index == 3) return list; // "Son Oluşturulanlar" demo
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ FAB kaldırıldı: sağ alttaki yeni kombin butonu yok
      // Ortak tema: tüm sayfalarda arka plan beyaz.
      body: SafeArea(
        child: Column(
          children: [

              OutfitsHeader(
                onCalendarTap: () => _tab.animateTo(4),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: CategoryTabs(
                  controller: _tab,
                  categories: categories,
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tab,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _gridTab(context, 0),
                    _gridTab(context, 1),
                    _gridTab(context, 2),
                    _gridTab(context, 3),
                    _calendarTab(context),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _gridTab(BuildContext context, int index) {
    final filtered = _filteredForIndex(index);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Text('${filtered.length} kombin bulundu', style: const TextStyle(color: textMuted)),
        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (_, i) => OutfitCard(
            outfit: filtered[i],
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${filtered[i].name} (demo)'))),
            onToggleFav: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Favori (demo)'))),
            onShare: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Paylaş (demo)'))),
          ),
        ),

        const SizedBox(height: 18),

        CreateOutfitCta(
          onTap: () => _showCreate(context),
        ),

        const SizedBox(height: 18),

        const MissingPieceAnalysisCard(),
      ],
    );
  }

  Widget _calendarTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        GlassCard(
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(color: BuKombinColors.brown2, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                color: BuKombinColors.brown2.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Planlanan Kombinler',
                  style: TextStyle(fontWeight: FontWeight.w700, color: textDark)),
              const SizedBox(height: 8),
              ...List.generate(
                3,
                    (i) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: BuKombinColors.accent.withOpacity(0.25),
                    child: const Icon(Icons.event, color: BuKombinColors.brown2),
                  ),
                  title: Text('Gün ${i + 1}: Bej ceket + kahve elbise', style: const TextStyle(color: textDark)),
                  subtitle: const Text('Akşam davet', style: TextStyle(color: textMuted)),
                  trailing: const Icon(Icons.chevron_right, color: muted2),
                  onTap: () => ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Plan detay (demo)'))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCreate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Yeni Kombin Oluştur', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            const Text('Bu ekran demo. İstersen burada seçimler ekleyebiliriz.'),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      ),
    );
  }
}
