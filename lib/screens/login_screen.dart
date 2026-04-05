import 'package:flutter/material.dart';
import 'dart:developer' as developer;

enum UserType { customer, technician }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserType? _selectedUserType; // لتخزين اختيار المستخدم
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a user type")),
      );
      return;
    }

    developer.log("Login clicked");
    developer.log("Name: ${_nameController.text}");
    developer.log("Password: ${_passwordController.text}");
    developer.log("User type: $_selectedUserType");

  }

  void _goToRegister() {
    developer.log("Go to Register");
    
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 16,
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "FixItJo",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 20),

               
              Row(
                children: [
                  Expanded(
                    child: _buildUserTypeCard("Customer", UserType.customer, Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildUserTypeCard("Technician", UserType.technician, Colors.green),
                  ),
                ],
              ),

              const SizedBox(
                width: 150,
                height: 40),

              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text("Login"),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: _goToRegister,
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
