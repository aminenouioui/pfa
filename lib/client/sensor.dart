import 'dart:convert';  // For JSON parsing
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Firebase Firestore
import 'package:charts_flutter/flutter.dart' as charts;

import 'reservoir.dart';  // For charts

class HumidityCard extends StatefulWidget {
  const HumidityCard({super.key});

  @override
  State<HumidityCard> createState() => _HumidityCardState();
}

class _HumidityCardState extends State<HumidityCard> {
  int _humidity = 0; // Default humidity value

  @override
  void initState() {
    super.initState();
    // Listen for real-time updates on the Firestore collection
    _listenToHumidityData();
  }

  // Real-time listener for humidity data in Firestore
  void _listenToHumidityData() {
    FirebaseFirestore.instance
        .collection('sensor_humidity')  // Your Firestore collection
        .orderBy('timestamp', descending: true) // Order by timestamp
        .limit(1)  // Limit to the most recent document
        .snapshots()  // Real-time updates
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var docData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Parse the humidity from the payload
        var payload = docData['payload']; // This is the raw payload string
        if (payload != null) {
          // Decode the JSON string stored in the payload
          var decodedJson = jsonDecode(payload); // Decode the string to a JSON object

          // Extract humidity from the decoded JSON object
          var humidity = decodedJson['humidity'];  
          if (humidity != null) {
            setState(() {
              // If humidity is a number, use it directly
              if (humidity is num) {
                _humidity = humidity.toInt();  // Ensure it's an integer
              } else {
                _humidity = 0;  // Default to 0 if the data is not valid
              }
            });
          }
        }
      } else {
        print("No data found in Firestore");  // If no data is returned
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Humidity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                '$_humidity%',  // Display humidity dynamically
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Humidity History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: charts.BarChart(
                _createSampleData(),
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<charts.Series<HumidityData, String>> _createSampleData() {
    final data = [
      HumidityData('Mon', 60),
      HumidityData('Tue', 65),
      HumidityData('Wed', 70),
      HumidityData('Thu', 55),
      HumidityData('Fri', 75),
    ];

    return [
      charts.Series<HumidityData, String>( 
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HumidityData humidity, _) => humidity.day,
        measureFn: (HumidityData humidity, _) => humidity.value,
        data: data,
      ),
    ];
  }
}

class HumidityData {
  final String day;
  final int value;

  HumidityData(this.day, this.value);
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(  
      body: Center(
        child: Text(
          'Settings Page Content',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class CptPage extends StatefulWidget {
  const CptPage({super.key});

  @override
  State<CptPage> createState() => _CptPageState();
}

class _CptPageState extends State<CptPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HumidityCard(),
    const HistoryPage(),
    ReservoirPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Humidity App'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Sensor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'ReservoirPage',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
