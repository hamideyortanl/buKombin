import '../../../models/clothing_item.dart';
import 'fabric_care_knowledge.dart';
import 'wardrobe_care_models.dart';

class WardrobeCareEngine {
  static const Map<String, int> _categoryWearThresholds = {
    'İç Giyim': 1,
    'Gece Giyim': 1,
    'Spor Giyim': 1,
    'Üst': 2,
    'Elbise': 3,
    'Alt': 4,
    'Takım': 3,
    'Dış Giyim': 12,
  };

  static FabricCareProfile buildProfile(ClothingItem item) {
    final base = FabricCareKnowledge.resolveProfile(item.material);
    var profile = base;

    final categoryThreshold = _categoryWearThresholds[item.category];
    if (categoryThreshold != null) {
      profile = FabricCareProfile(
        washTemperature: profile.washTemperature,
        washMethod: profile.washMethod,
        dryingMethod: profile.dryingMethod,
        ironLevel: profile.ironLevel,
        washAfterWears: categoryThreshold,
        sustainabilityTip: profile.sustainabilityTip,
        handlingTip: profile.handlingTip,
      );
    }

    final sub = item.subcategory.toLowerCase();
    final season = item.season?.toLowerCase() ?? '';

    if (sub.contains('jean')) {
      profile = FabricCareProfile(
        washTemperature: '30°C',
        washMethod: 'Normal program / 800 devir',
        dryingMethod: 'Ters çevirerek asarak kurut',
        ironLevel: 'Düşük ısı',
        washAfterWears: 5,
        sustainabilityTip: 'Kot parçaları 5-10 giyim arası değerlendirerek yıkamak daha sürdürülebilirdir.',
        handlingTip: 'Rengi korumak için ters çevirerek yıka.',
      );
    }

    if (item.category == 'Dış Giyim') {
      profile = FabricCareProfile(
        washTemperature: 'Sık tam yıkama önerilmez',
        washMethod: 'Leke bazlı temizlik / ihtiyaç halinde bakım',
        dryingMethod: 'Asarak doğal ortamda kurut',
        ironLevel: 'Ürüne göre düşük ısı',
        washAfterWears: 12,
        sustainabilityTip: 'Mont, kaban ve ceketler kirlenmedikçe sezonda 1-2 kez bakım görmek yeterlidir.',
        handlingTip: 'Önce havalandırma, sonra noktasal temizlik düşün.',
      );
    }

    if (item.category == 'Ayakkabı') {
      profile = FabricCareProfile(
        washTemperature: 'Makinede yıkama genelde önerilmez',
        washMethod: 'Malzemeye uygun silme / bakım',
        dryingMethod: 'Isıdan uzak doğal ortam',
        ironLevel: 'Ütü uygulanmaz',
        washAfterWears: 20,
        sustainabilityTip: 'Ayakkabıları yüzey bazlı temizlemek tam yıkamadan daha sürdürülebilir olur.',
        handlingTip: 'Malzemeye göre bakım yap; deri ve süette makine kullanma.',
      );
    }

    if (season == 'yaz') {
      profile = FabricCareProfile(
        washTemperature: profile.washTemperature == '30°C - 40°C' ? '30°C' : profile.washTemperature,
        washMethod: profile.washMethod,
        dryingMethod: 'Koyu renklerde gölgede kurut',
        ironLevel: profile.ironLevel,
        washAfterWears: profile.washAfterWears,
        sustainabilityTip: 'Yazın ter kaynaklı yıkamalarda düşük sıcaklık ve kısa program çoğu zaman yeterlidir.',
        handlingTip: 'Renk solmasını azaltmak için koyu parçaları ters çevirerek kurut.',
      );
    }

    if (season == 'kış' && (item.category == 'Üst' || item.category == 'Dış Giyim')) {
      profile = FabricCareProfile(
        washTemperature: profile.washTemperature,
        washMethod: profile.washMethod,
        dryingMethod: profile.dryingMethod,
        ironLevel: profile.ironLevel,
        washAfterWears: profile.washAfterWears + 1,
        sustainabilityTip: 'Kışın katmanlı giyimde üst katmanlar tene daha az değdiği için havalandırma daha mantıklı olabilir.',
        handlingTip: 'Kazak ve montlarda önce havalandırmayı düşün.',
      );
    }

    return profile;
  }

  static List<WardrobeCareTip> generateTips(List<ClothingItem> items) {
    final now = DateTime.now();
    final tips = <WardrobeCareTip>[];

    for (final item in items) {
      final profile = buildProfile(item);
      final threshold = profile.washAfterWears;
      final overdueCount = item.usageCount - threshold;
      final daysSinceWorn = item.lastWornAt == null ? null : now.difference(item.lastWornAt!).inDays;

      if (item.isInLaundry) {
        tips.add(
          WardrobeCareTip(
            item: item,
            title: item.name,
            message: 'Yıkamada görünüyor. Bu aşamada ${profile.washTemperature} ve ${profile.washMethod.toLowerCase()} önerilir.',
            emoji: '🧼',
            priority: 110,
          ),
        );
      }

      if (item.usageCount >= threshold && !item.isInLaundry) {
        final emphasis = overdueCount >= 2
            ? 'Normalde $threshold kullanımda yıkanmalıydı; şu an ${item.usageCount} kez kullanıldı, artık yıkama zamanı.'
            : '$threshold kullanım eşiğine ulaştı. Artık yıkamayı düşünmelisin.';
        tips.add(
          WardrobeCareTip(
            item: item,
            title: item.name,
            message: '$emphasis ${profile.washTemperature} ve ${profile.washMethod.toLowerCase()} önerilir.',
            emoji: '🧺',
            priority: 100 + overdueCount,
          ),
        );
      }

      final material = item.material?.toLowerCase() ?? '';
      if (material.contains('yün') || material.contains('kaşmir') || material.contains('ipek') || material.contains('deri') || material.contains('süet')) {
        tips.add(
          WardrobeCareTip(
            item: item,
            title: item.name,
            message: '${item.material} hassas bir yapıdadır. ${profile.handlingTip}',
            emoji: '🫧',
            priority: 90,
          ),
        );
      }

      if (item.isFavorite && daysSinceWorn != null && daysSinceWorn >= 30 && !item.isInLaundry) {
        tips.add(
          WardrobeCareTip(
            item: item,
            title: item.name,
            message: 'Favori parçanı $daysSinceWorn gündür giymedin. Yıkama yerine havalandırıp tekrar kombinleyebilirsin.',
            emoji: '⭐',
            priority: 70,
          ),
        );
      }

      if (daysSinceWorn != null && daysSinceWorn >= 60 && !item.isInLaundry) {
        tips.add(
          WardrobeCareTip(
            item: item,
            title: item.name,
            message: '$daysSinceWorn gündür kullanılmadı. Kaldırmadan önce havalandırma ve bakım kontrolü yapabilirsin.',
            emoji: '📦',
            priority: 60,
          ),
        );
      }

      if (!item.hasCareInstructions && item.hasMaterial) {
        tips.add(
          WardrobeCareTip(
            item: item,
            title: item.name,
            message: '${item.material} için öneri: ${profile.sustainabilityTip}',
            emoji: '🌿',
            priority: 50,
          ),
        );
      }
    }

    tips.sort((a, b) => b.priority.compareTo(a.priority));
    return tips;
  }
}
