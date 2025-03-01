import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

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
        primaryColor: Colors.red,
        buttonTheme: LoginButtonTheme(
          backgroundColor: Colors.redAccent,
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
