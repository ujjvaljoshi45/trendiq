import 'package:flutter/material.dart';
import 'package:trendiq/generated/assets.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/connectivity_service.dart';

import '../constants/route_key.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() async {
      if (await ConnectivityService().checkConnectionAndNavigate()) {
        ConnectivityService().isFromSplash = false;
      } else {
        mounted
            ? Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(RoutesKey.home, (route) => false)
            : null;
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.secondary,
      body: Center(child: Image.asset(Assets.assetsLogo, width: 150, height: 150,),),
    );
  }
}
