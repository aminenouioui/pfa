import 'package:flutter/material.dart';

class ReservoirPage extends StatefulWidget {
  @override
  _RealReservoirPageState createState() => _RealReservoirPageState();
}

class _RealReservoirPageState extends State<ReservoirPage> {
  double waterPercentage = 75; // Example starting percentage.

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
              },
            ),
          ],
        ),
      ),
    );
  }
}

