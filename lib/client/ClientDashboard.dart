import 'package:flutter/material.dart';
import 'weather.dart';
import 'map_screen.dart';

class ClientDashboard extends StatefulWidget {
  @override
  _ClientDashboardState createState() => _ClientDashboardState();
  const ClientDashboard({super.key});
}

class _ClientDashboardState extends State<ClientDashboard> {
  // To track which screen is being shown
  Widget _currentScreen = const MapScreen();

  // Method to change the current screen
  void _updateScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Dashboard'),
        backgroundColor: Colors.blue,
      ),
      // Adding the drawer to the Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header (Optional)
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Client Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // List of items in the drawer
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Access Map'),
              onTap: () {
                // Close the drawer and update the screen to Map
                Navigator.pop(context); 
                _updateScreen(const MapScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Access Weather'),
              onTap: () {
                // Close the drawer and update the screen to Weather
                Navigator.pop(context); 
                _updateScreen(const WeatherScreen());
              },
            ),
            // You can add more items here
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout functionality here
                _logout(context); // Close the drawer
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
