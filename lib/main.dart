import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pushnotification/firebase_options.dart';

import 'pushnotification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  PushNotification.init();
  FirebaseMessaging.onBackgroundMessage(_futureBackgroundMessage);
  runApp(const MyApp());
}

Future<void> _futureBackgroundMessage(RemoteMessage message) async {
  debugPrint("back ground");
  debugPrint("onBackground_title : ${message.notification!.title}");
  debugPrint("onBackground_body : ${message.notification!.body}");
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String notificationMessage = "Waiting for Notification";
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      setState(() {
        if (event != null) {
          notificationMessage =
              "${event.notification!.title}, ${event.notification!.body} i am from terminated";
        }
      });
    });
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        notificationMessage =
            "${event.notification!.title}, ${event.notification!.body} i am from froground";
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        notificationMessage =
            "${event.notification!.title}, ${event.notification!.body} i am from background";
      });
    });
  }

  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              notificationMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
