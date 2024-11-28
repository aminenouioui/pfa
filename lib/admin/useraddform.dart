import 'package:flutter/material.dart';

class UserAddForm extends StatefulWidget {
  const UserAddForm({super.key});

  @override
  _UserAddFormState createState() => _UserAddFormState();
}

class _UserAddFormState extends State<UserAddForm> {
  bool _obscureText = true;
  String _selectedRole = 'Admin'; // Default selection for dropdown

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomTextField(
                icon: Icons.person,
                hintText: 'Full Name',
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                icon: Icons.phone,
                hintText: 'Phone Number',
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                icon: Icons.email,
                hintText: 'E-mail',
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ['Admin', 'Client']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle user creation logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User created successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Button color
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;

  const CustomTextField({super.key, required this.icon, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
