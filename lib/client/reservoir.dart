import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projet/main.dart';

class ReservoirPage extends StatefulWidget {
  @override
  _RealReservoirPageState createState() => _RealReservoirPageState();
}

class _RealReservoirPageState extends State<ReservoirPage> {
  double waterPercentage = 75; // Example starting percentage

  // Function to show notification when water level is below 30%
  void checkWaterLevelAndNotify() {
    if (waterPercentage < 30) {
      showNotification("Warning", "The water level is below 30%!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Reservoir View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Reservoir Background
                Container(
                  width: 200,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 3),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                ),
                // Water Fill
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: 200,
                    height: 400 * (waterPercentage / 100), // Dynamic height
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade700,
                          Colors.blue.shade300,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Percentage Label
                Positioned(
                  top: 180, // Adjust based on design
                  child: Text(
                    '${waterPercentage.toInt()}%',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Slider to Simulate Changes
            Slider(
              value: waterPercentage,
              min: 0,
              max: 100,
              divisions: 100,
              label: "${waterPercentage.toInt()}%",
              onChanged: (newValue) {
                setState(() {
                  waterPercentage = newValue;
                });
                // Check if water level is below 30% and show notification
                checkWaterLevelAndNotify();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a notification
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id', // Channel ID
      'Reservoir Notifications', // Channel name
      channelDescription: 'Notifications for the reservoir water level',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Title
      body, // Body
      platformDetails, // Notification details
      payload: 'Reservoir Level Below 30%', // Optional payload
    );
  }
}
