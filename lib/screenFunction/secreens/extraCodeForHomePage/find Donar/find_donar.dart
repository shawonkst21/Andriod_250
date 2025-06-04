import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/find%20Donar/donarList.dart';

class FindDonorScreen extends StatefulWidget {
  const FindDonorScreen({super.key});

  @override
  State<FindDonorScreen> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<FindDonorScreen> {
  String? selectedDistrict;
  String? selectedBloodGroup;
  bool isFilterActive = false;

  //! here check if the user is available for donation or not
  //! if the last donation date is more than 90 days ago, then the user is available for donation
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

//! Show the search dialog for filtering donors by district and blood group
  //! when the user clicks on the search icon in the app bar
  void _showSearchDialog() {
    String? tempDistrict = selectedDistrict;
    String? tempBloodGroup = selectedBloodGroup;

    showGeneralDialog(
      //barrierColor: Colors.yellow,
      context: context,
      barrierDismissible: true,
      barrierLabel: "Search Donor",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox(); // required, but unused
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final scale =
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack);

        return ScaleTransition(
          scale: scale,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Search Donor",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 125, 11, 2),
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white, // dropdown popup background
                  ),
                  child: DropdownButtonFormField<String>(
                    value: tempDistrict,
                    decoration: InputDecoration(
                      labelText: 'Select District',
                      labelStyle: GoogleFonts.poppins(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 125, 11, 2), // border color when focused
                          width: 2,
                        ),
                      ),
                    ),
                    items: [
                      'Dhaka',
                      'Chattogram',
                      'Khulna',
                      'Rajshahi',
                      'sylhet',
                      'Other'
                    ]
                        .map((district) => DropdownMenuItem(
                              value: district,
                              child:
                                  Text(district, style: GoogleFonts.poppins()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      tempDistrict = value;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white, // dropdown popup background
                  ),
                  child: DropdownButtonFormField<String>(
                    value: tempBloodGroup,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Select Blood Group',
                      labelStyle: GoogleFonts.poppins(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 125, 11, 2), // border color when focused
                          width: 2,
                        ),
                      ),
                    ),
                    items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                        .map((group) => DropdownMenuItem(
                              value: group,
                              child: Text(group, style: GoogleFonts.poppins()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      tempBloodGroup = value;
                    },
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 125, 11, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Find",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedDistrict = tempDistrict;
                    selectedBloodGroup = tempBloodGroup;
                    isFilterActive = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
        actions: [
          if (isFilterActive)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black),
              onPressed: () {
                setState(() {
                  selectedDistrict = null;
                  selectedBloodGroup = null;
                  isFilterActive = false;
                });
              },
            ),
        ],
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

          final allUsers = snapshot.data!.docs;

          final users = isFilterActive
              ? allUsers.where((doc) {
                  final data = doc.data();
                  final city = data['city']?.toString().toLowerCase();
                  final blood = data['bloodGroup']?.toString().toUpperCase();
                  return (selectedDistrict == null ||
                          city == selectedDistrict!.toLowerCase()) &&
                      (selectedBloodGroup == null ||
                          blood == selectedBloodGroup);
                }).toList()
              : allUsers;

          if (users.isEmpty) {
            return const Center(child: Text("No donors match your search."));
          }

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

      //! Floating action button for search dialog
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        child: const Icon(
          Icons.search,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: const Color.fromARGB(255, 125, 11, 2),
      ),
    );
  }
}
