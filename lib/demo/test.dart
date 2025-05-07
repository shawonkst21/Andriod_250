import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
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
          icon: Icon(Icons.notifications_active_outlined),
          color: Colors.red,
          iconSize: 30,
          onPressed: () {
            // Handle notification tap
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Doctor greeting container with overlapping image
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Main background container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 8,
                    bottom: 16,
                    right: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CircleAvatar(
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Mr.Shawon",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 125, 11, 2),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Ready to save a life today?'",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                    ],
                  ),
                ),

                // Overlapping doctor image
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
            ),
//!....................................................
            SizedBox(height: 20),

            // Title
            Text(
              "Who can Donate Blood?",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),

            // Optional horizontal scrollable cards or more widgets can go here
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Container 1",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Container 2",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Container 3",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
