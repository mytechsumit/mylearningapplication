import 'package:flutter/material.dart';
import 'package:mylearningapplication/nativeserachabledropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// जेव्हा ॲप बॅकग्राउंडमध्ये किंवा बंद असेल आणि नोटिफिकेशन येईल, तेव्हा हा फंक्शन रन होतो
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("बॅकग्राउंड मेसेज आला: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // १. Firebase इनिशियलाईझ करा
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // २. बॅकग्राउंड हँडलर रजिस्टर करा
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  void _setupPushNotifications() async {
    // १. युझरकडून नोटिफिकेशन दाखवण्याची परवानगी (Permission) मागा (विशेषतः iOS आणि Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('युझरने परवानगी दिली!');

      // २. या डिव्हाईसचा युनिक टोकन (FCM Token) मिळवा
      String? token = await _firebaseMessaging.getToken(
        vapidKey: "BPFBBiQxiVZ4sAxunMIhJXQ0WDnB-LBHPyUIkXmOnytgc0qle_eXoeiAA_nG3TWf6LeI--MZC244NtkHrgK4jQA"
      );
      print("तुमच्या डिव्हाईसचा FCM Token: $token");

      // ३. जेव्हा ॲप चालू (Foreground) असेल आणि नोटिफिकेशन येईल
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('ॲप चालू असताना मेसेज आला!');
        if (message.notification != null) {
          print('Title: ${message.notification!.title}');
          print('Body: ${message.notification!.body}');
        }
      });

      // ४. जेव्हा युझर नोटिफिकेशनवर क्लिक करून ॲप ओपन करतो
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('युझरने नोटिफिकेशनवर क्लिक केले!');
      });
    } else {
      print('युझरने परवानगी नाकारली.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final List<String> course = ["Select Course", "Flutter Dev", "Dart", "Java", "Python"];
  String? selectedValue;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Adjusted duration for a better feel
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Learning App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Hello Sumit I am Working Fine For You!"),
                  ),
                );
                ScaffoldMessenger.of(context).showMaterialBanner(
                  MaterialBanner(
                    content: const Text("Hii this is Material Banner."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );

                Future.delayed(const Duration(milliseconds: 3000), () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  }
                });
              },
              child: const Text("Click me !"),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text("Select Choice"),
              value: selectedValue ?? course[0],
              items: course.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });

                if (value != null && value != "Select Course") {
                  _animationController.reset();
                  _animationController.forward();

                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  ScaffoldMessenger.of(context).showMaterialBanner(
                    MaterialBanner(
                      content: Text("You have selected $value"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                      shadowColor: Colors.amber,
                      backgroundColor: Colors.green.shade100,
                      // Note: MaterialBanner animation handling is usually internal,
                      // but we keep the controller for potential custom use or sync.
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'निवडलेले शहर: ${selectedValue ?? "None"}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            NativeSearchableDropDown(
              items: course,
              hintText: 'Select Course',
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
