import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:trendiq/common/routes.dart';
import 'package:trendiq/services/toast_service.dart';

import '../constants/route_key.dart';

class ConnectivityService {
  ConnectivityService._();
  static final _instance = ConnectivityService._();
  factory ConnectivityService() => _instance;
  late final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> connectionStream;
  bool isFromSplash = false;
  bool isScreenActive = false;

  void init() {
    _connectivity = Connectivity();
    _initService();
  }

  _initService() {
    connectionStream = _connectivity.onConnectivityChanged;
    _initConnectionStreamListener();
  }

  _initConnectionStreamListener() {
    connectionStream.listen((event) async {
      if (event.last == ConnectivityResult.none) {
        await checkConnectionAndNavigate();
      }
    },);
  }

  Future<bool> pingConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> checkConnectionAndNavigate() async {
    if (isScreenActive) {
      return false;
    }
    try {
      if (!(await pingConnection())) {
        Navigator.pushNamed(Routes().navigatorKey.currentContext!, RoutesKey.connectionErrorScreen);
        return true;
      }
    } catch (e) {
      toast("No Internet Connection");
    }
    return false;
  }

}