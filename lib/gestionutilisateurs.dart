import 'package:flutter/material.dart';

class GestionUtilisateur extends StatelessWidget {
  const GestionUtilisateur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: const Text(
          'Users',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomButton(
              icon: Icons.add,
              text: 'Add New User',
              onTap: () {
                Navigator.pushNamed(
                  context,'/useraddform');
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              icon: Icons.list,
              text: 'Users List',
              onTap: () {
                print("users list ");
              },
            ),
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