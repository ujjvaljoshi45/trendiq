// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:trendyq/app/auth/signin.dart';
// import 'package:trendyq/app/auth/signup.dart';
// import 'package:trendyq/app/main.dart';
// import 'package:trendyq/app/onboarding.dart';
// import 'package:trendyq/app/splash.dart';
// import 'package:trendyq/constants/path.dart';

// abstract class NavigationService {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static final GoRouter router = GoRouter(
//     navigatorKey: navigatorKey,
//     initialLocation: AppPath.splash,
//     routes: <RouteBase>[
//       GoRoute(
//         path: AppPath.splash,
//         builder: (context, state) => SplashScreen(),
//       ),
//       GoRoute(
//         path: AppPath.onboarding,
//         builder: (context, state) => OnboardingScreen(),
//       ),
//       GoRoute(
//         path: AppPath.signIn,
//         builder: (context, state) => SignInScreen(),
//       ),
//       GoRoute(
//         path: AppPath.signUp,
//         builder: (context, state) => SignUpScreen(),
//       ),
//       GoRoute(
//         path: AppPath.main,
//         builder: (context, state) => MainScreen(),
//       ),
//     ],
//   );
// }
