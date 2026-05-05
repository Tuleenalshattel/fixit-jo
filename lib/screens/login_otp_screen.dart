import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'technician_home_screen.dart';
import 'admin_screen.dart';

class LoginOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const LoginOtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  int seconds = 30;
  Timer? timer;
  bool _isLoading = false;

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
        setState(() => seconds--);
      }
    });
  }

  String getOtp() => controllers.map((c) => c.text).join();

  Future<void> verifyOtp() async {
    final otp = getOtp();

    if (otp.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter 6-digit code")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final uid = userCredential.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final role = userDoc.data()?['role'] ?? 'customer';

      if (!mounted) return;

      // 🔥 FIXED LOGIC HERE
      if (role == 'admin') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AdminScreen()),
          (route) => false,
        );
      } else if (role == 'technician') {
        final techDoc = await FirebaseFirestore.instance
            .collection('technicians')
            .doc(uid)
            .get();

        final isVerified = techDoc.data()?['isVerified'] == true;

        if (!isVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your account is pending admin approval"),
            ),
          );
          return;
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const TechnicianHomeScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const boxSize = 45.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("OTP Verification"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                "Enter code sent to ${widget.phoneNumber}",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: boxSize,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ""),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              Text("Resend in $seconds s"),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : verifyOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
