import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import '../../wardrobe/care/wardrobe_care_engine.dart';
import '../../wardrobe/care/wardrobe_care_models.dart';
import '../models/home_event_plan.dart';
import '../models/home_planned_event_view.dart';
import '../models/home_summary.dart';

class HomeSummaryService {
  HomeSummary build({
    required List<ClothingItem> items,
    required List<HomeEventPlan> plannedEvents,
  }) {
    final tips = WardrobeCareEngine.generateTips(items);
    final favorites = items.where((item) => item.isFavorite).length;
    final inLaundry = items.where((item) => item.isInLaundry).length;
    final recentItems = [...items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final activeEvents = [...plannedEvents]..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final plannedEventViews = activeEvents.take(3).map((event) {
      return _mapEvent(items, tips, event);
    }).toList();

    final sustainabilityScore = _buildSustainabilityScore(items);

    return HomeSummary(
      wardrobeCount: items.length,
      readyPlanCount: activeEvents.length,
      favoriteCount: favorites,
      inLaundryCount: inLaundry,
      plannedEventCount: activeEvents.length,
      sustainabilityProgress: sustainabilityScore / 100,
      sustainabilityScoreText: '${sustainabilityScore.round()}/100',
      sustainabilitySubtitle: _buildSustainabilitySubtitle(sustainabilityScore),
      activities: const [],
      plannedEvents: plannedEventViews,
      topCareTips: tips.take(3).toList(),
      recentItems: recentItems.take(3).toList(),
    );
  }

  double _buildSustainabilityScore(List<ClothingItem> items) {
    if (items.isEmpty) return 40;

    final averageUsage =
        items.fold<int>(0, (sum, item) => sum + item.usageCount) / items.length;
    final sharedRatio =
        items.where((item) => item.isSharedItem).length / items.length;
    final careKnownRatio = items
        .where((item) => item.careLabelKnown || item.hasCareInstructions)
        .length /
        items.length;
    final laundryRatio =
        items.where((item) => item.isInLaundry).length / items.length;

    final usageScore = (averageUsage * 4).clamp(0, 20).toDouble();
    final sharedScore = (sharedRatio * 20).clamp(0, 20);
    final careScore = (careKnownRatio * 15).clamp(0, 15);
    final laundryScore = ((1 - laundryRatio) * 15).clamp(0, 15);
    final favoriteReuseScore = (items
        .where((item) => item.isFavorite && item.usageCount >= 3)
        .length /
        items.length *
        10)
        .clamp(0, 10);
    final averageAgeInDays = items
            .map((item) => DateTime.now().difference(item.createdAt).inDays.clamp(0, 365))
            .fold<int>(0, (sum, value) => sum + value) /
        items.length;
    final longevityScore = (averageAgeInDays / 365 * 10).clamp(0, 10);

    return (30 +
        usageScore +
        sharedScore +
        careScore +
        laundryScore +
        favoriteReuseScore +
        longevityScore)
        .clamp(0, 100)
        .toDouble();
  }

  String _buildSustainabilitySubtitle(double score) {
    if (score >= 85) {
      return 'Harika! Sık kullanım, dolapta kalıcılık ve bakım alışkanlıkların güçlü görünüyor.';
    }
    if (score >= 70) {
      return 'İyi gidiyorsun. Düzenli kullanım, bakım ve parça ömrü skoru yukarı taşıyor.';
    }
    if (score >= 55) {
      return 'Temel alışkanlıklar oluşmuş. Favori ve bakım takibini artırarak geliştirebilirsin.';
    }
    return 'Skor gelişime açık. Kullanım ve bakım düzeni oturdukça daha sürdürülebilir bir dolap oluşur.';
  }




  HomePlannedEventView _mapEvent(
      List<ClothingItem> items,
      List<WardrobeCareTip> tips,
      HomeEventPlan event,
      ) {
    final now = DateTime.now();
    final hoursUntil = event.dateTime.difference(now).inHours;
    final urgent = hoursUntil <= 72;
    final urgentTip = tips.isNotEmpty ? tips.first : null;

    String? recommendation;
    if (urgent && urgentTip != null) {
      if (urgentTip.item.isInLaundry) {
        recommendation =
        '${urgentTip.item.name} hâlâ yıkamada. ${event.title} öncesi kuruma durumunu kontrol et.';
      } else if (urgentTip.item.usageCount >= 1) {
        recommendation =
        '${urgentTip.item.name} için bakım zamanı yakın. ${event.title} öncesi temizliğini planla.';
      }
    } else if (items.where((item) => item.isAvailableForOutfit).length < 3) {
      recommendation =
      'Etkinlik için uygun parça sayın az. Şimdiden alternatif kombinlerini ayırman iyi olur.';
    }

    return HomePlannedEventView(
      event: event,
      dateLabel: _formatEventDate(event.dateTime),
      outfitText: urgent
          ? 'Kombin önerisi etkinlik yaklaşınca aktif olacak'
          : 'Takvim zamanı geldiğinde kombin önerisi hazırlanacak',
      icon: _iconForEventType(event.type),
      recommendation: recommendation,
      isUrgent: urgent,
    );
  }

  IconData _iconForEventType(String type) {
    final value = type.toLowerCase();
    if (value.contains('ofis') || value.contains('iş') || value.contains('toplantı')) {
      return Icons.work;
    }
    if (value.contains('kahve') || value.contains('buluş')) {
      return Icons.coffee;
    }
    if (value.contains('spor')) {
      return Icons.fitness_center;
    }
    if (value.contains('davet') || value.contains('gece')) {
      return Icons.celebration;
    }
    if (value.contains('okul')) {
      return Icons.school;
    }
    return Icons.event;
  }

  String _formatEventDate(DateTime dateTime) {
    const days = <String>['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final day = days[dateTime.weekday - 1];
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day • $hour:$minute';
  }

  String _relativeTime(DateTime value) {
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inHours < 1) return '${diff.inMinutes} dk önce';
    if (diff.inDays < 1) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return '${(diff.inDays / 7).floor()} hafta önce';
  }
}