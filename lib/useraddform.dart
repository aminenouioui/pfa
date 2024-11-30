import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAdd extends StatefulWidget {
  @override
  _UserAddState createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String? _selectedRole;
  String? _name, _phone, _email, _password;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Create user in Firebase Authentication and Firestore
  Future<void> _createUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user in Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        // Store additional user data in Firestore
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'name': _name,
          'phone': _phone,
          'email': _email,
          'role': _selectedRole,
        });

        // Send a password reset email
        await _auth.sendPasswordResetEmail(email: _email!);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully! Password reset email sent.')),
        );

        // Optionally, navigate back to the previous screen or user list
        Navigator.pop(context);

      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Something went wrong';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'The email is already in use.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

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
          'Create New User',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                icon: Icons.person,
                hintText: 'Full Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  _name = value;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
  icon: Icons.phone,
  hintText: 'Phone Number',
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!value.startsWith('216')) {
      return 'Phone number must start with 216';
    }
    if (value.length != 11) {
      return 'Phone number must be 11 characters (including 216)';
    }
    final numericPart = value.substring(3); // Check if the rest is numeric
    if (!RegExp(r'^[0-9]{8}$').hasMatch(numericPart)) {
      return 'Phone number must contain exactly 8 digits after 216';
    }
    _phone = value;
    return null;
  },
),

              const SizedBox(height: 16),
              CustomTextField(
                icon: Icons.email,
                hintText: 'E-mail',
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  _email = value;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  _password = value;
                  return null;
                },
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
                    .map((role) => DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.icon,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
    );
  }
}
