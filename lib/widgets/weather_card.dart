import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'partly cloudy':
        return Icons.wb_cloudy;
      case 'rainy':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(
          _getWeatherIcon(weather.description),
          color: Colors.white,
          size: 28,
        ),
        title: Text(
          weather.cityName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          "${weather.temperature}°C",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
