
import 'package:flutter/material.dart';

class HumidityCard extends StatefulWidget {
  final String title;
  final String description;

  const HumidityCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<HumidityCard> createState() => _HumidityCardState();
}

class _HumidityCardState extends State<HumidityCard> {
  int _humidity = 60;
  bool isOn = true;

  void increaseHumidity() {
    setState(() {
      _humidity++;
    });
  }

  void togglePower() {
    setState(() {
      isOn = !isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange,
              child: Text(
                '$_humidity%',
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
        
        ElevatedButton(
          
          style: ElevatedButton.styleFrom(elevation: 10),
          onPressed: increaseHumidity,
          child: const Text("Arroser"),
        ),
        const SizedBox(height: 20),
        
      ],
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
  bool isOn = true;

  void togglePower() {
    setState(() {
      isOn = !isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More About"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Additional details about the marker",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
          // Pass actual values for `title` and `description`
          HumidityCard(
            title: "Humidity Data",
            description: "Current humidity information for Zone 1",
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 10),
            onPressed: () {
              print("Historique");
            },
            child: const Text("History"),
          ),
            const SizedBox(height: 20),
            Text(
              isOn ? "Turn OFF" : "Turn ON",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isOn ? Colors.green : Colors.red,
              ),
            ),
            Icon(
              Icons.power,
              size: 40,
              color: isOn ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 10),
            Switch(
              value: isOn,
              onChanged: (value) {
                setState(() {
                  isOn = value;
                });
              },
              activeColor: const Color.fromARGB(255, 39, 137, 176),
              inactiveThumbColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

