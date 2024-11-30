import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'package:pfa/admin.dart';
import 'package:pfa/gestionutilisateurs.dart';
import 'package:pfa/login.dart';
import 'package:pfa/user.dart';
import 'package:pfa/useraddform.dart';
import 'package:pfa/userlist.dart';

void main() async {
  // Ensure Firebase is initialized before the app runs
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

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
      home: Scaffold(
        body: LoginScreen(),
      ),
      routes: {
        '/Login' : (context) => LoginScreen(),
        '/admin': (context) => const AdminPage(),
        '/user' : (context) => const CptPage(),
        '/gestion' :(context) => const GestionUtilisateur(),
        '/useraddform' : (context) => UserAdd(),
        '/userlist' : (context) => const UserListScreen(),

      },
    );
  }
}
