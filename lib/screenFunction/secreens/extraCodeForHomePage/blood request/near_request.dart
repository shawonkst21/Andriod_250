import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/blood%20request/requestlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class nearRequest extends StatefulWidget {
  const nearRequest({super.key});

  @override
  State<nearRequest> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<nearRequest> {
  String? selectedDistrict;
  String? selectedBloodGroup;
  bool isFilterActive = false;
  bool isFabMenuOpen = false;

//! Show the search dialog for filtering donors by district and blood group
  //! when the user clicks on the search icon in the app bar
  void _showSearchDialog() {
    String? tempDistrict = selectedDistrict;
    String? tempBloodGroup = selectedBloodGroup;

    showGeneralDialog(
      //barrierColor: Colors.yellow,
      context: context,
      barrierDismissible: true,
      barrierLabel: "Request  For Blood",
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
              "Search request list",
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
                      'kushtia',
                      'Dhaka',
                      'Chittagong',
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
                  "Search",
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
//!main part of this page .............................................
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Request For Blood",
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
      //! StreamBuilder to fetch data from Firestore..............(1)
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("requests").snapshots(),
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

          final allrequest = snapshot.data!.docs;

          final requests = isFilterActive
              ? allrequest.where((doc) {
                  final data = doc.data();
                  final city = data['district']?.toString().toLowerCase();
                  final blood = data['bloodGroup']?.toString().toUpperCase();
                  return (selectedDistrict == null ||
                          city == selectedDistrict!.toLowerCase()) &&
                      (selectedBloodGroup == null ||
                          blood == selectedBloodGroup);
                }).toList()
              : allrequest;

          if (requests.isEmpty) {
            return const Center(child: Text("No request match your search."));
          }
            //! Displaying the list of requests.....(2)
          return ListView(
            children: requests.map((doc) {
              final data = doc.data();
              return Requestlist(
                bloodGroup: data['bloodGroup'] ?? "N/A",
                district: data['district'] ?? "Unknown",
                fullName: data['fullName'] ?? "Unknown",
                amount: data['amount'] ?? "Unknown",
                date: data['date'] ?? "Unknown",
                hospital: data['hospital'] ?? "Unknown",
                reason: data['reason'] ?? "Unknown",
                phone: data['phone'] ?? "",
                isUrgent: data['isUrgent'] ?? false,
                userId: data['userId'] ?? "",
                requestId: doc.id,
              );
            }).toList(),
          );
        },
      ),

      //! Floating action button for search dialog
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFabMenuOpen) ...[
            FloatingActionButton.extended(
              heroTag: 'search',
              onPressed: () {
                setState(() {
                  isFabMenuOpen = false;
                });
                _showSearchDialog();
              },
              label: Text(
                "Search",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              backgroundColor: const Color.fromARGB(255, 125, 11, 2),
            ),
            const SizedBox(height: 12),
            FloatingActionButton.extended(
              heroTag: 'myRequests',
              onPressed: () {
                setState(() {
                  isFabMenuOpen = false;
                });
                _showUserRequests();
              },
              label: Text(
                "View My Requests",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              icon: const Icon(Icons.list, color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 125, 11, 2),
            ),
            const SizedBox(height: 12),
          ],
          FloatingActionButton(
            heroTag: 'menu',
            onPressed: () {
              setState(() {
                isFabMenuOpen = !isFabMenuOpen;
              });
            },
            backgroundColor: const Color.fromARGB(255, 125, 11, 2),
            child: Icon(
              isFabMenuOpen ? Icons.close : Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
//! Function to show user's own requests............(3).....................
  void _showUserRequests() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "My Blood Requests",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 125, 11, 2),
              ),
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("requests")
                .where('userId', isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("You have no requests."));
              }

              final myRequests = snapshot.data!.docs;

              return ListView(
                children: myRequests.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Requestlist(
                    bloodGroup: data['bloodGroup'] ?? "N/A",
                    district: data['district'] ?? "Unknown",
                    fullName: data['fullName'] ?? "Unknown",
                    amount: data['amount'] ?? "Unknown",
                    date: data['date'] ?? "Unknown",
                    hospital: data['hospital'] ?? "Unknown",
                    reason: data['reason'] ?? "Unknown",
                    phone: data['phone'] ?? "",
                    isUrgent: data['isUrgent'] ?? false,
                    userId: data['userId'] ?? "",
                    requestId: doc.id,
                  );
                }).toList(),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/addrequest');
            },
            backgroundColor: const Color.fromARGB(255, 125, 11, 2),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
