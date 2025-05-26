import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static final _instance = FCMService._();

  FCMService._();

  final fcm = FirebaseMessaging.instance;

  factory FCMService() => _instance;
  bool isDone = false;

  void getPermissions() async {
    if (isDone) {
      return;
    }
    await fcm.requestPermission();
    isDone = true;
  }

  Future<String?> generateNewToken() async {
    String? token;
    if (Platform.isIOS) {
      if (await fcm.getAPNSToken() != null) {
        token = await fcm.getToken();
      }
    } else {
      token = await fcm.getToken();
    }
    return token;
  }
}
