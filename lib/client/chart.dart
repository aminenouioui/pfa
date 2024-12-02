import 'dart:convert';  // To decode JSON string
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // List to hold the humidity data from Firestore
  List<charts.Series<HumidityData, String>>? _chartData;

  @override
  void initState() {
    super.initState();
    _fetchHumidityData();
    _startPeriodicUpdates();
  }

  // Fetch data from Firestore
  Future<void> _fetchHumidityData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('sensor_humidity')  // Your collection name
        .orderBy('timestamp')  // Sort by timestamp
        .get();

    List<HumidityData> humidityDataList = [];

    // Map Firestore data into a list of HumidityData objects
    for (var doc in querySnapshot.docs) {
      final payload = doc['payload'];  // This is the JSON string
      final timestamp = doc['timestamp'];

      // Decode the payload to extract the humidity value
      final Map<String, dynamic> payloadData = json.decode(payload);
      final humidity = payloadData['humidity'];  // Extract the humidity value

      // Ensure humidity is an integer
      int humidityValue = 0;
      if (humidity is String) {
        humidityValue = int.tryParse(humidity) ?? 0;
      } else if (humidity is int) {
        humidityValue = humidity;
      }

      // If timestamp is a string, convert it to DateTime
      DateTime time = DateTime.parse(timestamp);

      // Format the timestamp into a string (hour:minute format, no seconds or subseconds)
      String formattedTime = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";  // Hour:Minute

      // Add the data to the list
      humidityDataList.add(HumidityData(
        formattedTime,  // Use formatted time for x-axis
        humidityValue,
      ));
    }

    setState(() {
      _chartData = [
        charts.Series<HumidityData, String>(
          id: 'Humidity',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (HumidityData humidity, _) => humidity.day, // X-axis: formatted time
          measureFn: (HumidityData humidity, _) => humidity.value, // Y-axis: humidity value
          data: humidityDataList,
        ),
      ];
    });
  }

  // Start periodic updates for dynamic chart
  void _startPeriodicUpdates() {
    // Fetch data periodically (e.g., every 10 seconds)
    Future.delayed(Duration(seconds: 10), () {
      _fetchHumidityData();  // Re-fetch data
      _startPeriodicUpdates();  // Continue fetching periodically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Soil Moisture History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            // Check if data is loaded
            _chartData == null
                ? const CircularProgressIndicator()
                : Expanded(
                    child: charts.BarChart(
                      _chartData!,
                      animate: true,
                      animationDuration: Duration(seconds: 1), // Animation duration
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class HumidityData {
  final String day;  // This will hold the timestamp or date
  final int value;   // This will hold the humidity value

  HumidityData(this.day, this.value);
}
