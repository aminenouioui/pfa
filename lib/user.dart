import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
bottomNavigationBar: BottomAppBar(
  shape: const CircularNotchedRectangle(), // Adds a notch if using FAB
  color: Colors.blue[800], // Background color of the BottomAppBar
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // History Button
        ElevatedButton.icon(
          onPressed: () {
            // Action for History
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Button text color
            backgroundColor: Colors.blue[600], // Button background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
          ),
          icon: const Icon(Icons.history, size: 18),
          label: const Text(
            'History',
            style: TextStyle(fontSize: 16),
          ),
        ),

        // Add Another Button (Optional)
        ElevatedButton.icon(
          onPressed: () {
            // Action for another button
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Button text color
            backgroundColor: Colors.blue[600], // Button background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
          ),
          icon: const Icon(Icons.settings, size: 18),
          label: const Text(
            'Settings',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              Text(
                "Area N",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 8),
              // Sensor ID
              const Text(
                'Sensor ID: 12345',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Humidity Card
              const HumidityCard(),
               ],
          ),
        ),
      ),
    );
  }
}

class HumidityCard extends StatefulWidget {
  const HumidityCard({super.key});

  @override
  State<HumidityCard> createState() => _HumidityCardState();
}

class _HumidityCardState extends State<HumidityCard> {
  var humidity = 60;

  void changeHumidity() {
    setState(() {
      humidity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Humidity Text
            Text(
              'Humidity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),

            // Circular Shape with Humidity Value
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[100], // Light blue background
                border: Border.all(
                  color: Colors.blue, // Border color
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  '$humidity%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Button
            ElevatedButton(
              onPressed: () {
                changeHumidity();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Button text color
                backgroundColor: Colors.blue[600], // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
              child: const Text(
                'Arroser',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
