import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart'; // <-- added for location

class Organizationinfo extends StatefulWidget {
  const Organizationinfo({super.key});

  @override
  State<Organizationinfo> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<Organizationinfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _totalDonar = TextEditingController();

  String? selectedCountry;
  String? selectedCity;

  bool isFormValid = false;

  final List<String> countries = ['Bangladesh'];

  Map<String, List<String>> citiesByCountry = {
    'Bangladesh': [
      'kushtia',
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
    _totalDonar.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    final valid = _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _totalDonar.text.isNotEmpty &&
        selectedCountry != null &&
        selectedCity != null;
    if (valid != isFormValid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  Future<void> _saveToFirestore() async {
    try {
     // final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('organization').doc().set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'country': selectedCountry,
        'city': selectedCity,
        'totalDonars': _totalDonar.text,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data saved successfully!")),
      );
      Navigator.pop(context);
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
    _totalDonar.dispose();
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
              child: Text("organization Info",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 125, 11, 2),
                  )),
            ),
            SizedBox(height: 6),
            FadeInDown(
              duration: Duration(milliseconds: 500),
              child: Text(
                "Almost done :) Fill up the form below to complete your organization profile.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ),
            ),
            // SizedBox(height: 25),
            ZoomIn(
              duration: Duration(milliseconds: 600),
              child: Center(
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/orga.json',
                      // width: 120,
                      height: 140,
                    ),
                    //  SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Name
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: _buildTextField(_nameController, "Organization Name"),
            ),
            SizedBox(height: 10),

            // Phone
            FadeInUp(
              duration: Duration(milliseconds: 850),
              child: _buildTextField(_phoneController, "Phone Number",
                  inputType: TextInputType.phone),
            ),
            SizedBox(height: 10),
            FadeInUp(
              duration: Duration(milliseconds: 850),
              child: _buildTextField(_totalDonar, "Total Donars",
                  inputType: TextInputType.phone),
            ),
            SizedBox(height: 10),

            // Blood Group

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
            SizedBox(height: 80),
            // Last Donation Date
            // Continue Button
            FadeInUp(
              duration: Duration(milliseconds: 1100),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid ? _saveToFirestore : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'save & Continue',
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
