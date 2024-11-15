import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text('Historique Température & Humidité'),
        centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      body: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LineChartWidget(),
      ),
    );
  }
}

class Titles {
  static getTitleData() => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 35,
        getTitlesWidget: (value, meta) {
          if (value % 1 == 0) {
            return Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text('${value.toInt()}h', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          }
          return Container();
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return Padding(
            padding: EdgeInsets.only(right: 5),
            child: Text('${value.toInt()}°', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
          );
        },
        reservedSize: 35,
      ),
    ),
  );
}

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColorsTemperature = [
    Colors.redAccent,
    Colors.orangeAccent,
  ];
  final List<Color> gradientColorsHumidity = [
    Colors.blueAccent,
    Colors.lightBlueAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 24,
        minY: 0,
        maxY: 100,
        titlesData: Titles.getTitleData(),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800],
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[800]!, width: 2),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _generateTemperatureData(),
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColorsTemperature,
            ),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColorsTemperature.map((color) => color.withOpacity(0.4)).toList(),
              ),
            ),
          ),
          LineChartBarData(
            spots: _generateHumidityData(),
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColorsHumidity,
            ),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColorsHumidity.map((color) => color.withOpacity(0.2)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateTemperatureData() {
    List<FlSpot> spots = [];
    Random random = Random();
    for (int i = 0; i <= 24; i++) {
      double temp = 15 + random.nextDouble() * 15; // Température entre 15°C et 30°C
      spots.add(FlSpot(i.toDouble(), temp));
    }
    return spots;
  }

  List<FlSpot> _generateHumidityData() {
    List<FlSpot> spots = [];
    Random random = Random();
    for (int i = 0; i <= 24; i++) {
      double humidity = 40 + random.nextDouble() * 60; // Humidité entre 40% et 100%
      spots.add(FlSpot(i.toDouble(), humidity));
    }
    return spots;
  }
}
