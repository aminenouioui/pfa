import 'package:flutter/material.dart';
import 'package:iot_project/admin.dart';
import 'package:iot_project/gestionutilisateurs.dart';
import 'package:iot_project/user.dart';
import 'package:iot_project/useraddform.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
      home: const Scaffold(
        body: AdminPage(),
      ),
      routes: {
        '/admin': (context) => const AdminPage(),
        '/user' : (context) => const CptPage(),
        '/gestion' :(context) => const GestionUtilisateur(),
        '/useraddform' : (context) => UserAdd(),
        
      },
    );
  }
}
