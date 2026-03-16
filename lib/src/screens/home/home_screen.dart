import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/clothing_item.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../wardrobe/care/wardrobe_care_models.dart';
import '../wardrobe/services/wardrobe_service.dart';
import 'models/home_activity_item.dart';
import 'models/home_event_plan.dart';
import 'models/home_summary.dart';
import 'services/home_activity_service.dart';
import 'services/home_event_service.dart';
import 'services/home_summary_service.dart';
import 'widgets/home_activity_row.dart';
import 'widgets/home_glass_card.dart';
import 'widgets/home_header.dart';
import '../outfits/outfits_screen.dart';
import '../wardrobe/wardrobe_screen.dart';
import '../wardrobe/wardrobe_item_detail_screen.dart';
import 'widgets/home_planned_event_card.dart';
import 'widgets/home_quick_stat_card.dart';
import 'widgets/home_section_header.dart';
import 'widgets/home_sustainability_card.dart';
import 'widgets/home_todays_outfit_card.dart';
import 'root_shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WardrobeService _wardrobeService = WardrobeService();
  final HomeEventService _eventService = HomeEventService();
  final HomeActivityService _activityService = HomeActivityService();
  final HomeSummaryService _summaryService = HomeSummaryService();

  List<HomeEventPlan> _plannedEvents = const <HomeEventPlan>[];
  bool _isLoadingEvents = false;
  String? _eventsError;
  String? _loadedForUsername;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final username = context.read<AppState>().current?.username;
    if (username != null && username.isNotEmpty && username != _loadedForUsername) {
      _loadedForUsername = username;
      _loadEvents(username);
    }
  }

  Future<void> _loadEvents(String username) async {
    setState(() {
      _isLoadingEvents = true;
      _eventsError = null;
    });

    try {
      final events = await _eventService.loadEvents(username);
      if (!mounted) return;
      setState(() {
        _plannedEvents = events;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _eventsError = 'Etkinlikler yüklenemedi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingEvents = false;
        });
      }
    }
  }

  Future<void> _showAddEventFlow(BuildContext context) async {
    final appState = context.read<AppState>();
    final username = appState.current?.username;
    if (username == null || username.isEmpty) return;

    final now = DateTime.now();
    DateTime selectedDate = now.add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 19, minute: 0);
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    String selectedType = 'Özel Davet';

    final created = await showDialog<HomeEventPlan>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: now,
                lastDate: now.add(const Duration(days: 365)),
                helpText: 'Etkinlik tarihi',
              );
              if (picked != null) {
                setLocalState(() {
                  selectedDate = picked;
                });
              }
            }

            Future<void> pickTime() async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                helpText: 'Etkinlik saati',
              );
              if (picked != null) {
                setLocalState(() {
                  selectedTime = picked;
                });
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Etkinlik Ekle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Etkinlik adı',
                        hintText: 'Ofis toplantısı, doğum günü, kahve buluşması...',
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(labelText: 'Etkinlik türü'),
                      items: const [
                        DropdownMenuItem(value: 'Ofis Toplantısı', child: Text('Ofis Toplantısı')),
                        DropdownMenuItem(value: 'Kahve Buluşması', child: Text('Kahve Buluşması')),
                        DropdownMenuItem(value: 'Özel Davet', child: Text('Özel Davet')),
                        DropdownMenuItem(value: 'Spor', child: Text('Spor')),
                        DropdownMenuItem(value: 'Okul', child: Text('Okul')),
                        DropdownMenuItem(value: 'Diğer', child: Text('Diğer')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setLocalState(() {
                          selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickDate,
                            icon: const Icon(Icons.calendar_month),
                            label: Text('${selectedDate.day}.${selectedDate.month}.${selectedDate.year}'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickTime,
                            icon: const Icon(Icons.schedule),
                            label: Text(selectedTime.format(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: noteController,
                      minLines: 2,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Not',
                        hintText: 'Dress code, mekan bilgisi, renk tercihi...',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) return;
                    final dateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    Navigator.of(dialogContext).pop(
                      HomeEventPlan(
                        id: '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(9999)}',
                        title: title,
                        type: selectedType,
                        notes: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                        dateTime: dateTime,
                        createdAt: DateTime.now(),
                      ),
                    );
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == null) return;

    await _eventService.addEvent(username, created);
    await _loadEvents(username);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Etkinlik eklendi. Zamanı yaklaşınca kombin ve bakım önerileri burada görünecek.')),
    );
  }

  void _openWardrobe(
    BuildContext context, {
    bool favoritesOnly = false,
    String initialScope = 'Tüm Aile Giysileri',
  }) {
    final shell = RootShellScope.maybeOf(context);
    if (shell != null) {
      shell.openWardrobe(
        filter: 'Tümü',
        scope: initialScope,
        favoritesOnly: favoritesOnly,
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WardrobeScreen(
          initialFilter: 'Tümü',
          initialScope: initialScope,
          initialFavoritesOnly: favoritesOnly,
        ),
      ),
    );
  }

  void _openItemDetails(BuildContext context, ClothingItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WardrobeItemDetailScreen(item: item)),
    );
  }

  void _openOutfits(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OutfitsScreen()));
  }

  void _showPassiveOutfitMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Günün Kombini kartı şimdilik pasif. Etkinlik ve bakım verileri oturdukça aktifleşecek.'),
      ),
    );
  }

  String _activityTimeLabel(DateTime value) {
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inHours < 1) return '${diff.inMinutes} dk önce';
    if (diff.inDays < 1) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return '${(diff.inDays / 7).floor()} hafta önce';
  }

  void _showCareTips(BuildContext context, List<WardrobeCareTip> tips) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bakım Hatırlatmaları',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF4A3428)),
              ),
              const SizedBox(height: 12),
              if (tips.isEmpty)
                const Text('Şu anda acil bakım uyarısı yok.')
              else
                ...tips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tip.emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip.title,
                                style: const TextStyle(
                                  color: Color(0xFF4A3428),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tip.message,
                                style: const TextStyle(
                                  color: Color(0xFF6B675F),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final current = appState.current;
    final weather = appState.currentWeather;

    final temperature = weather != null ? '${weather.temp.round()}°' : '--°';
    final city = weather?.locationLabel ?? 'Konum bekleniyor';
    final condition = appState.isWeatherLoading
        ? 'Hava durumu yükleniyor'
        : (appState.weatherError != null
            ? 'Konum izni veya bağlantı gerekli'
            : (weather?.normalizedDescription ?? 'Hava durumu hazır değil'));

    return Scaffold(
      body: Column(
        children: [
          HomeHeader(
            name: current?.username,
            temperature: temperature,
            city: city,
            condition: condition,
            humidityValue: weather != null ? '${weather.humidity}%' : '--',
            rainValue: weather != null ? '%${weather.precipitationProbability ?? 0}' : '--',
            windValue: weather != null ? '${weather.windKmh.round()} km/sa' : '--',
            weatherIconCode: weather?.icon,
            isLoading: appState.isWeatherLoading,
            onNotif: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bildirim merkezi yakında aktif olacak.')),
              );
            },
            onRefreshWeather: () async {
              await context.read<AppState>().refreshWeather();
            },
          ),
          Expanded(
            child: StreamBuilder<List<ClothingItem>>(
              stream: _wardrobeService.streamWardrobeItems(),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <ClothingItem>[];
                final summary = _summaryService.build(items: items, plannedEvents: _plannedEvents);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    BuKombinMetrics.pageHorizontalPadding,
                    18,
                    BuKombinMetrics.pageHorizontalPadding,
                    24,
                  ),
                  children: [
                    HomeSectionHeader(
                      title: 'Günün Kombini',
                      actionText: 'Değiştir',
                      onAction: () => _showPassiveOutfitMessage(context),
                    ),
                    const SizedBox(height: 12),
                    HomeTodaysOutfitCard(
                      title: summary.plannedEventCount > 0
                          ? 'Etkinlik Bazlı Kombin Alanı'
                          : 'Kombin Motoru Hazırlanıyor',
                      subtitle: summary.plannedEventCount > 0
                          ? 'Planlı etkinlikler ve bakım durumu hazır; öneri motoru sırada'
                          : 'Yapay zeka aktif olduğunda burası günlük öneri sunacak',
                      isPassive: true,
                      onTap: () => _showPassiveOutfitMessage(context),
                    ),
                    const SizedBox(height: 22),
                    const HomeSectionTitleOnly(title: 'Hızlı Bakış'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: HomeQuickStatCard(
                            title: 'Dolabım',
                            value: '${summary.wardrobeCount}',
                            subtitle: 'Parça',
                            icon: Icons.checkroom,
                            onTap: () => _openWardrobe(context, initialScope: 'Tüm Aile Giysileri'),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF5C4033), Color(0xFF4A3428)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: HomeQuickStatCard(
                            title: 'Kombin',
                            value: '${summary.readyPlanCount}',
                            subtitle: 'Planlı',
                            icon: Icons.auto_awesome,
                            onTap: () => _openOutfits(context),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8B8680), Color(0xFF6B675F)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: HomeQuickStatCard(
                            title: 'Favori',
                            value: '${summary.favoriteCount}',
                            subtitle: 'Parça',
                            icon: Icons.favorite,
                            onTap: () => _openWardrobe(context, favoritesOnly: true, initialScope: 'Tüm Aile Giysileri'),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFB4A193), Color(0xFFD4C5B9)],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    HomeSectionHeader(
                      title: 'Planlanan Etkinlikler',
                      actionText: 'Etkinlik Ekle',
                      onAction: () => _showAddEventFlow(context),
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingEvents)
                      const _HomeInfoCard(
                        icon: Icons.schedule,
                        title: 'Etkinlikler yükleniyor',
                        subtitle: 'Takvim planların hazırlanıyor.',
                      )
                    else if (_eventsError != null)
                      _HomeInfoCard(
                        icon: Icons.error_outline,
                        title: 'Etkinlikler alınamadı',
                        subtitle: _eventsError!,
                      )
                    else if (summary.plannedEvents.isEmpty)
                      const _HomeInfoCard(
                        icon: Icons.event_note,
                        title: 'Henüz planlı etkinlik yok',
                        subtitle: 'Etkinlik eklediğinde tarih geldiğinde kombin ve bakım önerileri burada hazırlanacak.',
                      )
                    else
                      ...summary.plannedEvents.map(
                        (eventView) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HomePlannedEventCard(
                            title: eventView.event.title,
                            date: eventView.dateLabel,
                            outfit: eventView.outfitText,
                            icon: eventView.icon,
                            recommendation: eventView.recommendation,
                            isUrgent: eventView.isUrgent,
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(eventView.event.title),
                                  content: Text(
                                    eventView.event.notes?.trim().isNotEmpty == true
                                        ? eventView.event.notes!
                                        : 'Etkinlik notu eklenmedi. Zamanı yaklaştığında kombin ve bakım önerisi bu kartta görünür.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Kapat'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),
                    const HomeSectionTitleOnly(title: 'Son Aktiviteler'),
                    const SizedBox(height: 12),
                    StreamBuilder<List<HomeActivityItem>>(
                      stream: _activityService.streamActivities(limit: 6),
                      builder: (context, activitySnapshot) {
                        final activities = activitySnapshot.data ?? const <HomeActivityItem>[];
                        if (activities.isEmpty) {
                          return const _HomeInfoCard(
                            icon: Icons.timeline,
                            title: 'Henüz hareket yok',
                            subtitle: 'Gerçek işlem zamanları tutuldukça aktiviteler burada görünecek.',
                          );
                        }
                        return Column(
                          children: activities.take(3).map((activity) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: HomeActivityRow(
                              icon: activity.icon,
                              title: activity.title,
                              subtitle: '${_activityTimeLabel(activity.sortDate)} • ${activity.subtitle}',
                            ),
                          )).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    const HomeSectionTitleOnly(title: 'Son Eklenenler'),
                    const SizedBox(height: 12),
                    if (summary.recentItems.isEmpty)
                      const _HomeInfoCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Dolap henüz boş',
                        subtitle: 'Yeni parça ekledikçe burada görünür.',
                      )
                    else
                      ...summary.recentItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RecentItemRow(
                            item: item,
                            onTap: () => _openItemDetails(context, item),
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),
                    HomeSectionHeader(
                      title: 'Sürdürülebilirlik Skoru',
                      actionText: 'Detaylar',
                      onAction: () {
                        final message = 'Skor; kullanım sıklığı, favori tekrar kullanımı, paylaşım, bakım bilgisi ve yıkama yoğunluğuna göre hesaplanıyor.';
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Skor gerçek gardırop verilerine göre hesaplanıyor.')),
                        );
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Skor Mantığı'),
                            content: Text(message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Tamam'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    HomeSustainabilityCard(
                      scoreText: summary.sustainabilityScoreText,
                      subtitle: summary.sustainabilitySubtitle,
                      progress: summary.sustainabilityProgress,
                    ),
                    const SizedBox(height: 22),
                    HomeSectionHeader(
                      title: 'Bakım Hatırlatmaları',
                      actionText: 'Tümü',
                      onAction: () => _showCareTips(context, summary.topCareTips),
                    ),
                    const SizedBox(height: 12),
                    if (summary.topCareTips.isEmpty)
                      const _HomeInfoCard(
                        icon: Icons.check_circle,
                        title: 'Bakım tarafı sakin görünüyor',
                        subtitle: 'Şu anda acil yıkama veya özel bakım gerektiren bir uyarı görünmüyor.',
                      )
                    else
                      ...summary.topCareTips.map(
                        (tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _HomeCareTipTile(tip: tip),
                        ),
                      ),
                    if (snapshot.hasError) ...[
                      const SizedBox(height: 12),
                      const _HomeInfoCard(
                        icon: Icons.cloud_off,
                        title: 'Gardırop verisi alınamadı',
                        subtitle: 'Bağlantı kurulduğunda bu alanlar gerçek verilerle yenilenir.',
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _HomeInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: HomeGlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.55),
            ),
            child: Icon(icon, color: const Color(0xFF4A3428)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF4A3428),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B675F),
                    height: 1.35,),
                ),
              ],
            ),
          ),
        ],
        ),
      )
    );
  }
}

