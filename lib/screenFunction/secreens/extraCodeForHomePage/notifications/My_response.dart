import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MyResponsesScreen extends StatelessWidget {
  const MyResponsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    print("👤 Current User ID: ${currentUser!.uid}");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Responses",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 125, 11, 2),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donationIntents')
            .where('donorId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final responses = snapshot.data?.docs ?? [];

          if (responses.isEmpty) {
            return Center(
              child: Text(
                "You haven't responded to any requests yet.",
                style: GoogleFonts.poppins(),
              ),
            );
          }

          return ListView.builder(
            itemCount: responses.length,
            itemBuilder: (context, index) {
              final response = responses[index];
              final requestId = response['requestId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('requests')
                    .doc(requestId)
                    .get(),
                builder: (context, requestSnapshot) {
                  if (requestSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: LinearProgressIndicator(),
                    );
                  }

                  if (!requestSnapshot.hasData ||
                      !requestSnapshot.data!.exists) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Request data not found",
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }

                  final request = requestSnapshot.data!;
                  final requesterName = request['fullName'] ?? 'Unknown';
                  final phone = request['phone'] ?? '';
                  final hospital = request['hospital'] ?? '';
                  final bloodGroup = request['bloodGroup'] ?? '';
                  final amount = request['amount'] ?? '';
                  final date = request['date'] ?? '';

                  return ZoomIn(
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.red.shade300,
                          width: 1,
                        ),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Blood Group: ',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  bloodGroup,
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  FlutterIcons.blood_bag_mco,
                                  size: 18,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(amount, style: GoogleFonts.poppins()),
                                IconButton(
                                  icon: const Icon(FlutterIcons.delete_ant,
                                      color: Colors.grey),
                                  onPressed: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,
                                      title: 'Cancel Donation',
                                      desc:
                                          'Are you sure you want to remove your response to this request?',
                                      btnCancelOnPress: () {},
                                      btnCancelText: 'No',
                                      btnOkText: 'Yes',
                                      //  btnOkColor: Colors.red,
                                      btnOkOnPress: () async {
                                        await FirebaseFirestore.instance
                                            .collection('donationIntents')
                                            .doc(response.id)
                                            .delete();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Successfully removed your response.",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                // fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            duration:
                                                const Duration(seconds: 3),
                                          ),
                                        );
                                      },
                                    ).show();
                                  },
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 1,
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(FlutterIcons.person_mdi),
                                Text(
                                  " Requester: $requesterName",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Row(
                              children: [
                                Icon(FlutterIcons.medical_bag_mco,
                                    color: Colors.red),
                                Text(
                                  " Hospital: $hospital",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 45,
                                ),
                                Positioned(
                                  child: Row(
                                    children: [
                                      Icon(FlutterIcons.calendar_account_mco),
                                      Text(" date: $date",
                                          style: GoogleFonts.poppins()),
                                      const SizedBox(width: 30),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 0,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        launchUrl(Uri.parse("tel:$phone")),
                                    icon: const Icon(Icons.call, size: 18),
                                    label: const Text('CALL',
                                        style: TextStyle(fontSize: 12)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      minimumSize: const Size(0, 32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
