import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/find%20Donar/map_view.dart';
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
  bool isMapView = false;

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

  void _showSearchDialog() {
    String? tempDistrict = selectedDistrict;
    String? tempBloodGroup = selectedBloodGroup;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Search Donor",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox();
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
                    canvasColor: Colors.white,
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
                          color: Color.fromARGB(255, 125, 11, 2),
                          width: 2,
                        ),
                      ),
                    ),
                    items: [
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
                    canvasColor: Colors.white,
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
                          color: Color.fromARGB(255, 125, 11, 2),
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
                    isMapView = false;
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

  List<QueryDocumentSnapshot> _getFilteredUsers(
      List<QueryDocumentSnapshot> allUsers) {
    if (!isFilterActive) return allUsers;

    return allUsers.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final city = data['city']?.toString().toLowerCase();
      final blood = data['bloodGroup']?.toString().toUpperCase();
      return (selectedDistrict == null ||
              city == selectedDistrict!.toLowerCase()) &&
          (selectedBloodGroup == null || blood == selectedBloodGroup);
    }).toList();
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
                  isMapView = false;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (isFilterActive)
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isMapView = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isMapView
                              ? const Color.fromARGB(255, 125, 11, 2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.list,
                              color:
                                  !isMapView ? Colors.white : Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "List View",
                              style: GoogleFonts.poppins(
                                color: !isMapView
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isMapView = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isMapView
                              ? const Color.fromARGB(255, 125, 11, 2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              color:
                                  isMapView ? Colors.white : Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Map View",
                              style: GoogleFonts.poppins(
                                color:
                                    isMapView ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
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
                final filteredUsers = _getFilteredUsers(allUsers);

                if (filteredUsers.isEmpty) {
                  return const Center(
                      child: Text("No donors match your search."));
                }

                if (isMapView && isFilterActive) {
                  return DonorMapView(users: filteredUsers);
                }

                return ListView(
                  children: filteredUsers.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        backgroundColor: const Color.fromARGB(255, 125, 11, 2),
        child: const Icon(
          Icons.search,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
