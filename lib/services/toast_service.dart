import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trendiq/services/log_service.dart';

class ToastService {
  static final ToastService _instance = ToastService._();
  ToastService._();
  factory ToastService() => _instance;
  void showToast({
    String title = "",
    String message = "",
    bool isError = false,
    bool isInformation = false,
    int seconds = 3,
    bool showProgressIndicator = false,
    Function(GetSnackBar)? onTap,
  }) {
    Get.log(title, isError: isError);
    LogService().logMessage(message);
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.fromLTRB(25, 0, 25, 50),
      isDismissible: true,
      barBlur: 1.r,
      overlayBlur: 0.5.r,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: isError ? Colors.redAccent : Colors.lightGreen,
      onTap: onTap,
      duration: Duration(seconds: seconds),
      colorText: Colors.white,
      showProgressIndicator: showProgressIndicator,
    );
  }
}
