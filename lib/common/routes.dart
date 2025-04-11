import 'package:flutter/material.dart';
import 'package:trendiq/views/splash_screen.dart';

class Routes {
  static final _instance = Routes._internal();
  Routes._internal();
  factory Routes() => _instance;
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ('splash'):
        return MaterialPageRoute(builder: (context) => SplashScreen());
      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
