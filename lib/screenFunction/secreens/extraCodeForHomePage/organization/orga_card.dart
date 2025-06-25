import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrgaCard extends StatelessWidget {
  final String name;
  final String city;
  final String country;
  final String totaldonars;
  final String phone;

  const OrgaCard({
    super.key,
    required this.name,
    required this.city,
    required this.country,
    required this.totaldonars,
    required this.phone,
  });

  void showSMSOptions() async {
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
      builder: (_) => AlertDialog(
        title: Text('Organization: $name'),
        content: Text(
            'Total Donors: $totaldonars\nPhone: $phone\nAddress: $city, $country'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final address = "$city, $country";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ZoomIn(
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
            // color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FlutterIcons.group_faw,
                    //  color: const Color.fromARGB(255, 125, 11, 2),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      name.trim(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 125, 11, 2),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey[700],
                    size: 16,
                  ),
                  Text(
                    address,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.grey[700],
                    size: 16,
                  ),
                  Text("Phone: $phone",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      )),
                  SizedBox(
                    width: 60,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: showSMSOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
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
                      GestureDetector(
                        onTap: dialPhone,
                        child: Container(
                          padding: const EdgeInsets.all(8),
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
                  ),
                ],
              ),
              // const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.grey[700],
                    size: 16,
                  ),
                  Text(
                    ': $totaldonars donors',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      //fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Actions
              /*  Row(
                children: [
                  GestureDetector(
                    onTap: showSMSOptions,
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
                  GestureDetector(
                    onTap: dialPhone,
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
              ),
        
              const SizedBox(height: 10),
        
              // View Details Button
                Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => showDonorDetails(context),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
