import 'package:blood_donar/introduceApp/onbroadingScreen.dart';
import 'package:blood_donar/log/sign/login.dart';
import 'package:blood_donar/screenFunction/secreens/HomePage.dart';
import 'package:blood_donar/screenFunction/secreens/blood%20request.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/blood%20request/near_request.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/find%20Donar/find_donar.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/organization/listof_orga.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/organization/Add_organizationinfo.dart';
import 'package:blood_donar/screenFunction/secreens/extraCodeForHomePage/urgent%20Request/urgentReq.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // System UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 255, 255, 255),
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Ask notification permission
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

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the token
    String? token = await messaging.getToken();
    print("🔑 FCM Token: $token");

    // TODO: Save this token in Firestore under the logged-in user after login

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground message: ${message.notification?.title}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
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
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
