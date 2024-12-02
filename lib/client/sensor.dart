import 'dart:convert';  // For JSON parsing
import 'package:firebase_auth/firebase_auth.dart';
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
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
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

 Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }



void _sendTimingToFirestore(String markerId) async {
  // Retrieve the currently logged-in user's ID
  final User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User not logged in."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final userId = user.uid; // Get the logged-in user's ID

  if (_startTime == null || _endTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please select both start and end times."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    // Save timing data to Firestore under the user's account and specific marker
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId) // User document
        .collection('markers')
        .doc(markerId) // Marker document
        .collection('irrigation_timing') // Timing subcollection
        .add({
      'start_time': _startTime!.format(context), // Format time for better readability
      'end_time': _endTime!.format(context),
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Timing saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error saving timing: $e"),
        backgroundColor: Colors.red,
      ),
    );
    print("Error saving timing: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
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
                '$_humidity%', // Display humidity dynamically
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Buttons
        Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                print("Arroser pressed");
              },
              icon: const Icon(Icons.water, color: Colors.white),
              label: const Text(
                "Arroser",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                print("Stop Arroser pressed");
              },
              icon: const Icon(Icons.stop, color: Colors.white),
              label: const Text(
                "Stop Arroser",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Timing Zone
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "Set Irrigation Timing",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.access_time, size: 30, color: Colors.green),
                          onPressed: () => _selectTime(context, true),
                        ),
                        Text(
                          _startTime == null
                              ? "Start Time"
                              : _startTime!.format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.access_time_filled, size: 30, color: Colors.red),
                          onPressed: () => _selectTime(context, false),
                        ),
                        Text(
                          _endTime == null
                              ? "End Time"
                              : _endTime!.format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    const userId = "exampleUserId"; // Replace with actual user ID
                    _sendTimingToFirestore(userId); // Call the function with userId
                  },
                  child: const Text(
                    "Send Timing",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

              ],
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
            icon: Icon(Icons.add_box_sharp),
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
