import 'package:fixitjo_app/screens/map_screen.dart';
import 'package:fixitjo_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'screens/chatbot_screen.dart';
import 'screens/splash_screen.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'screens/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //await FirebaseService.initialize();
  Gemini.init(apiKey: 'AIzaSyDELQbUOhChvv1ueGe5XAGXZFZwvFh1qG4');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixItJo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
