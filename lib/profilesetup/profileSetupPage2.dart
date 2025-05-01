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
        child: Text("Welcome to Home Page!", style: GoogleFonts.poppins(fontSize: 18)),
      ),
    );
  }
}

class ProfileStep2 extends StatefulWidget {
  final userProfileData userData;
  const ProfileStep2({super.key, required this.userData});

  @override
  State<ProfileStep2> createState() => _ProfileStep2State();
}

class _ProfileStep2State extends State<ProfileStep2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _about = TextEditingController();

  String? _gender, _wantToDonate;

  bool get isFormFilled =>
      _dob.text.isNotEmpty && _gender != null && _wantToDonate != null;

  @override
  void initState() {
    super.initState();
    _dob.addListener(() => setState(() {}));
    _about.addListener(() => setState(() {}));
  }

  // Function to save updated user data to Firestore
  Future<void> _saveUserData() async {
    try {
      // Getting reference to Firestore collection
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Update the user data
      await usersCollection.doc(widget.userData.name).update({
        'dob': _dob.text,
        'gender': _gender,
        'wantToDonate': _wantToDonate,
        'about': _about.text,
      });

      // Optionally show success message or navigate to the next step
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data updated successfully!')),
      );

      // You can navigate to Step 3 after saving data
      // Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileStep3(userData: widget.userData)));
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
                "Basic Information",
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
                "This information helps us understand your preferences.",
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
                      "Additional Information",
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
                        "Date of Birth", _dob, TextInputType.datetime),
                  ),
                  SizedBox(height: 15),
                  SlideInUp(
                    duration: Duration(milliseconds: 550),
                    child: _buildDropdown(
                      "Select Gender",
                      _gender,
                      ["Male", "Female", "Other"],
                      (val) => setState(() => _gender = val),
                    ),
                  ),
                  SizedBox(height: 15),
                  SlideInUp(
                    duration: Duration(milliseconds: 600),
                    child: _buildDropdown(
                      "Do you want to donate blood?",
                      _wantToDonate,
                      ["Yes", "No"],
                      (val) => setState(() => _wantToDonate = val),
                    ),
                  ),
                  SizedBox(height: 15),
                  SlideInUp(
                    duration: Duration(milliseconds: 650),
                    child: _buildInputField(
                        "About Yourself (Optional)", _about, TextInputType.text),
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
                          widget.userData.dob = DateTime.parse(_dob.text);
                          widget.userData.gender = _gender;
                          widget.userData.wantToDonate = _wantToDonate;
                          widget.userData.about = _about.text;

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
class userProfileData {
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
