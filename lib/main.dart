import 'package:blood_donar/introduceApp/onbroadingScreen.dart';
import 'package:blood_donar/log/sign/login.dart';
import 'package:blood_donar/screenFunction/secreens/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
          Color.fromARGB(255, 255, 255, 255), //! Set the color you want
      statusBarIconBrightness: Brightness.dark, //! White icons
    ),
  );

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
        '/home': (context) => const Homepage(),
      },
    );
  }
}
