import 'package:blood_donar/introduceApp/onbroadingScreen.dart';
import 'package:blood_donar/log/sign/login.dart';
import 'package:flutter/material.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
      initialRoute: '/',
      routes: {
         '/login': (context) => const LoginPage(),
      },
    );
  }
}
