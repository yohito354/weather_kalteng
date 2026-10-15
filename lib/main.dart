import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'weather_model.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuaca Kalteng',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const WeatherKaltengScreen(),
    );
  }
}

class WeatherKaltengScreen extends StatefulWidget {
  const WeatherKaltengScreen({super.key});

  @override
  State<WeatherKaltengScreen> createState() => _WeatherKaltengScreenState();
}

class _WeatherKaltengScreenState extends State<WeatherKaltengScreen> {
  static const cities = <KaltengCity>[
    KaltengCity(
      name: 'Palangkaraya (Ibu Kota)',
      latitude: -2.2106,
      longitude: 113.9139,
    ),
    KaltengCity(
      name: 'Sampit (Kotim)',
      latitude: -2.5333,
      longitude: 112.9500,
    ),
    KaltengCity(
      name: 'Pangkalan Bun (Kobar)',
      latitude: -2.6833,
      longitude: 111.6167,
    ),
    KaltengCity(
      name: 'Muara Teweh (Barito Utara)',
      latitude: -0.9500,
      longitude: 114.9000,
    ),
    KaltengCity(
      name: 'Kuala Kapuas (Kapuas)',
      latitude: -3.0092,
      longitude: 114.3813,
    ),
    KaltengCity(
      name: 'Buntok (Barito Selatan)',
      latitude: -1.7223,
      longitude: 114.8572,
    ),
    KaltengCity(
      name: 'Puruk Cahu (Murung Raya)',
      latitude: -0.5975,
      longitude: 114.6160,
    ),
  ];

  KaltengCity selectedCity = cities.first;
  CurrentWeather? currentWeather;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather(selectedCity);
  }

  Future<void> _fetchWeather(KaltengCity city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'current_weather': 'true',
      'timezone': 'auto',
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw HttpException(
          'Gagal mengambil data cuaca. '
          'Status code: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> ||
          decoded['current_weather'] is! Map<String, dynamic>) {
        throw const FormatException('Data cuaca saat ini tidak tersedia.');
      }

      final weather = CurrentWeather.fromJson(
        decoded['current_weather'] as Map<String, dynamic>,
      );
      if (!mounted) return;
      setState(() {
        currentWeather = weather;
        isLoading = false;
      });
    } on FormatException catch (error) {
      _showError(error.message);
    } on HttpException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError(
        'Tidak dapat terhubung ke Open-Meteo. Periksa koneksi internet.',
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      isLoading = false;
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca Kalimantan Tengah'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchWeather(selectedCity),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Pilih Kabupaten / Kota',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<KaltengCity>(
              initialValue: selectedCity,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: cities
                  .map(
                    (city) => DropdownMenuItem(
                      value: city,
                      child: Text(city.name),
                    ),
                  )
                  .toList(),
              onChanged: (city) {
                if (city == null) return;
                setState(() {
                  selectedCity = city;
                  currentWeather = null;
                });
                _fetchWeather(city);
              },
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (errorMessage != null)
              _ErrorCard(
                message: errorMessage!,
                onRetry: () => _fetchWeather(selectedCity),
              )
            else if (currentWeather != null)
              _WeatherCard(city: selectedCity, weather: currentWeather!),
          ],
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({required this.city, required this.weather});

  final KaltengCity city;
  final CurrentWeather weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.wb_sunny_outlined, size: 52, color: Colors.orange),
            const SizedBox(height: 12),
            Text(
              city.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text('Kode cuaca: ${weather.weatherCode}'),
            Text(
              'Kecepatan angin: '
              '${weather.windSpeed.toStringAsFixed(1)} km/jam',
            ),
            const SizedBox(height: 8),
            Text(
              'Diperbarui: ${weather.time.replaceFirst('T', ' ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class HttpException implements Exception {
  const HttpException(this.message);

  final String message;
}
