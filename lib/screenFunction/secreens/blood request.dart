import 'package:animate_do/animate_do.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/notifications/Fcm_sender.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
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
    'Bagerhat',
    'Bandarban',
    'Barguna',
    'Barisal',
    'Bhola',
    'Bogra',
    'Brahmanbaria',
    'Chandpur',
    'Chapai Nawabganj',
    'Chattogram',
    'Chuadanga',
    'Comilla',
    'Cox\'s Bazar',
    'Dhaka',
    'Dinajpur',
    'Faridpur',
    'Feni',
    'Gaibandha',
    'Gazipur',
    'Gopalganj',
    'Habiganj',
    'Jamalpur',
    'Jashore',
    'Jhalokati',
    'Jhenaidah',
    'Joypurhat',
    'Khagrachari',
    'Khulna',
    'Kishoreganj',
    'Kurigram',
    'Kushtia',
    'Lakshmipur',
    'Lalmonirhat',
    'Madaripur',
    'Magura',
    'Manikganj',
    'Meherpur',
    'Moulvibazar',
    'Munshiganj',
    'Mymensingh',
    'Naogaon',
    'Narail',
    'Narayanganj',
    'Narsingdi',
    'Natore',
    'Netrokona',
    'Nilphamari',
    'Noakhali',
    'Pabna',
    'Panchagarh',
    'Patuakhali',
    'Pirojpur',
    'Rajbari',
    'Rajshahi',
    'Rangamati',
    'Rangpur',
    'Satkhira',
    'Shariatpur',
    'Sherpur',
    'Sirajganj',
    'Sunamganj',
    'Sylhet',
    'Tangail',
    'Thakurgaon',
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
        final docRef = FirebaseFirestore.instance.collection("requests").doc();

        await docRef.set({
          "userId": currentUser?.uid,
          "fullName": _fullNameController.text.trim(),
          "phone": "+880${_phoneController.text.trim()}",
          "district": _selectedDistrict,
          "bloodGroup": _selectedBloodGroup,
          "amount": _selectedAmount,
          "date": _dateController.text.trim(),
          "hospital": _hospitalController.text.trim(),
          "reason": _reasonController.text.trim(),
          "condition": _selectedCondition,
          "isUrgent": _isUrgent,
          "timestamp": FieldValue.serverTimestamp(),
        });

        //! ✅ Send notification if urgent
        if (_isUrgent) {
          await sendNotificationUsingV1API(
            title: "🚨Urgent Need: $_selectedBloodGroup",
            body: "Blood required urgently $_selectedAmount near your area!",
            requestId: docRef.id,
            requesterName: _fullNameController.text.trim(),
            bloodGroup: _selectedBloodGroup!,
            district: _selectedDistrict!,
          );
        }

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
        //  Navigator.pop(context);
      } catch (e) {
        print("🔥 Error: $e");
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
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              FadeInDown(
                duration: Duration(milliseconds: 400),
                child: Text("Making a Request",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 125, 11, 2),
                    )),
              ),
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: Text(
                  "Almost done :) Fill up the form below to complete your blood request.",
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                ),
              ),
              // SizedBox(height: 25),
              ZoomIn(
                duration: Duration(milliseconds: 600),
                child: Center(
                  child: Column(
                    children: [
                      Lottie.asset('assets/addlist.json', height: 150)
                    ],
                  ),
                ),
              ),
            
              SizedBox(height: 20),
              FadeInUp(
                  duration: Duration(milliseconds: 800),
                  child: _buildTextField("Paitent Name", _fullNameController)),
              const SizedBox(height: 10),

              FadeInUp(
                duration: Duration(milliseconds: 850),
                child: _buildDropdown(
                    "Select District", districts, _selectedDistrict, (val) {
                  setState(() => _selectedDistrict = val);
                }),
              ),
              const SizedBox(height: 10),

              FadeInUp(
                duration: Duration(milliseconds: 900),
                child: _buildDropdown(
                    "Required Blood Group", bloodGroups, _selectedBloodGroup,
                    (val) {
                  setState(() => _selectedBloodGroup = val);
                }),
              ),
              const SizedBox(height: 10),

              FadeInUp(
                duration: Duration(milliseconds: 950),
                child: _buildDropdown(
                    "Amount of Required Blood", bloodAmounts, _selectedAmount,
                    (val) {
                  setState(() => _selectedAmount = val);
                }),
              ),
              const SizedBox(height: 10),

              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: _buildDropdown(
                    "Condition", urgentConditions, _selectedCondition, (val) {
                  setState(() => _selectedCondition = val);
                }),
              ),
              const SizedBox(height: 10),

              FadeInUp(
                duration: Duration(milliseconds: 1050),
                child: _buildTextField(
                  "Phone Number (without +880)",
                  _phoneController,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FadeInUp(
                  duration: Duration(milliseconds: 1100),
                  child: _buildTextField("Date (DD/MM/YYYY)", _dateController)),
              SizedBox(
                height: 10,
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1150),
                child: _buildTextField("Hospital Info (Address / Ward / Bed)",
                    _hospitalController),
              ),
              SizedBox(
                height: 10,
              ),
              FadeInUp(
                  duration: Duration(milliseconds: 1200),
                  child: _buildTextField(
                      "Why Do You Need Blood?", _reasonController)),
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

  Widget _buildTextField(String hint, TextEditingController controller,
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


  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    void Function(String?)? onChanged,
  ) {
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
