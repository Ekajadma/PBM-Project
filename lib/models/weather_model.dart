class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final int pressure;
  final int humidity;
  final List<Forecast> forecast;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.pressure,
    required this.humidity,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> currentJson, Map<String, dynamic> forecastJson) {
    final forecastList = (forecastJson['list'] as List)
        .where((e) => e['dt_txt'].contains('12:00:00')) // ambil jam 12 siang tiap hari
        .take(5)
        .map((e) => Forecast.fromJson(e))
        .toList();

    return WeatherModel(
      cityName: currentJson['name'],
      temperature: currentJson['main']['temp'].toDouble(),
      description: currentJson['weather'][0]['description'],
      icon: currentJson['weather'][0]['icon'],
      pressure: currentJson['main']['pressure'],
      humidity: currentJson['main']['humidity'],
      forecast: forecastList,
    );
  }
}

class Forecast {
  final String date;
  final double temp;
  final String description;
  final String icon;

  Forecast({
    required this.date,
    required this.temp,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['dt_txt'],
      temp: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
