import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'widgets/home_activity_row.dart';
import 'widgets/home_header.dart';
import 'widgets/home_planned_event_card.dart';
import 'widgets/home_quick_stat_card.dart';
import 'widgets/home_section_header.dart';
import 'widgets/home_sustainability_card.dart';
import 'widgets/home_todays_outfit_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: SafeArea(
        child: Column(
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
                  const SnackBar(content: Text('Bildirimler (demo)')),
                );
              },
              onRefreshWeather: () async {
                await context.read<AppState>().refreshWeather();
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                children: [
                  HomeSectionHeader(
                    title: 'Günün Kombini',
                    actionText: 'Değiştir',
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kombin değiştir (demo)')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  HomeTodaysOutfitCard(
                    title: 'Kahve Tonlarında Şıklık',
                    subtitle: 'Modern, zarif ve kışa uygun',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Günün kombini açıldı (demo)')),
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  const HomeSectionTitleOnly(title: 'Hızlı Bakış'),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(
                        child: HomeQuickStatCard(
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
                        child: HomeQuickStatCard(
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
                        child: HomeQuickStatCard(
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
                  HomeSectionHeader(
                    title: 'Sürdürülebilirlik Skoru',
                    actionText: 'Detaylar',
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sürdürülebilirlik detay (demo)')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const HomeSustainabilityCard(
                    scoreText: '85/100',
                    subtitle: 'Harika! Çevre dostu seçimler yapıyorsunuz.',
                    progress: 0.85,
                  ),
                  const SizedBox(height: 22),
                  const HomeSectionTitleOnly(title: 'Son Aktiviteler'),
                  const SizedBox(height: 12),
                  const HomeActivityRow(
                    icon: Icons.check_circle,
                    title: 'Yeni kombin oluşturuldu',
                    subtitle: '2 saat önce',
                  ),
                  const SizedBox(height: 10),
                  const HomeActivityRow(
                    icon: Icons.add_circle,
                    title: 'Dolaba yeni parça eklendi',
                    subtitle: '1 gün önce',
                  ),
                  const SizedBox(height: 10),
                  const HomeActivityRow(
                    icon: Icons.favorite,
                    title: 'Favori parça seçildi',
                    subtitle: '3 gün önce',
                  ),
                  const SizedBox(height: 22),
                  HomeSectionHeader(
                    title: 'Planlanan Etkinlikler',
                    actionText: 'Tümü',
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Etkinlikler (demo)')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const HomePlannedEventCard(
                    title: 'Ofis Toplantısı',
                    date: 'Salı • 10:00',
                    outfit: 'Klasik Ofis Kombini',
                    icon: Icons.work,
                  ),
                  const SizedBox(height: 10),
                  const HomePlannedEventCard(
                    title: 'Kahve Buluşması',
                    date: 'Çarşamba • 18:30',
                    outfit: 'Günlük Şık Kombin',
                    icon: Icons.coffee,
                  ),
                  const SizedBox(height: 10),
                  const HomePlannedEventCard(
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
