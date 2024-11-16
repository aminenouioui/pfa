import 'package:flutter/material.dart';
import 'package:iot_app/admin.dart';
import 'package:iot_app/login.dart';
import 'package:iot_app/user.dart';
import 'package:iot_app/weather.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
      home: const Scaffold(
        body: LoginPage(),
      ),
      routes: {
        '/admin': (context) => const AdminPage(),
        '/user' : (context) => const UserPage(),
        'weather' : (context) => const WeatherScreen(),
        
      },
    );
  }
}
