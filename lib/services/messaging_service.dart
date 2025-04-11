import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:trendiq/models/fcm_data.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/services/shared_pref_service.dart';

class MessagingService {
  MessagingService._();
  static final MessagingService _instance = MessagingService._();
  factory MessagingService() => _instance;
  final fcm = FirebaseMessaging.instance;

  void init() async {
    getPermissions();
    FcmData? fcmData = await getTokenFromStorage();
    if (fcmData == null) {
      fcmData = await generateNewFcmData();
    } else if (fcmData.createdAt.difference(DateTime.now()) >=
        Duration(days: 30)) {
      fcmData = await generateNewFcmData();
    }
    LogService().logMessage(fcmData.toString());
  }

  void getPermissions() async => await fcm.requestPermission();

  Future<FcmData?> getTokenFromStorage() async {
    String? data = await Storage().getFcmData();
    if (data == null) {
      return null;
    }
    return FcmData.fromString(data);
  }

  Future<void> saveTokenToStorage(FcmData fcmData) async =>
      await Storage().saveFcmData(fcmData.toString());

  Future<void> saveFcmToServer(FcmData fcmData) async {
    // call api controller and add data;
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

  Future<FcmData?> generateNewFcmData() async {
    String? token = await generateNewToken();

    if (token == null) {
      return null;
    } else {
      FcmData fcmData = FcmData(token: token, createdAt: DateTime.now());

      await saveTokenToStorage(fcmData);
      await saveFcmToServer(fcmData);

      return fcmData;
    }
  }
}
