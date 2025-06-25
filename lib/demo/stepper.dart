// Full Stepper-based registration for blood donor

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:animate_do/animate_do.dart';

class DonorStepper extends StatefulWidget {
  const DonorStepper({super.key});

  @override
  State<DonorStepper> createState() => _DonorStepperState();
}

class _DonorStepperState extends State<DonorStepper> {
  int _currentStep = 0;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _donationCountController = TextEditingController();

  String? gender;
  String? bloodGroup;
  String? country;
  String? city;
  DateTime? dob;
  DateTime? lastDonationDate;
  double? latitude;
  double? longitude;

  List<String> genders = ['Male', 'Female', 'Other'];
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  List<String> countries = ['Bangladesh'];
  Map<String, List<String>> citiesByCountry = {
    'Bangladesh': ['Kushtia', 'Dhaka', 'Chittagong', 'Barisal', 'Sylhet'],
  };

  Future<void> fetchLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await location.requestService();
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.granted) {
      final loc = await location.getLocation();
      latitude = loc.latitude;
      longitude = loc.longitude;
    }
  }

  Future<void> signUp() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "Passwords don't match",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final now = DateTime.now();
      final isAvailable = lastDonationDate == null
          ? true
          : now.difference(lastDonationDate!).inDays >= 90;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'gender': gender,
        'dob': dob,
        'weight': _weightController.text.trim(),
        'donationCount': _donationCountController.text.trim(),
        'bloodGroup': bloodGroup,
        'country': country,
        'city': city,
        'lastDonationDate': lastDonationDate,
        'location': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'available': isAvailable,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Registration Failed",
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> pickDate(Function(DateTime) onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donor Registration Stepper")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep == 2) {
            await signUp();
          } else {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep -= 1);
        },
        steps: [
          Step(
            title: Text("Account Info"),
            isActive: _currentStep >= 0,
            content: Column(
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: _buildTextField(_emailController, "Email"),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: _buildTextField(_passwordController, "Password",
                      isPassword: true),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: _buildTextField(
                      _confirmPasswordController, "Confirm Password",
                      isPassword: true),
                ),
              ],
            ),
          ),
          Step(
            title: Text("Personal Info"),
            isActive: _currentStep >= 1,
            content: Column(
              children: [
                TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Full Name")),
                TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: "Phone Number")),
                DropdownButton<String>(
                  hint: Text("Select Gender"),
                  value: gender,
                  onChanged: (val) => setState(() => gender = val),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                ),
                ElevatedButton(
                  onPressed: () => pickDate((d) => setState(() => dob = d)),
                  child: Text(dob == null
                      ? "Pick Date of Birth"
                      : DateFormat.yMMMd().format(dob!)),
                ),
                TextField(
                    controller: _weightController,
                    decoration: InputDecoration(labelText: "Weight (kg)"),
                    keyboardType: TextInputType.number),
                TextField(
                    controller: _donationCountController,
                    decoration: InputDecoration(labelText: "Total Donations"),
                    keyboardType: TextInputType.number),
              ],
            ),
          ),
          Step(
            title: Text("Donation Details"),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                DropdownButton<String>(
                  hint: Text("Select Blood Group"),
                  value: bloodGroup,
                  onChanged: (val) => setState(() => bloodGroup = val),
                  items: bloodGroups
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                ),
                DropdownButton<String>(
                  hint: Text("Select Country"),
                  value: country,
                  onChanged: (val) => setState(() {
                    country = val;
                    city = null;
                  }),
                  items: countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                ),
                DropdownButton<String>(
                  hint: Text("Select City"),
                  value: city,
                  onChanged: (val) => setState(() => city = val),
                  items: country != null
                      ? citiesByCountry[country!]!
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList()
                      : [],
                ),
                ElevatedButton(
                  onPressed: () =>
                      pickDate((d) => setState(() => lastDonationDate = d)),
                  child: Text(lastDonationDate == null
                      ? "Pick Last Donation Date"
                      : DateFormat.yMMMd().format(lastDonationDate!)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: const Color.fromARGB(218, 222, 66, 66)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ),
    );
  }
}
