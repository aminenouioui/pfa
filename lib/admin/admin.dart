import 'package:flutter/material.dart';
import 'package:projet/admin/useraddform.dart' as form;
import 'gestionutilisateurs.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Default body widget
  Widget _currentScreen = const GestionUtilisateur(); // Default screen

  // Method to update the body content dynamically
  void _updateScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  // Logout function
  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
            color: Colors.black,
          ),
        ],
      ),
      // Drawer for navigation
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context);
                _updateScreen(const GestionUtilisateur());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add User'),
              onTap: () {
                Navigator.pop(context);
                _updateScreen(const form.UserAdd());
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _updateScreen(const SettingsPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: _currentScreen, // Display the selected screen
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Screen')),
    );
  }
}
