import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = '99f3da3142dbd5c44c85c576a408b46b';

  Future<WeatherModel> getWeather(String city) async {
    final currentUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';

    final currentResponse = await http.get(Uri.parse(currentUrl));
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
      final currentData = jsonDecode(currentResponse.body);
      final forecastData = jsonDecode(forecastResponse.body);
      return WeatherModel.fromJson(currentData, forecastData);
    } else {
      throw Exception('Gagal mengambil data cuaca');
    }
  }
}
