import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String notificationTitle = "No Notification";
  String notificationBody = "";

  @override
  void initState() {
    super.initState();
    setupFCM();
  }

  void setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission();

    print("Permission: ${settings.authorizationStatus}");

    // Get token
    String? token = await messaging.getToken();
    print("Device Token: $token");

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notificationTitle = message.notification?.title ?? "";
        notificationBody = message.notification?.body ?? "";
      });

      print("*******Message received!*******");

      // ✅ POPUP
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? ""),
          content: Text(message.notification?.body ?? ""),
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("FCM Lab")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(notificationTitle, style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text(notificationBody),
            ],
          ),
        ),
      ),
    );
  }
}