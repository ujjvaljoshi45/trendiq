import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/connectivity_service.dart';

class ConnectionErrorScreen extends StatefulWidget {
  const ConnectionErrorScreen({super.key});

  @override
  State<ConnectionErrorScreen> createState() => _ConnectionErrorScreenState();
}

class _ConnectionErrorScreenState extends State<ConnectionErrorScreen> {
  bool _isLoading = false;
  bool isOnExit = false;

  @override
  void initState() {
    ConnectivityService().isScreenActive = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          ConnectivityService().connectionStream.listen((event) async {
            if (event.last != ConnectivityResult.none) {
              if (isOnExit) {
                return;
              }
              _handleRetry();
            }
          }),
    );
    super.initState();
  }

  @override
  void dispose() {
    ConnectivityService().isScreenActive = false;
    super.dispose();
  }

  void onExit() {
    if (isOnExit) {
      return;
    }
    isOnExit = true;
    if (ConnectivityService().isFromSplash) {
      ConnectivityService().isFromSplash = false;
      Navigator.pushNamed(context, '/');
    } else {
      Navigator.pop(context);
    }
  }

  void _handleRetry() async {
    setState(() => _isLoading = true);
    final result = (await ConnectivityService().pingConnection());
    setState(() => _isLoading = false);
    result ? onExit() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              Text(
                'Connection Lost',
                style: commonTextStyle(
                  fontSize: 18,
                  fontFamily: Fonts.fontSemiBold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: commonTextStyle(
                  fontFamily: Fonts.fontMedium,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleRetry,
                  child:
                      _isLoading
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: loadingIndicator(),
                          )
                          : Text(
                            'Retry',
                            style: commonTextStyle(
                              fontSize: 16,
                              fontFamily: Fonts.fontBold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
