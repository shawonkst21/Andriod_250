import 'package:blood_donar/profilesetup/profileSetupPage2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Dummy HomePage for navigation
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home", style: GoogleFonts.poppins())),
      body: Center(
        child: Text("Welcome to Home Page!",
            style: GoogleFonts.poppins(fontSize: 18)),
      ),
    );
  }
}

class ProfileStep1 extends StatefulWidget {
  final UserProfileData userData;
  const ProfileStep1({super.key, required this.userData});

  @override
  State<ProfileStep1> createState() => _ProfileStep1State();
}

class _ProfileStep1State extends State<ProfileStep1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  String? _bloodGroup, _country, _city;

  bool get isFormFilled =>
      _name.text.isNotEmpty &&
      _phone.text.isNotEmpty &&
      _bloodGroup != null &&
      _country != null &&
      _city != null;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
    _phone.addListener(() => setState(() {}));
  }

  // Function to save user data to Firestore
  Future<void> _saveUserData() async {
    try {
      // Getting reference to Firestore collection
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Add the user data to the collection
      await usersCollection.add({
        'name': _name.text,
        'phone': _phone.text,
        'bloodGroup': _bloodGroup,
        'country': _country,
        'city': _city,
      });

      // Optionally show success message or navigate to the next step
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data saved successfully!')),
      );

      // You can navigate to Step 2 after saving data
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileStep2(userData: userProfileData())));
    } catch (e) {
      print('Error saving user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving user data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: Duration(milliseconds: 400),
              child: Text(
                "Profile Setup",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 6),
            FadeInDown(
              duration: Duration(milliseconds: 500),
              child: Text(
                "Almost done :) For set your profile, fillup below information. It’s easy. Just 3 easy steps.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
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
                    Text(
                      "Personal Information",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SlideInUp(
                    duration: Duration(milliseconds: 500),
                    child: _buildInputField(
                        "Your Name", _name, TextInputType.name),
                  ),
                  SizedBox(height: 15),
                  SlideInUp(
                    duration: Duration(milliseconds: 550),
                    child: _buildInputField(
                        "Mobile Number", _phone, TextInputType.phone),
                  ),
                  SizedBox(height: 15),
                  SlideInUp(
                    duration: Duration(milliseconds: 600),
                    child: _buildDropdown(
                      "Select Blood Group",
                      _bloodGroup,
                      ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
                      (val) => setState(() => _bloodGroup = val),
                    ),
                  ),
                  SizedBox(height: 15),
                  SlideInUp(
                    duration: Duration(milliseconds: 650),
                    child: _buildDropdown(
                      "Select Country",
                      _country,
                      ["Bangladesh", "India", "Nepal"],
                      (val) => setState(() => _country = val),
                    ),
                  ),
                  SizedBox(height: 15),
                  SlideInUp(
                    duration: Duration(milliseconds: 700),
                    child: _buildDropdown(
                      "Select City",
                      _city,
                      ["Dhaka", "Chittagong", "Sylhet"],
                      (val) => setState(() => _city = val),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            BounceInUp(
              duration: Duration(milliseconds: 800),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFormFilled ? Colors.redAccent : Colors.red[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isFormFilled
                      ? () {
                          widget.userData.name = _name.text;
                          widget.userData.phone = _phone.text;
                          widget.userData.bloodGroup = _bloodGroup;
                          widget.userData.country = _country;
                          widget.userData.city = _city;

                          // Save data to Firestore
                          _saveUserData();
                        }
                      : null,
                  child: Text(
                    "Next",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, TextInputType inputType) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String> items,
      void Function(String?)? onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      hint: Text(hint, style: GoogleFonts.poppins()),
      style: GoogleFonts.poppins(color: Colors.black),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: GoogleFonts.poppins()),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

// Model for user data
class UserProfileData {
  String? name;
  String? phone;
  String? bloodGroup;
  String? country;
  String? city;
  DateTime? dob;
  String? gender;
  String? wantToDonate;
  String? about;
  String? imageUrl;

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'bloodGroup': bloodGroup,
        'country': country,
        'city': city,
        'dob': dob?.toIso8601String(),
        'gender': gender,
        'wantToDonate': wantToDonate,
        'about': about,
        'imageUrl': imageUrl,
      };
}
