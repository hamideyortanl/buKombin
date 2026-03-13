import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/weather_now.dart';

class WeatherService {
  static const _base = "https://api.openweathermap.org/data/2.5/weather";

  Future<WeatherNow> fetchCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    final apiKey = dotenv.env["OPENWEATHER_API_KEY"];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("OPENWEATHER_API_KEY bulunamadı (.env).");
    }

    final uri = Uri.parse(
      "$_base?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=tr",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Weather API hata: ${res.statusCode} - ${res.body}");
    }

    final jsonMap = json.decode(res.body) as Map<String, dynamic>;
    return WeatherNow.fromJson(jsonMap);
  }
}