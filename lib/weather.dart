import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = "Unknown";
  double? _temperature;
  String _weatherDescription = "Unknown";
  String _weatherIcon = "🌤️";
  double? _tempMax;
  double? _tempMin;
  double? _windSpeed;
  double? _humidity;
  DateTime? _lastUpdated;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getWeather(double latitude, double longitude) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    final String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _city = data['name'] ?? "Unknown City";
          _temperature = data['main']['temp'].toDouble();
          _weatherDescription = data['weather'][0]['description'] ?? "No description";
          _weatherIcon = _getWeatherIcon(data['weather'][0]['main']);
          _tempMax = data['main']['temp_max'].toDouble();
          _tempMin = data['main']['temp_min'].toDouble();
          _windSpeed = data['wind']['speed'].toDouble();
          _humidity = data['main']['humidity'].toDouble();
          _lastUpdated = DateTime.now();
          _isLoading = false;
          _hasError = false;
        });
      } else {
        throw Exception('Failed to load weather data. Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case "clear":
        return "☀️";
      case "clouds":
        return "☁️";
      case "rain":
        return "🌧️";
      case "snow":
        return "❄️";
      default:
        return "🌤️";
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      _getWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _city = "Error";
        _weatherDescription = e.toString();
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Widget _extraInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Max: ${_tempMax?.toStringAsFixed(1) ?? '--'}°C"),
              Text("Min: ${_tempMin?.toStringAsFixed(1) ?? '--'}°C"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Wind: ${_windSpeed?.toStringAsFixed(1) ?? '--'} m/s"),
              Text("Humidity: ${_humidity?.toStringAsFixed(0) ?? '--'}%"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 64),
              SizedBox(height: 16),
              Text(
                "Failed to load data. Please try again later.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _city,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_lastUpdated != null)
                Text(
                  "Last updated: ${DateFormat('hh:mm a').format(_lastUpdated!)}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const SizedBox(height: 8),
              Text(
                _weatherIcon,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 8),
              Text(
                "${_temperature?.toStringAsFixed(1) ?? '--'}°C",
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                _weatherDescription,
                style: const TextStyle(fontSize: 24, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _extraInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
