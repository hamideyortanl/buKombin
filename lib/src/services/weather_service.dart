import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String _apiKey = 'b54c79abc4ff2289087b528668a730f1'; // Senin Key'in
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final url = Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric&lang=tr');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        // Hata durumunda API'den gelen mesajı veya genel hatayı fırlat
        throw Exception('Hava durumu alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }
}