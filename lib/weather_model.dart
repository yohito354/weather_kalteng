class KaltengCity {
  const KaltengCity({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

class CurrentWeather {
  const CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.time,
  });

  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String time;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final temperature = json['temperature'];
    final windSpeed = json['windspeed'];
    final weatherCode = json['weathercode'];
    final time = json['time'];

    if (temperature is! num ||
        windSpeed is! num ||
        weatherCode is! num ||
        time is! String) {
      throw const FormatException('Format data cuaca tidak valid.');
    }

    return CurrentWeather(
      temperature: temperature.toDouble(),
      windSpeed: windSpeed.toDouble(),
      weatherCode: weatherCode.toInt(),
      time: time,
    );
  }
}
