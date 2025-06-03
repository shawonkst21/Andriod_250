import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/find%20Donar/donarCard.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/find%20Donar/donarList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FindDonorScreen extends StatelessWidget {
  const FindDonorScreen({super.key});

  bool isAvailableForDonation(dynamic lastDonationDate) {
    DateTime lastDate;

    if (lastDonationDate is String) {
      lastDate = DateTime.parse(lastDonationDate);
    } else if (lastDonationDate is Timestamp) {
      lastDate = lastDonationDate.toDate();
    } else {
      return false;
    }

    return DateTime.now().difference(lastDate).inDays >= 90;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Find Donor",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 125, 11, 2),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No donors found."));
          }

          final users = snapshot.data!.docs;

          return ListView(
            children: users.map((doc) {
              final data = doc.data();

              final isAvailable =
                  isAvailableForDonation(data['lastDonationDate']);

              return Donarlist(
                name: data['name'] ?? "Unknown",
                address:
                    "${data['city'] ?? 'Unknown'}, ${data['country'] ?? 'Unknown'}",
                bloodGroup: data['bloodGroup'] ?? "N/A",
                phone: data['phone'] ?? "",
                isAvailable: isAvailable,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
