import 'dart:async';
import 'dart:io';
import 'package:fixitjo_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'technician_home_screen.dart';

class OtpScreen extends StatefulWidget {
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
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int seconds = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  Widget buildOtpBox(int index) {
    return Container(
      width: 55,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextField(
            controller: controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(color: Colors.transparent),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: "",
            ),
            onChanged: (_) => setState(() {}),
          ),
          Text(
            controllers[index].text.isEmpty ? "-" : controllers[index].text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void goNext() {
    if (widget.userType == UserType.customer) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ), //MaterialPageRoute(builder: (_) => const TechnicianHomePage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build, color: Color(0xFF0F5D75)),
            SizedBox(width: 8),
            Text(
              "FixIt Jo",
              style: TextStyle(
                color: Color(0xFF0F5D75),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB0D3E0),
              ),
              child: const Icon(
                Icons.build,
                size: 40,
                color: Color(0xFF0F5D75),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Verify Your Number",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter the 6-digit code sent to ${widget.phone}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) => buildOtpBox(index)),
            ),
            const SizedBox(height: 30),
            Text("Resend in ${seconds}s"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: goNext,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F5D75), Color(0xFF4FA3C7)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Center(
                    child: Text(
                      "Verify →",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
