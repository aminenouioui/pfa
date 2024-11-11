import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomButton(
              icon: Icons.group,
              text: 'Utilisateurs',
              onTap: () {
                // Navigate to the GestionUtilisateur page
                Navigator.pushNamed(
                  context,'/gestion');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap; // Add onTap callback

  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap, // Require the onTap parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Use GestureDetector to detect taps
      onTap: onTap, // Call the onTap callback when tapped
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(text),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}