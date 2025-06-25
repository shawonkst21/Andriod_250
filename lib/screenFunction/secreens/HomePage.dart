import 'dart:async';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/firstportionOf_homePage/buttonfunction.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/firstportionOf_homePage/donateContainer.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/firstportionOf_homePage/firstWelcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    saveFCMToken();
    _pageController = PageController(initialPage: 0);
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      int nextPage = (_currentPage + 1) % 3; // Calculate next page index
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                int notifCount = snapshot.data?.docs.length ?? 0;

                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        notifCount > 0
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_none_outlined,
                      ),
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pushNamed(context, '/NotificationScreen');
                      },
                    ),
                    if (notifCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$notifCount',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
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
            SizedBox(height: 8),
            AllButtonForBloodDonation(),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),

            Text(
              "Event:",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 180,
              //width: 200,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page; // Update _currentPage on page change
                  });
                },
                children: [
                  _buildCarouselItem(
                    imagePath: 'assets/event3.jpg',
                    discountText: '🗓️Date:24 June',
                    description: 'Together, we can  \nmake a difference!',
                  ),
                  _buildCarouselItem(
                    imagePath: 'assets/event2.jpg',
                    discountText: '🗺️Sust,A building',
                    description: 'Be the reason \nsomeone smiles again ',
                  ),
                  _buildCarouselItem(
                    imagePath: 'assets/event1.jpeg',
                    discountText: 'Date:05 july',
                    description: 'we’re not \njust donating blood',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8,
                  width: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.pink : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
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
              height: 10,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chatbot');
        },
      ),
    );
  }

  Widget _buildCarouselItem({
    required String imagePath,
    required String discountText,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.2),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  discountText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('View details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
