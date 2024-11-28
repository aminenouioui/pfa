import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HumidityCard extends StatefulWidget {
  const HumidityCard({super.key});

  @override
  State<HumidityCard> createState() => _HumidityCardState();
}

class _HumidityCardState extends State<HumidityCard> {
  int _humidity = 60;

  void increaseHumidity() {
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: increaseHumidity,
          child: const Text(
            'Arroser',
            style: TextStyle(color: Colors.white),
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
class HumidityData {
  final String day;
  final int value;

  HumidityData(this.day, this.value);
}

class CptPage extends StatefulWidget {
  const CptPage({super.key});

  @override
  State<CptPage> createState() => _CptPageState();
}

class _CptPageState extends State<CptPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HumidityCard(),
    HistoryPage(),
    SettingsPage(),
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
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
