import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import the geolocator package
import 'package:http/http.dart' as http;  // For API calls
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

const String OPENWEATHER_API_KEY = "a5445f5c3c565fe28d090e0f601b240c";  // Your OpenWeather API key

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = "Unknown";
  double? _temperature;
  String _weatherDescription = "Unknown";
  String _weatherIcon = "🌤️"; // Default icon
  double? _tempMax;
  double? _tempMin;
  double? _windSpeed;
  double? _humidity;
  DateTime? _lastUpdated; // New variable to hold the current time

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get the location when the screen is loaded
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getWeather(double latitude, double longitude) async {
    final String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$OPENWEATHER_API_KEY&units=metric";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _city = data['name'] ?? "Unknown City";
          _temperature = data['main']['temp'].toDouble();
          _weatherDescription = data['weather'][0]['description'] ?? "No description";
          _weatherIcon = _getWeatherIcon(data['weather'][0]['main']);
          _tempMax = data['main']['temp_max'].toDouble();
          _tempMin = data['main']['temp_min'].toDouble();
          _windSpeed = data['wind']['speed'].toDouble();
          _humidity = data['main']['humidity'].toDouble();
          _lastUpdated = DateTime.now(); // Update the current time
        });
      } else {
        setState(() {
          _city = "Error";
          _weatherDescription = "Unable to fetch weather data";
        });
      }
    } catch (e) {
      setState(() {
        _city = "Error";
        _weatherDescription = "Failed to load data";
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
      print(e);
      setState(() {
        _city = "Error";
        _weatherDescription = "Failed to get location";
      });
    }
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Max: ${_tempMax != null ? _tempMax!.toStringAsFixed(1) + '°C' : 'Loading...'}",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Min: ${_tempMin != null ? _tempMin!.toStringAsFixed(1) + '°C' : 'Loading...'}",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind: ${_windSpeed != null ? _windSpeed!.toStringAsFixed(1) + ' m/s' : 'Loading...'}",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Humidity: ${_humidity != null ? _humidity!.toStringAsFixed(0) + '%' : 'Loading...'}",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          if (_lastUpdated != null)
            Text(
              "Last updated: ${DateFormat('hh:mm a').format(_lastUpdated!)}",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _city,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Display the last updated time if it's available
            if (_lastUpdated != null)
              Text(
                ' ${DateFormat(' HH:mm:ss yyyy-MM-dd').format(_lastUpdated!)}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            SizedBox(height: 10),
            Text(
              _weatherIcon,
              style: TextStyle(fontSize: 64),
            ),
            SizedBox(height: 10),
            Text(
              _temperature != null 
                  ? '${_temperature!.toStringAsFixed(1)}°C' 
                  : 'Loading...',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 10),
            Text(
              _weatherDescription,
              style: TextStyle(fontSize: 24, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            _extraInfo(),
          ],
        ),
      ),
    ),
  );
}
}
