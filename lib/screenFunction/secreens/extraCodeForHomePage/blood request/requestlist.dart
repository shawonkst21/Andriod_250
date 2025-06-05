import 'package:animate_do/animate_do.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/blood%20request/editScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class Requestlist extends StatelessWidget {
  final String bloodGroup;
  final String district;
  final String fullName;
  final String amount;
  final String date;
  final String hospital;
  final String reason;
  final String phone;
  final bool isUrgent;
  final String userId;
  final String requestId;

  const Requestlist({
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
    required this.userId,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      // duration: const Duration(milliseconds: 500),
      child: Card(
        //color: isUrgent ? Colors.red[50] : Colors.white,
        color: Colors.white,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.red.shade300, // Customize border color
            width: 1, // Thickness of the outline
          ),
        ),

        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blood group and location
              Row(
                children: [
                  Text(
                    'Blood Group: ',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    bloodGroup,
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.location_on,
                      size: 18, color: const Color.fromARGB(255, 233, 9, 9)),
                  SizedBox(width: 4),
                  Text(
                    district,
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),

                  // Add Edit Icon Button here
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () async {
                      // Check if current user can edit
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please login to edit this request.")),
                        );
                        return;
                      }
                      if (currentUser.uid == userId) {
                        // Allow editing
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRequestScreen(
                              // Pass current request data to edit screen
                              bloodGroup: bloodGroup,
                              district: district,
                              fullName: fullName,
                              amount: amount,
                              date: date,
                              hospital: hospital,
                              reason: reason,
                              phone: phone,
                              isUrgent: isUrgent,
                              requestId: requestId,
                            ),
                          ),
                        );
                      } else {
                        // Show not authorized
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("You can only edit your own requests.")),
                        );
                      }
                    },
                  ),
                ],
              ),

              Divider(
                color: const Color.fromARGB(255, 9, 9, 9),
                thickness: 1,
                height: 20,
              ),
              // Patient info
              Text(
                "Patient: $fullName",
                style: GoogleFonts.poppins(),
              ),
              SizedBox(height: 4),
              Text(
                "Required: $amount required on $date at $hospital",
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              SizedBox(height: 4),
              Text("Case: $reason", style: GoogleFonts.poppins()),
              SizedBox(height: 4),
              Text("Phone: $phone", style: GoogleFonts.poppins()),
              SizedBox(height: 10),
              // Buttons
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => launchUrl(Uri.parse("tel:$phone")),
                    icon: Icon(Icons.call, size: 18),
                    label: Text('CALL', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size(0, 32),
                    ),

                    // You can add a visual effect for hover, e.g. change background color
                    // For example, use a ValueNotifier or StatefulWidget for more advanced effects
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Share.share(
                        "Blood Request:\nPatient: $fullName\nBlood Group: $bloodGroup\nNeed: $amount on $date\nLocation: $hospital, $district\nPhone: $phone",
                      );
                    },
                    icon: Icon(Icons.share, size: 18),
                    label: Text("SHARE", style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size(0, 32),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
