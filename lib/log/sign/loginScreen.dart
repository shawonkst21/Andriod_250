import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    await Future.delayed(loginTime); // Simulate network delay
    return null; // Login successful (no actual authentication)
  }

  Future<String?> _signupUser(SignupData data) async {
    await Future.delayed(loginTime);
    return null; // Signup successful (no actual authentication)
  }

  Future<String?> _recoverPassword(String name) async {
    await Future.delayed(loginTime);
    return null; // Password recovery successful
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'LifeDrop',
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        primaryColor: Colors.red, // Solid Red Background
        titleStyle: GoogleFonts.bebasNeue(
          // Apply Lobster font to title
          fontSize: 45,
          color: Colors.white,
        ),
        bodyStyle: GoogleFonts.poppins(
          // Apply Poppins font to body text
          fontSize: 16,
          color: const Color.fromARGB(255, 15, 0, 0),
        ),
        textFieldStyle: GoogleFonts.poppins(
          // Font style for input fields
          fontSize: 16,
          color: Colors.black,
        ),
        buttonTheme: LoginButtonTheme(
          backgroundColor: Colors.redAccent, // Button color
        ),
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: const Text('Welcome to LifeDrop!')),
    );
  }
}
