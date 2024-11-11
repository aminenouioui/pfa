
import 'package:flutter/material.dart';

class HumidityCard extends StatefulWidget {
  const HumidityCard({super.key});

  @override
  State<HumidityCard> createState() => _HumidityCardState();
}

class _HumidityCardState extends State<HumidityCard> {
  int _humidity = 60;
  void increaseHumididty() {
    setState(() {
      _humidity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Humidity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
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
              backgroundColor: Colors.deepOrange,
              child: Text(
                '$_humidity% ',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 10),
            onPressed: increaseHumididty,
            child: const Text("Arroser"))
      ],
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
    return Center(
      child: Column(
        children: [
          const Column(
            children: [
              Text(
                "Zone 1",
                style: TextStyle(
                  fontSize: 24, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                  color: Colors.deepOrange, // Text color
                ),
              ),
              Text(
                "ID : 1234567879",
                style: TextStyle(
                  fontSize: 14, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                  color: Colors.deepOrange, // Text color
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const HumidityCard(),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 10),
              onPressed: (() {
                print("Historique");
              }),
              child: const Text("History")),
          const SizedBox(
            height: 20,
          ),
            Text(
            isOn ? "Turn OFF" : "Turn ON",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isOn ? Colors.green : Colors.red,
            )
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
    );
  }
}


