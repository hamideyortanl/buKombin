class WeatherNow {
  final double temp;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final String city;
  final String district;
  final int? precipitationProbability;

  WeatherNow({
    required this.temp,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.city,
    required this.district,
    required this.precipitationProbability,
  });

  String get locationLabel {
    if (city.isEmpty && district.isEmpty) return 'Konum bekleniyor';
    if (city.isNotEmpty && district.isNotEmpty) return '$city $district';
    return city.isNotEmpty ? city : district;
  }

  double get windKmh => windSpeed * 3.6;

  String get normalizedDescription {
    final d = description.toLowerCase().trim();

    const exactMap = {
      'clear sky': 'Açık',
      'few clouds': 'Az bulutlu',
      'scattered clouds': 'Parçalı bulutlu',
      'broken clouds': 'Çok bulutlu',
      'overcast clouds': 'Kapalı',
      'light rain': 'Hafif yağmurlu',
      'moderate rain': 'Yağmurlu',
      'heavy intensity rain': 'Kuvvetli yağmurlu',
      'drizzle': 'Çiseleme',
      'thunderstorm': 'Fırtınalı',
      'snow': 'Karlı',
      'mist': 'Sisli',
      'fog': 'Sisli',
      'haze': 'Puslu',
      'açık': 'Açık',
      'az bulutlu': 'Az bulutlu',
      'parçalı bulutlu': 'Parçalı bulutlu',
      'çok bulutlu': 'Çok bulutlu',
      'kapalı': 'Kapalı',
      'hafif yağmur': 'Hafif yağmurlu',
      'orta şiddetli yağmur': 'Yağmurlu',
      'şiddetli yağmur': 'Kuvvetli yağmurlu',
      'çiseleme': 'Çiseleme',
      'sis': 'Sisli',
      'pus': 'Puslu',
    };

    if (exactMap.containsKey(d)) return exactMap[d]!;
    if (d.contains('cloud')) return 'Bulutlu';
    if (d.contains('rain')) return 'Yağmurlu';
    if (d.contains('drizzle')) return 'Çiseleme';
    if (d.contains('thunder')) return 'Fırtınalı';
    if (d.contains('snow')) return 'Karlı';
    if (d.contains('mist') || d.contains('fog')) return 'Sisli';
    if (d.contains('clear')) return 'Açık';
    return description.isEmpty ? 'Hava durumu hazır değil' : description;
  }

  factory WeatherNow.fromJson(
    Map<String, dynamic> json, {
    String city = '',
    String district = '',
    int? precipitationProbability,
  }) {
    return WeatherNow(
      temp: (json['main']['temp'] as num).toDouble(),
      description: (json['weather'][0]['description'] as String? ?? '').trim(),
      icon: (json['weather'][0]['icon'] as String? ?? '').trim(),
      humidity: (json['main']['humidity'] as num).toInt(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      city: city.isNotEmpty ? city : ((json['name'] as String?) ?? ''),
      district: district,
      precipitationProbability: precipitationProbability,
    );
  }
}
