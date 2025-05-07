import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SliverWithCustomAppBar extends StatelessWidget {
  const SliverWithCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with Stack as its flexibleSpace
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
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
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 60,
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
                              backgroundImage:
                                  AssetImage('assets/shawon.jpg'),
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
                              "Mr.Shawon",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 125, 11, 2),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Ready to save a life today?'",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 125, 11, 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 20,
                    bottom: 0,
                    child: Image.asset(
                      'assets/doctor.png',
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dummy scrollable content
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 10,
              (context, index) => ListTile(
                title: Text('Item #$index'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
