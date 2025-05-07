import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeHomepage extends StatefulWidget {
  const WelcomeHomepage({super.key});

  @override
  State<WelcomeHomepage> createState() => _WelcomeHomepageState();
}

class _WelcomeHomepageState extends State<WelcomeHomepage> {
  String firstName = '';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String fullName =
            doc['name'] ?? ''; // assuming your field is 'fullName'
        setState(() {
          firstName = fullName.split(' ').first;
        });
      }
    } catch (e) {
      print('Error fetching name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding:
              const EdgeInsets.only(left: 15, top: 8, bottom: 16, right: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/shawon.jpg'),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Hello,",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    firstName.isEmpty ? "..." : "Mr. $firstName",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 125, 11, 2),
                    ),
                  ),
                ],
              ),
              Text(
                "Ready to save a life today?",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 125, 11, 2),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          top: -40,
          child: Image.asset(
            'assets/doctor.png',
            fit: BoxFit.contain,
            height: 120,
          ),
        ),
      ],
    );
  }
}
