import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  await initNotifications();
  
  // Set up Firebase messaging for background/foreground notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MainApp());
}

// Create an instance of the plugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialize the local notifications plugin
Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
    // Handle the notification response when the app is in the foreground
    onSelectNotification(notificationResponse.payload);
  });
}

// Background handler for Firebase Messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Show the notification or handle the message as needed
  showNotification("Background Notification", message.notification?.body ?? "New background message");
}

// Function to handle notification click (when the app is in the background or closed)
Future<void> onSelectNotification(String? payload) async {
  if (payload != null) {
    print('Notification payload: $payload');
    // Example: Navigate to a specific page
    // Navigator.pushNamed(context, '/specificPage');
  }
}

// Function to show a notification
Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id', // Channel ID
    'Reservoir Notifications', // Channel name
    channelDescription: 'Notifications for the reservoir water level',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title, // Title
    body, // Body
    platformDetails, // Notification details
    payload: 'Reservoir Level Below 30%', // Optional payload
  );
}

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
