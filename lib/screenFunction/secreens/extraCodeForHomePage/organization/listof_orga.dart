import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/organization/orga_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Organization_list extends StatefulWidget {
  const Organization_list({super.key});

  @override
  State<Organization_list> createState() => _Organization_listState();
}

class _Organization_listState extends State<Organization_list> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Organization List',
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(255, 125, 11, 2),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("organization").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No organization found."));
          }

          final allorganization = snapshot.data!.docs;

          return ListView(
            children: allorganization.map((doc) {
              final data = doc.data();

              return OrgaCard(
                name: data['name'] ?? "Unknown",
                city: data['city'] ?? 'Unknown',
                country: data['country'] ?? 'Unknown',
                totaldonars: data['totalDonars'] ?? "N/A",
                phone: data['phone'] ?? "",
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/organizationInfo');
        },
        backgroundColor: Color.fromARGB(255, 125, 11, 2),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Organization',
      ),
    );
  }
}
