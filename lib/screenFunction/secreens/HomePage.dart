import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/Fcm_sender.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/buttonfunction.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/donateContainer.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/firstWelcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    saveFCMToken();
  }

  Future<void> saveFCMToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fcmToken': token,
        }, SetOptions(merge: true));
        print("✅ FCM token saved to Firestore for user: ${user.uid}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            IconButton(
              icon: Icon(Icons.notifications_none),
              color: Colors.red,
              iconSize: 30,
              onPressed: () {
                // Handle notification tap
              },
            ),
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
            AllButtonForBloodDonation(),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
            SizedBox(
              height: 30,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/blood_board.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
     floatingActionButton: FloatingActionButton(
  onPressed: () async {
    await sendNotificationUsingV1API(
      "Urgent Need",
      "Blood required urgently near your area!",
    );
    print("🚀 Notification sent!");
  },
  child: Icon(Icons.send), // or any icon you like
  tooltip: "Send Urgent Alert",
),

    );
  }
}
