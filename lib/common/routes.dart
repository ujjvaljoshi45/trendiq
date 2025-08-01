import 'package:flutter/material.dart';
import 'package:trendiq/views/auth_view/login_view.dart';
import 'package:trendiq/views/auth_view/register_view.dart';
import 'package:trendiq/views/cart/cart_view.dart';
import 'package:trendiq/views/connection_error_screen.dart';
import 'package:trendiq/views/main_view.dart';
import 'package:trendiq/views/profile/address/address_view.dart';
import 'package:trendiq/views/profile/orders/order_view.dart';
import 'package:trendiq/views/profile/support/support.dart';
import 'package:trendiq/views/profile/update_password_view.dart';
import 'package:trendiq/views/search_view/products_list_view.dart';
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
        ? MaterialPageRoute(builder: builder, settings: settings)
        : MaterialPageRoute(builder: (_) => SplashScreen(), settings: settings);
  }

  final Map<String, WidgetBuilder> routeMap = {
    RoutesKey.splash: (_) => const SplashScreen(),
    RoutesKey.login: (_) => const LoginView(),
    RoutesKey.register: (_) => const RegisterView(),
    RoutesKey.home: (_) => const MainView(),
    RoutesKey.connectionErrorScreen: (_) => const ConnectionErrorScreen(),
    RoutesKey.updatePassword: (_) => UpdatePasswordView(),
    RoutesKey.support: (_) => SupportView(),
    RoutesKey.address: (_) => AddressView(),
    RoutesKey.productsList: (_) => ProductsListView(),
    RoutesKey.cart: (_) => CartView(),
    RoutesKey.order: (_) => OrderView(),
  };
}
