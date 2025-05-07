import 'package:blood_donar/log/sign/login.dart';
import 'package:blood_donar/screenFunction/bottomNavigatorBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class warpper extends StatefulWidget {
  const warpper({super.key});

  @override
  State<warpper> createState() => _warpperState();
}

class _warpperState extends State<warpper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Bottomnavigatorbar();
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