class _HomeCareTipTile extends StatelessWidget {
  final WardrobeCareTip tip;

  const _HomeCareTipTile({required this.tip});

  @override
  Widget build(BuildContext context) {
    return HomeGlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD4C5B9), Color(0xFFC9B8A8)],
              ),
            ),
            child: Text(tip.emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    color: Color(0xFF4A3428),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.message,
                  style: const TextStyle(
                    color: Color(0xFF6B675F),
                    height: 1.35,
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

class _RecentItemRow extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onTap;

  const _RecentItemRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: HomeGlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 52,
                height: 52,
                color: const Color(0xFFD4C5B9).withOpacity(0.5),
                child: item.imageUrl.trim().isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.checkroom,
                          color: Color(0xFF4A3428),
                        ),
                      )
                    : const Icon(Icons.checkroom, color: Color(0xFF4A3428)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Color(0xFF4A3428),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.category} • ${item.ownerName.isNotEmpty ? item.ownerName : 'Ben'}',
                    style: const TextStyle(color: Color(0xFF6B675F)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dolaba eklenme: ${_formatAddedDate(item.createdAt)}',
                    style: const TextStyle(
                      color: Color(0xFF6B675F),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (item.isInLaundry)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF5C4033).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Yıkamada',
                  style: TextStyle(
                    color: Color(0xFF4A3428),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatAddedDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day.$month.$year';
  }
}
