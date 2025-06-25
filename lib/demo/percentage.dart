import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DonorStatusPage extends StatefulWidget {
  const DonorStatusPage({super.key});

  @override
  State<DonorStatusPage> createState() => _DonorStatusPageState();
}

class _DonorStatusPageState extends State<DonorStatusPage> {
  final int totalCycleDays = 90;
  DateTime? lastDonationDate;
  bool isLoading = true;
  int daysPassed = 0;
  double progressPercent = 0.0;
  bool canDonate = false;

  @override
  void initState() {
    super.initState();
    fetchDonationData();
  }

  Future<void> fetchDonationData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc['lastDonationDate'] != null) {
        Timestamp lastDonation = userDoc['lastDonationDate'];
        lastDonationDate = lastDonation.toDate();
        daysPassed = DateTime.now().difference(lastDonationDate!).inDays;
        progressPercent = (daysPassed / totalCycleDays).clamp(0.0, 1.0);
        canDonate = daysPassed >= totalCycleDays;
      }
    } catch (e) {
      debugPrint("Error fetching donation data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Status"),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : lastDonationDate == null
                ? const Text("No donation data available.")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Regeneration Cycle",
                          style: TextStyle(fontSize: 18, color: Colors.red)),
                      const SizedBox(height: 20),

                      /// Circular progress
                      CircularPercentIndicator(
                        radius: 65.0,
                        lineWidth: 10.0,
                        animation: true,
                        percent: progressPercent,
                        center: CircleAvatar(
                          radius: 53,
                          backgroundImage: AssetImage('assets/shawon.jpg'),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.red,
                        backgroundColor: Colors.red.shade100,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        canDonate
                            ? "You are eligible to donate again"
                            : "${totalCycleDays - daysPassed} days remaining",
                        style: TextStyle(
                          color: canDonate ? Colors.green : Colors.grey,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: canDonate ? donateNow : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: const Text("Donate Now"),
                      ),
                    ],
                  ),
      ),
    );
  }

  void donateNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for donating!")),
    );

    // Optionally: Update Firestore donation date
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'lastDonationDate': DateTime.now()});
    }

    // Refresh data
    setState(() {
      isLoading = true;
    });
    fetchDonationData();
  }
}
