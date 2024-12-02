import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projet/admin/admin.dart';
import 'package:projet/admin/useraddform.dart';
import 'package:projet/admin/userlist.dart';
import 'package:projet/client/ClientDashboard.dart';
import 'package:projet/admin/gestionutilisateurs.dart';
import 'package:projet/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  // Initialize the local notifications plugin
  
  
  // Set up Firebase messaging for background/foreground notifications

  runApp(const MainApp());
}



// Initialize the local notifications plugin

// Background handler for Firebase Messaging


// Function to handle notification click (when the app is in the background or closed)
Future<void> onSelectNotification(String? payload) async {
  if (payload != null) {
    print('Notification payload: $payload');
    // Example: Navigate to a specific page
    // Navigator.pushNamed(context, '/specificPage');
  }
}

// Function to show a notification

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/Login', // Set the initial route to LoginScreen
      routes: {
        '/Login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminPage(),
        '/user': (context) => const ClientDashboard(),
        '/gestion': (context) => const GestionUtilisateur(),
        '/useraddform': (context) => const UserAdd(),
        '/userlist': (context) => const UserListScreen(),
        '/ClientDashboard': (context) => const ClientDashboard(),
      },
    );
  }
}
