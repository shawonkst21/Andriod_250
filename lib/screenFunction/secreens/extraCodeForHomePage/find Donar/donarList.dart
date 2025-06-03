import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Donarlist extends StatelessWidget {
  final String name;
  final String address;
  final String bloodGroup;
  final String phone;
  final bool isAvailable;

  const Donarlist({
    super.key,
    required this.name,
    required this.address,
    required this.bloodGroup,
    required this.phone,
    required this.isAvailable,
  });
  void showSMSOptions(BuildContext context) async {
    final smsUri = Uri.parse("sms:$phone");
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    }
  }

  void dialPhone() async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void showDonorDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                children: [
                  Text(
                    "Details Information",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Avatar
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/shawon.jpg'),
              ),

              const SizedBox(height: 20),

              // Info
              buildInfoRow("Name", name),
              buildInfoRow("Address", address),
              buildInfoRow("Mobile Number", phone),
              buildInfoRow("Current Status",
                  isAvailable ? "Ready for Donate" : "Not Available"),
              buildInfoRow("Total Donations", "05"),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.red, size: 20),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "$label: ",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Stack(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          Positioned(
              top: 16,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/shawon.jpg',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )),
          Positioned(
              top: 15,
              left: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        bloodGroup,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    address,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  //SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        isAvailable ? "🟢 Available " : "🔴 Not available",
                        style: TextStyle(
                          color: isAvailable ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: isAvailable ? 50 : 30),

                      // Message Button
                      GestureDetector(
                        onTap: () {
                          if (isAvailable) {
                            showSMSOptions(context);
                          } else {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Unavailable',
                                message:
                                    'This donor is not available right now.',
                                contentType: ContentType.failure,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.message,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Call Button
                      GestureDetector(
                        onTap: isAvailable ? dialPhone : null,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
          Positioned(
              bottom: 5,
              left: 12,
              child: OutlinedButton(
                onPressed: () => showDonorDetails(context),
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(), // Rounded pill shape
                  side: BorderSide(color: Colors.grey.shade300), // Light border
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                      color: Colors.grey), // Optional: match text color
                ),
              ))
        ],
      ),
    );
  }
}
