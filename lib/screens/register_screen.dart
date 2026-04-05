import 'package:flutter/material.dart';
import 'dart:developer' as developer;


enum UserType { customer, technician }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserType? _selectedUserType;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    developer.log("Register clicked");

    if (_selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select user type")),
      );
      return;
    }

    developer.log("First Name: ${_firstNameController.text}");
    developer.log("Last Name: ${_lastNameController.text}");
    developer.log("Email: ${_emailController.text}");
    developer.log("Password: ${_passwordController.text}");
    developer.log("User Type: $_selectedUserType");

   
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registration successful")),
    );

     
    Navigator.pop(context);
  }

  Widget _buildUserTypeCard(String title, UserType type, Color color) {
    bool isSelected = _selectedUserType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 10),

            const Text(
              "Register",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Create your FixItJo account",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // First + Last name
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 18),

            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 25),

            
            Row(
              children: [
                Expanded(
                  child: _buildUserTypeCard(
                      "Customer", UserType.customer, Colors.blue),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildUserTypeCard(
                      "Technician", UserType.technician, Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 180,
              height: 45,
              child: ElevatedButton(
                onPressed: _handleRegister,
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
