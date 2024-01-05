import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotification {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static Future init() async {
    final settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (kDebugMode) {
      print("Fire base authorizationStatus : ${settings.authorizationStatus}");
    }
    final token = firebaseMessaging.getToken();
    if (kDebugMode) {
      print("Device token :$token");
    }
  }
}
