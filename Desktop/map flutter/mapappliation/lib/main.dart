import 'package:flutter/material.dart';
import 'package:mapappliation/map_screen.dart'; // Import your MapScreen
import 'weather.dart'; // Import your WeatherScreen
import 'hum.dart'; // Import your WeatherScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/weather': (context) => WeatherScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);

  void _navigateToPage(int pageIndex) {
    _pageController.jumpToPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map View'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPage(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Weather'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPage(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('History'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPage(2);
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          MapScreen(),
          WeatherScreen(),
          // Add more screens if needed
        ],
      ),
    );
  }
}
