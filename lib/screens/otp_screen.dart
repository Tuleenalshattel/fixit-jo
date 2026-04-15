import 'dart:io';
import 'package:fixitjo_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class OtpScreen extends StatelessWidget {
  final UserType userType;
  final String name;
  final String phone;
  final File? profileImage;

  const OtpScreen({
    super.key,
    required this.userType,
    required this.name,
    required this.phone,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Enter OTP code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                ),
                onPressed: () {
                  // 🔥 هون بنحدد حسب نوع المستخدم
                  if (userType == UserType.customer) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                        // لاحقًا نخليها TechnicianDashboard()
                      ),
                      (route) => false,
                    );
                  }
                },
                child: const Text("Verify"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
