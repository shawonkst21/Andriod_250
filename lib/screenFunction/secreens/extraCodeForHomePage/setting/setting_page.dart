import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadNotificationPreference();
  }

  Future<void> loadNotificationPreference() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final isOn = doc.data()?['notificationsEnabled'] ?? true;
        setState(() {
          _notificationsEnabled = isOn;
        });

        // Sync FCM topic
        if (isOn) {
          await FirebaseMessaging.instance.subscribeToTopic('all_users');
        } else {
          await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
        }
      }
    }
  }

  Future<void> updateNotificationPreference(bool value) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      setState(() {
        _notificationsEnabled = value;
      });

      await _firestore.collection('users').doc(uid).set({
        'notificationsEnabled': value,
      }, SetOptions(merge: true));

      if (value) {
        await FirebaseMessaging.instance.subscribeToTopic('all_users');
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
      }
    }
  }

  void showSettingsOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text('Edit Profile', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/editProfile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: Text('Notifications', style: GoogleFonts.poppins()),
                trailing: Switch(
                  value: _notificationsEnabled,
                  activeColor: Colors.red,
                  onChanged: (value) => updateNotificationPreference(value),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('Language', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  // Add language picker navigation here
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text('Logout',
                    style: GoogleFonts.poppins(color: Colors.red)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.poppins()),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: showSettingsOptions,
          )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text("Notifications", style: GoogleFonts.poppins()),
            trailing: Switch(
              value: _notificationsEnabled,
              activeColor: Colors.red,
              onChanged: (value) {
                updateNotificationPreference(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
