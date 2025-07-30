import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:trendiq/generated/assets.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/connectivity_service.dart';

import '../constants/route_key.dart';
import '../services/payment/payment_service.dart';

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
        getConfigs();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.secondary,
      body: Center(
        child: Image.asset(Assets.assetsLogo, width: 150, height: 150),
      ),
    );
  }

  void getConfigs() async {
    final response = await apiController.getConfigs();
    if (response.isError) {
      return;
    }
    Stripe.publishableKey = PaymentService().strStripPublishableKey;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RoutesKey.home, (route) => false);
    // if (response.data?["version"] == "1") {
    //   Stripe.publishableKey = PaymentService().strPass;
    //   Navigator.of(
    //     context,
    //   ).pushNamedAndRemoveUntil(RoutesKey.home, (route) => false);
    // } else {
    //   toast("Please Update your app");
    //   exit(-1);
    // }
  }
}
