/*import 'package:flutter/material.dart';
import 'package:projet/admin/useraddform.dart' as form;

import 'gestionutilisateurs.dart'; // Replace with your actual page for /gestion route

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // To track which screen is being shown in the body
  Widget _currentScreen = const GestionUtilisateur();  // Default screen

  // Method to change the current screen
  void _updateScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

 // Inside AdminDashboard or ClientDashboard
  void _logout(BuildContext context) {
    // Pop all routes and navigate to the root (LoginScreen)
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
      ),
      // Adding the drawer to the Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Manage Users Option
            ListTile(
              leading: const Icon(Icons.group),
              title:const Text('Manage Users'),
              onTap: () {
                // Close the drawer and update the screen to GestionUtilisateur
                Navigator.pop(context); 
                _updateScreen(const GestionUtilisateur());
              },
            ),
            // Add User Option
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Add User'),
              onTap: () {
                // Close the drawer and update the screen to UserAdd
                Navigator.pop(context); 
                _updateScreen(const form.UserAddForm());
              },
            ),
            // Sales Option
            
            // Settings Option
            ListTile(
              leading:const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Close the drawer and update the screen to SettingsPage
                Navigator.pop(context); 
                _updateScreen(const SettingsPage());
              },
            ),
            // Logout Option
            ListTile(
              leading:const Icon(Icons.logout),
              title:const Text('Logout'),
              onTap: () {
                // Call logout method
                _logout(context);
              },
            ),
          ],
        ),
      ),
      // The body will be updated based on the selected screen
      body: _currentScreen,
    );
  }
}


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Settings')),
      body: const Center(child:Text('Settings Screen')),
    );
  }
}
*/