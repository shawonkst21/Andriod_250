import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendNotificationUsingV1API({
  required String title,
  required String body,
  required String requestId,
  required String requesterName,
  required String bloodGroup,
  required String district,
}) async {
  // Step 1: Load service account JSON from assets
  final jsonString = await rootBundle.loadString('assets/blood_key.json');

  // Step 2: Parse both the credentials and the project_id
  final credentials = ServiceAccountCredentials.fromJson(jsonString);
  final Map<String, dynamic> serviceAccountMap = jsonDecode(jsonString);
  final String projectId = serviceAccountMap['project_id'];

  // Step 3: Define FCM scope and get authenticated client
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final http.Client client = await clientViaServiceAccount(credentials, scopes);

  // Step 4: Build the FCM send URL
  final String url =
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  // Step 5: Fetch users and current user ID
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final QuerySnapshot usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  for (final doc in usersSnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;

    if (data.containsKey('fcmToken')) {
      final String token = data['fcmToken'];

      // Step 6: Construct the message payload
      final Map<String, dynamic> message = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "HIGH",
            "notification": {
              "sound": "default",
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
            }
          },
          "apns": {
            "headers": {"apns-priority": "10"}
          },
          "data": {
            "type": "urgent_request",
            "senderId": currentUserId ?? "",
            "requestId": requestId,
            "fullName": requesterName,
            "bloodGroup": bloodGroup,
            "district": district
          }
        }
      };

      // Step 7: Send the HTTP POST
      try {
        final http.Response response = await client.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          print('✅ Notification sent to ${doc.id}');
        } else {
          print(
              '❌ Failed for ${doc.id}: ${response.statusCode} ${response.body}');
        }
      } catch (e) {
        print('🔥 Error sending to ${doc.id}: $e');
      }
    }
  }

  client.close(); // Step 8: Clean up
}
