import 'package:flutter/material.dart';
import 'package:trendiq/views/connection_error_screen.dart';
import 'package:trendiq/views/home/home.dart';
import 'package:trendiq/views/splash_screen.dart';

import '../constants/route_key.dart';

class Routes {
  static final _instance = Routes._internal();
  Routes._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  factory Routes() => _instance;
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routeMap[settings.name];
    return builder != null
        ? MaterialPageRoute(builder: builder)
        : MaterialPageRoute(builder: (_) => SplashScreen());
  }

  final Map<String, WidgetBuilder> routeMap = {
    RoutesKey.splash: (_) => const SplashScreen(),
    RoutesKey.home: (_) => const HomeView(),
    RoutesKey.connectionErrorScreen: (_) => const ConnectionErrorScreen(),
  };
}

