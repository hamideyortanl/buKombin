class WeatherNow {
  final double temp;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final String city;

  WeatherNow({
    required this.temp,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.city,
  });

  factory WeatherNow.fromJson(Map<String, dynamic> json) {
    return WeatherNow(
      temp: (json["main"]["temp"] as num).toDouble(),
      description: (json["weather"][0]["description"] as String),
      icon: (json["weather"][0]["icon"] as String),
      humidity: (json["main"]["humidity"] as num).toInt(),
      windSpeed: (json["wind"]["speed"] as num).toDouble(),
      city: (json["name"] as String?) ?? "",
    );
  }
}