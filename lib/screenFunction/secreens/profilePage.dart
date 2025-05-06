import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late Future<Map<String, dynamic>> _userData;

  Future<Map<String, dynamic>> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()!;
    } else {
      throw Exception('User data not found');
    }
  }

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load user data.'));
          }

          final user = snapshot.data!;
          final name = user['name'] ?? 'No Name';
          final email = user['email'] ?? 'No Email';
          final phone = user['phone'] ?? 'No Phone';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

          final profileItems = [
            {"icon": Icons.person, "title": "Username", "value": name},
            {"icon": Icons.email, "title": "Email", "value": email},
            {"icon": Icons.phone, "title": "Phone", "value": phone},
            {"icon": Icons.settings, "title": "Settings"},
            {"icon": Icons.lock, "title": "Privacy"},
            {"icon": Icons.logout, "title": "Logout"},
          ];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                floating: true,
                pinned: true,
                backgroundColor: Colors.blueAccent,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(color: Colors.blueAccent),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        initial,
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = profileItems[index];
                    return ListTile(
                      leading: Icon(item["icon"], color: Colors.blueAccent),
                      title: Text(
                        item["title"],
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      subtitle: item["value"] != null
                          ? Text(
                              item["value"],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            )
                          : null,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: handle tap action
                      },
                    );
                  },
                  childCount: profileItems.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
