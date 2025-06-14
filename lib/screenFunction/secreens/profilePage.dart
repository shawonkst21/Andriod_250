import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfileState();
}

class _ProfileState extends State<Profilepage> {
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF44336),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Yes, logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context), // Close the dialog
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Uint8List? _image;
  bool isAvailable = false;

  // Firestore user data fields
  String name = '';
  String email = '';
  String bloodGroup = '';
  String district = '';
  String address = '';
  String phone = '';
  String formattedDate = '';
  //!setting functionality................
  bool _notificationsEnabled = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    loadNotificationPreference();
  }

  Future<void> loadNotificationPreference() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final isOn = doc.data()?['notificationsEnabled'] ?? true;
        setState(() {
          _notificationsEnabled = isOn;
        });

        // Sync FCM topic
        if (isOn) {
          await FirebaseMessaging.instance.subscribeToTopic('all_users');
        } else {
          await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
        }
      }
    }
  }

  Future<void> updateNotificationPreference(bool value) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      setState(() {
        _notificationsEnabled = value;
      });

      await _firestore.collection('users').doc(uid).set({
        'notificationsEnabled': value,
      }, SetOptions(merge: true));

      if (value) {
        await FirebaseMessaging.instance.subscribeToTopic('all_users');
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
      }
    }
  }
  //! bottom sheet....................

  void showSettingsOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text('Edit Profile', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/editProfile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: Text('Rating My App', style: GoogleFonts.poppins()),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('Language', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  // Add language picker navigation here
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title:
                    Text('Exit', style: GoogleFonts.poppins(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Future.delayed(const Duration(milliseconds: 300), () {
                    exit(0); // Terminates the app
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
//!............................................................................
  // Image picker method

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          name = doc['name'] ?? '';
          email = doc['email'] ?? '';
          bloodGroup = doc['bloodGroup'] ?? '';
          // district = doc['district'] ?? '';
          phone = doc['phone'] ?? '';
          address = "Akhaliya, ${doc['city']}, ${doc['country']}";
          isAvailable = doc['available'] ?? false;
          final lastDonationTimestamp = doc['lastDonationDate'] as Timestamp;
          final lastDonationDate = lastDonationTimestamp.toDate();
          formattedDate = DateFormat('MMMM d, y').format(lastDonationDate);
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> updateLastDonationDate() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'lastDonationDate': Timestamp.now()});
      }
    } catch (e) {
      print('Error updating last donation date: $e');
    }
  }

  void updateAvailability(bool value) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'available': value});
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(height: 50),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    //  color: Colors.amber,
                  ),
                  Positioned(
                    bottom: 6,
                    left: 140,
                    child: Text(
                      "Profile",
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 125, 11, 2),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Positioned(
                      //bottom: 5,
                      right: 10,
                      child: IconButton(
                          onPressed: showSettingsOptions,
                          icon: Icon(FlutterIcons.setting_ant)))
                ],
              ),

              //const SizedBox(height: 10),
              ZoomIn(
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 65,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: const CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  Color.fromARGB(170, 239, 120, 120),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    AssetImage('assets/shawon.jpg'),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: -15,
                      left: 70,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          FlutterIcons.camera_account_mco,
                          color: Color.fromARGB(255, 125, 11, 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name.isNotEmpty ? name : 'Loading...',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FlutterIcons.location_arrow_faw,
                    color: Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    address.isNotEmpty ? address : 'Loading address...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              //! Phone container with border
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(122, 240, 196, 196),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Colors.red, size: 24),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number",
                              style: GoogleFonts.poppins(fontSize: 10),
                            ),
                            Text(
                              phone.isNotEmpty ? phone : 'Loading...',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 125, 11, 2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //!...............................4 boxes..................
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 7),
                    child: Stack(children: [
                      Container(
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(122, 240, 196, 196),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //mainAxisAlignment: MainAxisAlignment.start,
                              Text(
                                "Age",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "24",
                                    style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 125, 11, 2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 7,
                          right: 14,
                          child: Icon(
                            Icons.calendar_month,
                            size: 35,
                            color: Color.fromARGB(255, 125, 11, 2),
                          )),
                      Positioned(
                          bottom: 17,
                          left: 50,
                          child: Text(
                            "Years",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 125, 11, 2),
                            ),
                          ))
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 7),
                    child: Stack(children: [
                      Container(
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(122, 240, 196, 196),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //mainAxisAlignment: MainAxisAlignment.start,
                              Text(
                                "Weight",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "67",
                                    style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 125, 11, 2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 7,
                          right: 14,
                          child: Icon(
                            FlutterIcons.weight_kilogram_mco,
                            size: 35,
                            color: Color.fromARGB(255, 125, 11, 2),
                          )),
                      Positioned(
                          bottom: 17,
                          left: 50,
                          child: Text(
                            "KG",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 125, 11, 2),
                            ),
                          ))
                    ]),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 7),
                    child: Stack(children: [
                      Container(
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(122, 240, 196, 196),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //mainAxisAlignment: MainAxisAlignment.start,
                              Text(
                                "Gender",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Male",
                                    style: GoogleFonts.poppins(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 125, 11, 2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 7,
                          right: 14,
                          child: Icon(
                            FlutterIcons.gender_male_female_mco,
                            size: 35,
                            color: Color.fromARGB(255, 125, 11, 2),
                          )),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 7),
                    child: Stack(children: [
                      Container(
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(122, 240, 196, 196),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //mainAxisAlignment: MainAxisAlignment.start,
                              Text(
                                "Blood Group",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Text(
                                    bloodGroup,
                                    style: GoogleFonts.poppins(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 125, 11, 2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 7,
                          right: 14,
                          child: Icon(
                            FlutterIcons.blood_bag_mco,
                            size: 35,
                            color: Color.fromARGB(255, 125, 11, 2),
                          )),
                    ]),
                  ),

                  // Optional: Display blood group and district
                ],
              ),
              //!....................................................
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(122, 240, 196, 196),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              "Available for Donation",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                        Switch(
                          value: isAvailable,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              isAvailable = value;
                            });
                            updateAvailability(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                child: Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(122, 240, 196, 196),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.red, size: 24),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Last Donation",
                                  style: GoogleFonts.poppins(fontSize: 10)),
                              Text(
                                formattedDate.isNotEmpty
                                    ? formattedDate
                                    : 'Loading...',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 125, 11, 2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 8,
                    child: IconButton(
                      onPressed: () async {
                        updateAvailability(false);
                        await updateLastDonationDate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Donation status updated.")),
                        );
                      },
                      icon: Icon(FlutterIcons.edit_ant),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(122, 240, 196, 196),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_active_outlined,
                                color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              " Notification",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                        Switch(
                          value: _notificationsEnabled,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              updateNotificationPreference(value);
                            });
                            // updateAvailability(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Center(
                  child: SizedBox(
                    width: 250, // Makes the button expand horizontally
                    height: 40, // Increases the button height
                    child: ElevatedButton(
                      onPressed: _showLogoutDialog,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFFF44336),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14, // Slightly larger font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ]),
          ),
        ));
  }
}
