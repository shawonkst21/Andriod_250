import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AllButtonForBloodDonation extends StatefulWidget {
  const AllButtonForBloodDonation({super.key});

  @override
  State<AllButtonForBloodDonation> createState() =>
      _AllButtonForBloodDonationState();
}

class _AllButtonForBloodDonationState extends State<AllButtonForBloodDonation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //!first two button urgent request and find donar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 130,
                  width: 160,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                // "Urgent Requests" Text
                Positioned(
                  top: 16,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Urgent",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                      Text(
                        "Requests",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                    ],
                  ),
                ),

                // View Button with Animation
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      // Handle view button tap
                    },
                    child: AnimatedContainer(
                      //width: 30,
                      duration: Duration(milliseconds: 300),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white, // Outline color
                          width: 2, // Outline width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.4),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "View",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Right Side Icon (Blood drop with alert)
                Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Lottie.asset(
                      'assets/emergency.json',
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Stack(
              children: [
                Container(
                  height: 130,
                  width: 160,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                // "Urgent Requests" Text
                Positioned(
                  top: 16,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                      Text(
                        "Donar",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                    ],
                  ),
                ),

                // View Button with Animation
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/findDonor');
                      setState(() {
                        // Add effect or animation logic here
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white, // Outline color
                          width: 2, // Outline width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.5),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Find",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Right Side Icon (Blood drop with alert)
                Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Lottie.asset(
                      'assets/search.json',
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 130,
                  width: 160,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                // "Urgent Requests" Text
                Positioned(
                  top: 20,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                      Text(
                        "Organization",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                    ],
                  ),
                ),

                // View Button with Animation
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      // Handle view button tap
                    },
                    child: AnimatedContainer(
                      //width: 30,
                      duration: Duration(milliseconds: 300),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white, // Outline color
                          width: 2, // Outline width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.4),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Search",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Right Side Icon (Blood drop with alert)
                Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Lottie.asset(
                      'assets/emergency.json',
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Stack(
              children: [
                Container(
                  height: 130,
                  width: 160,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                // "Urgent Requests" Text
                Positioned(
                  top: 16,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nearby",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                      Text(
                        "Requests",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                    ],
                  ),
                ),

                // View Button with Animation
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      // Handle view button tap
                      setState(() {
                        // Add effect or animation logic here
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white, // Outline color
                          width: 2, // Outline width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.5),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "View",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Right Side Icon (Blood drop with alert)
                Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    height: 100,
                    width: 90,
                    child: Lottie.asset(
                      'assets/nearby.json',
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
