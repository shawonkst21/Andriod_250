import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BloodDonationCards extends StatelessWidget {
  const BloodDonationCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 130,
            height: 90,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/background.jpg'), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Age",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Requirement",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        )
                      ],
                    ),
                    Icon(Icons.date_range_outlined)
                  ],
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  "18-65 Ages",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color.fromARGB(255, 125, 11, 2)),
                )
              ],
            ),
          ),
          Container(
            width: 130,
            height: 94,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/background.jpg'), // Replace with your image
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  // offset: const Offset(0, 9),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Minimum",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "weight",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.man, size: 40)
                  ],
                ),
                SizedBox(
                  height: 1,
                ),
                Text("50 KG",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color.fromARGB(255, 125, 11, 2)))
              ],
            ),
          ),
          Container(
            width: 130,
            height: 90,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/background.jpg'), // Replace with your image
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gap between",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "Donation",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              Icons.date_range_outlined,
                              size: 17,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 1,
                ),
                Text("3 Months",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color.fromARGB(255, 125, 11, 2)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
