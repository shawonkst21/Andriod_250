import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class EditRequestScreen extends StatefulWidget {
  final String bloodGroup;
  final String district;
  final String fullName;
  final String amount;
  final String date;
  final String hospital;
  final String reason;
  final String phone;
  final bool isUrgent;
  final String requestId;

  const EditRequestScreen({
    super.key,
    required this.bloodGroup,
    required this.district,
    required this.fullName,
    required this.amount,
    required this.date,
    required this.hospital,
    required this.reason,
    required this.phone,
    required this.isUrgent,
    required this.requestId,
  });

  @override
  _EditRequestScreenState createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {
  late TextEditingController fullNameController;
  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController hospitalController;
  late TextEditingController reasonController;
  late TextEditingController phoneController;
  late String bloodGroup;
  late String district;
  late bool isUrgent;

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  final List<String> districts = [
    'Dhaka',
    'Chittagong',
    'Rajshahi',
    'Khulna',
    'Barisal',
    'Sylhet'
  ];

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.fullName);
    amountController = TextEditingController(text: widget.amount);
    dateController = TextEditingController(text: widget.date);
    hospitalController = TextEditingController(text: widget.hospital);
    reasonController = TextEditingController(text: widget.reason);
    phoneController = TextEditingController(text: widget.phone);
    bloodGroup = widget.bloodGroup;
    district = widget.district;
    isUrgent = widget.isUrgent;
  }

  void updateRequest() async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.requestId)
          .update({
        'fullName': fullNameController.text,
        'amount': amountController.text,
        'date': dateController.text,
        'hospital': hospitalController.text,
        'reason': reasonController.text,
        'phone': phoneController.text,
        'bloodGroup': bloodGroup,
        'district': district,
        'isUrgent': isUrgent,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? inputType}) {
    return ZoomIn(
      duration: Duration(milliseconds: 700),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: controller,
          keyboardType: inputType ?? TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return ZoomIn(
      duration: Duration(milliseconds: 700),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Request 📝',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 125, 11, 2),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField(fullNameController, 'Full Name'),
            _buildTextField(amountController, 'Amount (bags)'),
            _buildTextField(dateController, 'Date (e.g., 2025-06-05)'),
            _buildTextField(hospitalController, 'Hospital Name'),
            _buildTextField(reasonController, 'Reason'),
            _buildTextField(phoneController, 'Phone Number'),
            _buildDropdown('Blood Group', bloodGroup, bloodGroups,
                (val) => setState(() => bloodGroup = val!)),
            _buildDropdown('District', district, districts,
                (val) => setState(() => district = val!)),
            FadeInUp(
              duration: Duration(milliseconds: 400),
              child: CheckboxListTile(
                fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.redAccent;
                    }
                    return Colors.grey[200];
                  },
                ),
                value: isUrgent,
                title: Text(
                  'Mark as Urgent',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onChanged: (val) => setState(() => isUrgent = val!),
              ),
            ),
            // SizedBox(height: 10),
            FadeInUp(
              duration: Duration(milliseconds: 900),
              child: ElevatedButton(
                onPressed: updateRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 56, 240, 111),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save Changes',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
