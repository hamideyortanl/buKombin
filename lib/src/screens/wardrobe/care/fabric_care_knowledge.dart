import 'wardrobe_care_models.dart';

class FabricCareKnowledge {
  static const FabricCareProfile defaultProfile = FabricCareProfile(
    washTemperature: '30°C',
    washMethod: 'Nazik veya kısa program',
    dryingMethod: 'Asarak veya sererek kurut',
    ironLevel: 'Düşük ısı',
    washAfterWears: 2,
    sustainabilityTip: 'Her kullanım sonrası yıkamak yerine önce havalandırmayı düşün.',
    handlingTip: 'Bakım etiketi varsa önce onu esas almak en güvenli seçimdir.',
  );

  static const Map<String, FabricCareProfile> _profiles = {
    'pamuk': FabricCareProfile(
      washTemperature: '30°C - 40°C',
      washMethod: 'Normal program / 800-1000 devir',
      dryingMethod: 'Makinede kurutulabilir, asarak da kurutulabilir',
      ironLevel: 'Yüksek ısı',
      washAfterWears: 2,
      sustainabilityTip: 'Sadece ter kokusu varsa 30°C kısa program yeterli olabilir.',
      handlingTip: 'Benzer renklerle yıkamak renk ömrünü korur.',
    ),
    'organik pamuk': FabricCareProfile(
      washTemperature: '30°C',
      washMethod: 'Kısa veya normal program',
      dryingMethod: 'Asarak kurut',
      ironLevel: 'Orta ısı',
      washAfterWears: 2,
      sustainabilityTip: 'Düşük sıcaklık enerji tasarrufu sağlar ve lif ömrünü uzatır.',
      handlingTip: 'Gereksiz yüksek sıcaklıktan kaçın.',
    ),
    'keten': FabricCareProfile(
      washTemperature: '30°C - 40°C',
      washMethod: 'Hassas program / 600 devir',
      dryingMethod: 'Asarak kurut',
      ironLevel: 'Nemliyken tersten ütü',
      washAfterWears: 2,
      sustainabilityTip: 'Keten parçaları çoğu zaman havalandırmak yeterlidir.',
      handlingTip: 'Çok kırıştığı için hafif nemliyken ütülemek daha kolaydır.',
    ),
    'yün': FabricCareProfile(
      washTemperature: 'Soğuk veya 30°C',
      washMethod: 'Yün programı / sıkmasız',
      dryingMethod: 'Kesinlikle sererek kurut',
      ironLevel: 'Düşük ısı / buharlı',
      washAfterWears: 5,
      sustainabilityTip: 'Yün parçalar için sık yıkama yerine havalandırma daha sürdürülebilirdir.',
      handlingTip: 'Asmak formu bozabilir.',
    ),
    'merinos yünü': FabricCareProfile(
      washTemperature: 'Soğuk veya 30°C',
      washMethod: 'Yün programı',
      dryingMethod: 'Sererek kurut',
      ironLevel: 'Düşük ısı',
      washAfterWears: 5,
      sustainabilityTip: 'Havalandırma çoğu zaman yıkama ihtiyacını geciktirir.',
      handlingTip: 'Sıkma ve yüksek ısı kullanma.',
    ),
    'kaşmir': FabricCareProfile(
      washTemperature: 'Soğuk veya 30°C',
      washMethod: 'Elde yıkama / sıkılmaz',
      dryingMethod: 'Sererek kurut',
      ironLevel: 'Düşük ısı',
      washAfterWears: 5,
      sustainabilityTip: 'Seyrek yıkama kaşmir lif ömrünü uzatır.',
      handlingTip: 'Direkt asma ve yüksek ısıdan kaçın.',
    ),
    'ipek': FabricCareProfile(
      washTemperature: 'Elde veya soğuk su',
      washMethod: 'Elde yıkama / sıkılmaz',
      dryingMethod: 'Gölgede kurut',
      ironLevel: 'Çok düşük ısı / buharsız',
      washAfterWears: 3,
      sustainabilityTip: 'Gerçek kir yoksa yalnızca havalandırma yeterli olabilir.',
      handlingTip: 'Direkt güneşe maruz bırakma.',
    ),
    'denim': FabricCareProfile(
      washTemperature: '30°C',
      washMethod: 'Normal program / 800 devir',
      dryingMethod: 'Ters çevirerek asarak kurut',
      ironLevel: 'Düşük ısı',
      washAfterWears: 6,
      sustainabilityTip: 'Kot ürünleri seyrek yıkamak formunu ve rengini korur.',
      handlingTip: 'Renk solmasını azaltmak için ters çevirerek yıka.',
    ),
    'polyester': FabricCareProfile(
      washTemperature: '30°C',
      washMethod: 'Sentetik program / 800 devir',
      dryingMethod: 'Hızlı kurur, düşük ısıda kurut',
      ironLevel: 'Düşük ısı',
      washAfterWears: 2,
      sustainabilityTip: 'Kısa program ve tam dolu makine enerji kullanımını azaltır.',
      handlingTip: 'Yüksek ısı lifleri bozabilir.',
    ),
    'geri dönüştürülmüş polyester': FabricCareProfile(
      washTemperature: '30°C',
      washMethod: 'Sentetik program / 800 devir',
      dryingMethod: 'Asarak kurut',
      ironLevel: 'Düşük ısı',
      washAfterWears: 2,
      sustainabilityTip: 'Mikrofiber salınımını azaltmak için gereksiz sık yıkamadan kaçın.',
      handlingTip: 'Yüksek ısı önerilmez.',
    ),
    'viskon': FabricCareProfile(
      washTemperature: '30°C',
      washMethod: 'Hassas program / 600 devir',
      dryingMethod: 'Sererek kurut',
      ironLevel: 'Düşük ısı',
      washAfterWears: 2,
      sustainabilityTip: 'Nazik yıkama kumaş ömrünü uzatır.',
      handlingTip: 'Islakken çekiştirme, çekebilir.',
    ),
    'rayon': FabricCareProfile(
      washTemperature: '30°C',
      washMethod: 'Hassas program / 600 devir',
      dryingMethod: 'Sererek kurut',
      ironLevel: 'Düşük ısı',
      washAfterWears: 2,
      sustainabilityTip: 'Sık yıkama yerine havalandırmayı dene.',
      handlingTip: 'Suda form kaybı yaşayabilir.',
    ),
    'deri': FabricCareProfile(
      washTemperature: 'Makinede yıkanmaz',
      washMethod: 'Silerek temizle veya kuru temizleme',
      dryingMethod: 'Isıdan uzak doğal ortam',
      ironLevel: 'Ütü uygulanmaz',
      washAfterWears: 20,
      sustainabilityTip: 'Tam yıkama yerine yüzey temizliği daha uygundur.',
      handlingTip: 'Isı ve fazla su deriye zarar verebilir.',
    ),
    'süet': FabricCareProfile(
      washTemperature: 'Makinede yıkanmaz',
      washMethod: 'Silerek temizle veya profesyonel bakım',
      dryingMethod: 'Isıdan uzak doğal ortam',
      ironLevel: 'Ütü uygulanmaz',
      washAfterWears: 20,
      sustainabilityTip: 'Fırçalama ve noktasal temizlik çoğu zaman yeterlidir.',
      handlingTip: 'Su lekesi bırakabileceği için dikkatli davran.',
    ),
  };

  static FabricCareProfile resolveProfile(String? material) {
    if (material == null || material.trim().isEmpty) return defaultProfile;
    final key = material.trim().toLowerCase();
    return _profiles[key] ?? defaultProfile;
  }
}
