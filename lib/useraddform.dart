import 'package:flutter/material.dart';
 
class UserAdd extends StatefulWidget {
  @override
  _UserAddState createState() => _UserAddState();
}
 
class _UserAddState extends State<UserAdd> {
  bool _obscureText = true;
  String _selectedRole = 'User'; // Default selection for dropdown
 
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          'Create New User',
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
            CustomTextField(
              icon: Icons.person,
              hintText: 'Full Name',
            ),
            SizedBox(height: 16),
            CustomTextField(
              icon: Icons.phone,
              hintText: 'Phone Number',
            ),
            SizedBox(height: 16),
            CustomTextField(
              icon: Icons.email,
              hintText: 'E-mail',
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
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
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: <String>['Admin', 'Client']
                  .map((String role) => DropdownMenuItem<String>(
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
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle the create button action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
 
class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
 
  CustomTextField({required this.icon, required this.hintText});
 
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