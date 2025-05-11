import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';
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
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          "TrendiQ",
          style: commonTextStyle(fontSize: 24, fontFamily: "Poppins-Bold"),
        ),
      ),
    );
  }
}
