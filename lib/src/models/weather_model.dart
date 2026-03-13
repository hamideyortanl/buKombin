class WeatherModel {
  final String city;
  final double temperature;
  final String description;
  final String iconCode;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  // JSON'dan Model üretme fabrikası 🏭
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? '',
      // Sıcaklık bazen int bazen double gelebilir, güvenli dönüşüm:
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '01d',
    );
  }
}