import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> fetchWeather() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final weather = await _weatherService.getWeather(_controller.text);
      setState(() => _weather = weather);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal ambil data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Masukkan nama kota...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: fetchWeather,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.white)
              else if (_weather != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          _weather!.cityName,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Image.network(
                          'https://openweathermap.org/img/wn/${_weather!.icon}@4x.png',
                        ),
                        Text(
                          '${_weather!.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          _weather!.description.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: 2,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Informasi Tambahan",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Tekanan: ${_weather!.pressure} hPa\nKelembapan: ${_weather!.humidity}%",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Ramalan 5 Hari Kedepan",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _weather!.forecast.length,
                          itemBuilder: (context, index) {
                            final f = _weather!.forecast[index];
                            return Card(
                              color: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.network(
                                  'https://openweathermap.org/img/wn/${f.icon}.png',
                                ),
                                title: Text(
                                  f.description.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                subtitle: Text(
                                  f.date.split(' ')[0],
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Text(
                                  '${f.temp.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Expanded(
                  child: Center(
                    child: Text(
                      'Cari kota untuk melihat cuaca',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
