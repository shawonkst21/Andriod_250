import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodRequest extends StatefulWidget {
  const BloodRequest({super.key});

  @override
  State<BloodRequest> createState() => _BloodRequeststate();
}

class _BloodRequeststate extends State<BloodRequest> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String? _selectedDistrict;
  String? _selectedBloodGroup;
  String? _selectedAmount;
  String? _selectedCondition; // New condition field
  bool _isUrgent = false;

  List<String> districts = [
    'Dhaka',
    'Chittagong',
    'Khulna',
    'Barisal',
    'Sylhet'
    
  ];

  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<String> bloodAmounts = ['1 Bag', '2 Bags', '3 Bags', '4 Bags'];

  List<String> urgentConditions = [
    'Trauma',
    'Surgery',
    'Cancer',
    'Anemia',
    'Childbirth',
    'Other'
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedDistrict != null &&
        _selectedBloodGroup != null &&
        _selectedAmount != null &&
        _selectedCondition != null) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("requests").add({
          "userId": currentUser?.uid,
          "fullName": _fullNameController.text.trim(),
          "phone": "+880${_phoneController.text.trim()}",
          "district": _selectedDistrict,
        //  "condition": _conditionController.text.trim(),
          "bloodGroup": _selectedBloodGroup,
          "amount": _selectedAmount,
          "date": _dateController.text.trim(),
          "hospital": _hospitalController.text.trim(),
          "reason": _reasonController.text.trim(),
          "condition": _selectedCondition,
          "isUrgent": _isUrgent,
          "timestamp": FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request submitted successfully!')),
        );

        _formKey.currentState?.reset();
        setState(() {
          _selectedDistrict = null;
          _selectedBloodGroup = null;
          _selectedAmount = null;
          _selectedCondition = null;
          _isUrgent = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit request')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Make a Request For Blood",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 125, 11, 2),
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Full Name", _fullNameController),
              _buildDropdown("Select District", districts, _selectedDistrict,
                  (val) {
                setState(() => _selectedDistrict = val);
              }),
              _buildDropdown(
                  "Required Blood Group", bloodGroups, _selectedBloodGroup,
                  (val) {
                setState(() => _selectedBloodGroup = val);
              }),
              _buildDropdown(
                  "Amount of Required Blood", bloodAmounts, _selectedAmount,
                  (val) {
                setState(() => _selectedAmount = val);
              }),
              _buildDropdown("Condition", urgentConditions, _selectedCondition,
                  (val) {
                setState(() => _selectedCondition = val);
              }),
              _buildTextField("Phone Number (without +880)", _phoneController,
                  keyboard: TextInputType.phone),
              _buildTextField("Date (DD/MM/YYYY)", _dateController),
              _buildTextField(
                  "Hospital Info (Address / Ward / Bed)", _hospitalController),
              _buildTextField("Why Do You Need Blood?", _reasonController),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "! Is it urgent?",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: _isUrgent,
                    activeColor: Colors.red,
                    onChanged: (val) => setState(() => _isUrgent = val),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 100,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(170, 231, 4, 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    "REQUEST",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: FadeInUp(
        duration: Duration(milliseconds: 500),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              color: Colors.red[900],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.red[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade200,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade200,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: FadeInUp(
        duration: Duration(milliseconds: 500),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              color: Colors.red[900],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.red[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade200,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade200,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          dropdownColor: Colors.red[50],
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.red[900]),
          validator: (value) => value == null ? 'Required' : null,
        ),
      ),
    );
  }
}
