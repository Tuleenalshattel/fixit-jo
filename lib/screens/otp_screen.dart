import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'technician_home_screen.dart';
import 'admin_screen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;
  final String role;
  final List<String> specializations;
  final int experience;
  final File? profileImage;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.name,
    required this.role,
    this.specializations = const [],
    this.experience = 0,
    this.profileImage,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
    final lang = Provider.of<AppLanguage>(context, listen: false);

    final otp = getOtp();

    if (otp.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.enter6DigitCode)));
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

      /// 1. Save user FIRST
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': widget.name,
          'phone': widget.phoneNumber,
          'role': widget.role,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      /// 2. If technician save extra data
      if (widget.role == 'technician') {
        String? imageUrl;

        if (widget.profileImage != null) {
          final ref = FirebaseStorage.instance.ref().child(
            'technicians/$uid/profile.jpg',
          );
          await ref.putFile(widget.profileImage!);
          imageUrl = await ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('technicians')
            .doc(uid)
            .set({
              'name': widget.name,
              'phone': widget.phoneNumber,
              'specializations': widget.specializations,
              'experience': widget.experience,
              'isVerified': false,
              'available': false,
              'ratingAverage': 0.0,
              'jobsDone': 0,
              'ratingCount': 0,
              'imageUrl': imageUrl ?? '',
              'createdAt': FieldValue.serverTimestamp(),
            });

        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': 'admin',

          'title': lang.newTechnicianRegistration,

          'body': lang.newTechnicianRegistrationBody(widget.name),

          'type': 'new_technician',

          'isRead': false,

          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      final role = userDoc.exists
          ? (userDoc.data() as Map<String, dynamic>)['role'] ?? widget.role
          : widget.role;
      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AdminScreen()),
          (route) => false,
        );
      } else if (role == 'technician') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(lang.adminapproval)));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
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
      ).showSnackBar(SnackBar(content: Text(lang.invalidOtp)));
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
    final lang = Provider.of<AppLanguage>(context);
    const boxSize = 45.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(lang.OTPverification),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                lang.enterCodeSentTo(widget.phoneNumber),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              /// OTP BOXES
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

              Text(lang.resendIn(seconds)),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : verifyOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(lang.verify),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
