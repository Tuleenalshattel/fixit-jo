import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/logo1.png', width: 300, height: 300),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor: Colors.grey[300],
                  minHeight: 8,
                  valueColor: _controller.drive(
                    TweenSequence<Color?>([
                      TweenSequenceItem(
                        tween: ColorTween(
                          begin: Colors.lightBlueAccent,
                          end: Colors.blueAccent,
                        ),
                        weight: 50,
                      ),
                      TweenSequenceItem(
                        tween: ColorTween(
                          begin: Colors.blueAccent,
                          end: Colors.blue,
                        ),
                        weight: 50,
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          FadeTransition(
            opacity: _controller,
            child: const Text(
              "Loading...",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
