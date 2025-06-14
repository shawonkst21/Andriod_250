import 'package:animate_do/animate_do.dart';
import 'package:blood_donar/introduceApp/onbroadingScreen.dart';
import 'package:blood_donar/log/sign/login.dart';
import 'package:blood_donar/screenFunction/secreens/HomePage.dart';
import 'package:blood_donar/screenFunction/secreens/blood%20request.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/blood%20request/near_request.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/find%20Donar/find_donar.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/notifications/all_notifcation.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/organization/listof_orga.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/organization/Add_organizationinfo.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/urgent%20Request/urgentReq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

// Global navigator key for showing dialogs and navigation outside widget context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 255, 255, 255),
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeLocalNotifications();
    setupFCM();
  }

  void initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      final actionId = response.actionId;
      if (actionId == 'donate_action') {
        print('💓 User tapped "I Can Donate" button');
        final FirebaseAuth auth = FirebaseAuth.instance;
        final user = auth.currentUser;

        if (user != null &&
            response.payload != null &&
            response.payload!.isNotEmpty) {
          final firestore = FirebaseFirestore.instance;
          await firestore.collection('donationIntents').add({
            'donorId': user.uid,
            'requestId': response.payload,
            'timestamp': Timestamp.now(),
          });
          _showThankYouDialog();
        } else if (actionId == 'ignore_action') {
          print('🚫 User tapped "Ignore" button');
          // You can add logic here if needed
        } else {
          print('🔔 Notification tapped without action button');
          // You can navigate to a screen if you want
        }
      }
    });
  }

  Future<void> _showThankYouDialog() async {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) => ZoomIn(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Thank you!',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.redAccent,
            ),
          ),
          content: Text(
            'Thanks for your willingness to donate. We will share requester contact details soon.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    print("🔑 FCM Token: $token");

    // TODO: Save token to Firestore under current logged-in user

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('📨 Foreground message: ${message.notification?.title}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Get current user
      final user = FirebaseAuth.instance.currentUser;

      if (notification != null && android != null && user != null) {
        // 💾 Save notification to Firestore
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': user.uid,
          'title': notification.title ?? '',
          'body': notification.body ?? '',
          'requestId': message.data['requestId'] ?? '',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'urgent_requests',
              'Urgent Requests',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction(
                  'donate_action',
                  'I Can Donate',
                  showsUserInterface: true,
                ),
                AndroidNotificationAction(
                  'ignore_action',
                  'Ignore',
                  showsUserInterface: false,
                ),
              ],
            ),
          ),
          payload: message.data['requestId'] ?? '',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // << Important for dialogs & navigation
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const Homepage(),
        '/findDonor': (context) => const FindDonorScreen(),
        '/requestlist': (context) => const nearRequest(),
        '/addrequest': (context) => const BloodRequest(),
        '/urgentRequest': (context) => const Urgentreq(),
        '/organizationInfo': (context) => const Organizationinfo(),
        '/organizationList': (context) => const Organization_list(),
        '/NotificationScreen': (context) => const NotificationScreen(),
      },
    );
  }
}
