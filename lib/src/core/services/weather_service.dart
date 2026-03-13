import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../models/weather_now.dart';

class WeatherService {
  static const _weatherBase = 'https://api.openweathermap.org/data/2.5/weather';
  static const _forecastBase = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<WeatherNow> fetchCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OPENWEATHER_API_KEY bulunamadı (.env).');
    }

    String city = '';
    String district = '';

    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        city = (place.administrativeArea ?? '').trim();

        final candidates = <String?>[
          place.locality,
          place.subLocality,
          place.subAdministrativeArea,
          place.street,
        ];
        district = candidates
            .map((e) => (e ?? '').trim())
            .firstWhere(
              (e) => e.isNotEmpty && e.toLowerCase() != city.toLowerCase(),
              orElse: () => '',
            );
      }
    } catch (_) {
      // Konum adı çözülemezse hava durumu yine dönsün.
    }

    final weatherUri = Uri.parse(
      '$_weatherBase?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=tr',
    );
    final forecastUri = Uri.parse(
      '$_forecastBase?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=tr',
    );

    final responses = await Future.wait([
      http.get(weatherUri),
      http.get(forecastUri),
    ]);

    final weatherResponse = responses[0];
    final forecastResponse = responses[1];

    if (weatherResponse.statusCode != 200) {
      throw Exception('Weather API hata: ${weatherResponse.statusCode} - ${weatherResponse.body}');
    }

    final weatherJson = json.decode(weatherResponse.body) as Map<String, dynamic>;

    int? precipitationProbability;
    if (forecastResponse.statusCode == 200) {
      final forecastJson = json.decode(forecastResponse.body) as Map<String, dynamic>;
      final list = (forecastJson['list'] as List?) ?? const [];
      if (list.isNotEmpty) {
        final first = list.first as Map<String, dynamic>;
        final pop = (first['pop'] as num?)?.toDouble();
        if (pop != null) {
          precipitationProbability = (pop * 100).round();
        }
      }
    }

    final apiCity = ((weatherJson['name'] as String?) ?? '').trim();
    if (district.isEmpty && apiCity.isNotEmpty) {
      district = apiCity;
    }

    return WeatherNow.fromJson(
      weatherJson,
      city: city,
      district: district,
      precipitationProbability: precipitationProbability,
    );
  }
}
