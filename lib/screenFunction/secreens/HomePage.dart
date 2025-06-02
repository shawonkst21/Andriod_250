import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/buttonfunction.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/donateContainer.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/firstWelcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*  title: Text(
          "Life Drop",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 125, 11, 2)),
        ),*/
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.notifications_none),
          color: Colors.red,
          iconSize: 30,
          onPressed: () {
            // Handle notification tap
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! first welcome Container and code in extra code folder and file name firstwelcome.dart
            WelcomeHomepage(),
            SizedBox(height: 20),

            //! Title
            Text(
              "Who can Donate Blood?",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            //! condition for blood donate
            BloodDonationCards(),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
            SizedBox(height: 10),
            AllButtonForBloodDonation()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => signOut()),
      
    );
  }
}
