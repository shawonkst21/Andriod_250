import 'package:blood_donar/demo/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:location/location.dart'; // <-- added for location

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({super.key});

  @override
  State<ProfilePage1> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? selectedBloodGroup;
  String? selectedCountry;
  String? selectedCity;
  DateTime? selectedDonationDate;

  double? latitude; // <-- new
  double? longitude; // <-- new

  bool isFormValid = false;

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  final List<String> countries = ['Bangladesh'];

  Map<String, List<String>> citiesByCountry = {
    'Bangladesh': [
      'Barisal',
      'Chittagong',
      'Dhaka',
      'Khulna',
      'Mymensingh',
      'Rajshahi',
      'Rangpur',
      'Sylhet'
    ],
  };

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _fetchLocation();
  }

  void _checkFormValidity() {
    final valid = _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        selectedBloodGroup != null &&
        selectedCountry != null &&
        selectedCity != null &&
        selectedDonationDate != null;

    if (valid != isFormValid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  Future<void> _fetchLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
      }
      if (permissionGranted == PermissionStatus.granted) {
        final locData = await location.getLocation();
        setState(() {
          latitude = locData.latitude;
          longitude = locData.longitude;
        });
      }
    } catch (e) {
      print("Location Error: $e");
    }
  }

  Future<void> _pickDonationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDonationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDonationDate = picked;
      });
      _checkFormValidity();
    }
  }

  Future<void> _saveToFirestore() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'bloodGroup': selectedBloodGroup,
        'country': selectedCountry,
        'city': selectedCity,
        'lastDonationDate': selectedDonationDate!.toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
        'location': latitude != null && longitude != null
            ? {'latitude': latitude, 'longitude': longitude}
            : null,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data saved successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homePage()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving data.")));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // (No UI changed)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: Duration(milliseconds: 400),
              child: Text("Profile Setup",
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 6),
            FadeInDown(
              duration: Duration(milliseconds: 500),
              child: Text(
                "Almost done :) Fill up your profile. It's just 3 easy steps.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ),
            ),
            SizedBox(height: 25),
            ZoomIn(
              duration: Duration(milliseconds: 600),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.red[50],
                      child:
                          Icon(Icons.person, color: Colors.redAccent, size: 30),
                    ),
                    SizedBox(height: 8),
                    Text("Personal Information",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Name
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: _buildTextField(_nameController, "Full Name"),
            ),
            SizedBox(height: 10),

            // Phone
            FadeInUp(
              duration: Duration(milliseconds: 850),
              child: _buildTextField(_phoneController, "Phone Number",
                  inputType: TextInputType.phone),
            ),
            SizedBox(height: 10),

            // Blood Group
            FadeInUp(
              duration: Duration(milliseconds: 900),
              child: _buildDropdown(
                hint: 'Select Blood Group',
                value: selectedBloodGroup,
                items: bloodGroups,
                onChanged: (val) {
                  setState(() {
                    selectedBloodGroup = val;
                    _checkFormValidity();
                  });
                },
              ),
            ),
            SizedBox(height: 10),

            // Country
            FadeInUp(
              duration: Duration(milliseconds: 950),
              child: _buildDropdown(
                hint: 'Select Country',
                value: selectedCountry,
                items: countries,
                onChanged: (val) {
                  setState(() {
                    selectedCountry = val;
                    selectedCity = null;
                    _checkFormValidity();
                  });
                },
              ),
            ),
            SizedBox(height: 10),

            // City
            FadeInUp(
              duration: Duration(milliseconds: 1000),
              child: _buildDropdown(
                hint: 'Select City',
                value: selectedCity,
                items: selectedCountry != null
                    ? citiesByCountry[selectedCountry!]!
                    : [],
                onChanged: (val) {
                  setState(() {
                    selectedCity = val;
                    _checkFormValidity();
                  });
                },
              ),
            ),
            SizedBox(height: 10),

            // Last Donation Date
            FadeInUp(
              duration: Duration(milliseconds: 1050),
              child: GestureDetector(
                onTap: _pickDonationDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDonationDate == null
                            ? 'Select Last Donation Date'
                            : DateFormat.yMMMd().format(selectedDonationDate!),
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedDonationDate == null
                              ? Colors.black54
                              : Colors.black,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Continue Button
            FadeInUp(
              duration: Duration(milliseconds: 1100),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid ? _saveToFirestore : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType? inputType}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(left: 20),
      child: TextField(
        controller: controller,
        keyboardType: inputType ?? TextInputType.text,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: Colors.redAccent),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black87, fontSize: 16),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
        ),
      ),
    );
  }
}
