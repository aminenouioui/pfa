import 'package:flutter/material.dart';
import 'package:projet/admin/useraddform.dart' as form;

class GestionUtilisateur extends StatefulWidget {
  const GestionUtilisateur({super.key});

  @override
  _GestionUtilisateurState createState() => _GestionUtilisateurState();
}

class _GestionUtilisateurState extends State<GestionUtilisateur> {
  // Tracks the current screen displayed in the body
  Widget _currentScreen = const UserMenu(); // Default to the main menu

  // Method to switch screens
  void _updateScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _currentScreen,
    );
  }
}

// Main menu for admin
class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomButton(
            icon: Icons.add,
            text: 'Add New User',
            onTap: () {
              // Switch to UserAdd screen
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const form.UserAddForm()),
              );
            },
          ),
          const SizedBox(height: 16),
          CustomButton(
            icon: Icons.list,
            text: 'Users List',
            onTap: () {
              // Implement logic for displaying user list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Users List is under construction')),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom reusable button
class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
