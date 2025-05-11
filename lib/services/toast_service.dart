import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static final ToastService _instance = ToastService._();
  ToastService._();
  factory ToastService() => _instance;
  ToastificationStyle toastificationStyle = ToastificationStyle.flatColored;
  // int selected = 1;
  void showToast(String message,
      {bool isError = false, bool isInformation = false, int seconds = 3}) {

    final ToastificationType toastificationType;
    final String title;

    if (isError) {
      toastificationType = ToastificationType.error;
      title = "Error";
    } else if (isInformation) {
      toastificationType = ToastificationType.info;
      title = "Note";
    } else {
      toastificationType = ToastificationType.success;
      title = "Success";
    }
    toastification.show(
      style: toastificationStyle,
      showProgressBar: false,
      showIcon: false,
      type: toastificationType,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
      margin: EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
      autoCloseDuration: Duration(seconds: seconds),
      animationDuration: Duration(milliseconds: 100),
      borderRadius: BorderRadius.circular(6.r),
      dragToClose: true,
      closeOnClick: true,
      alignment: Alignment.bottomCenter,
      title: Text(
        title,
      ),
      description: Text(
        message,
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:toastification/toastification.dart';
// import 'package:trendiq/services/log_service.dart';
//
// class ToastService {
//   static final ToastService _instance = ToastService._();
//   ToastService._();
//   factory ToastService() => _instance;
// void showToast({
//   String title = "",
//   String message = "",
//   bool isError = false,
//   bool isInformation = false,
//   int seconds = 3,
//   bool showProgressIndicator = false,
//   Function(GetSnackBar)? onTap,
// }) {
//
// }
//   // void showToast({
//   //   String title = "",
//   //   String message = "",
//   //   bool isError = false,
//   //   bool isInformation = false,
//   //   int seconds = 3,
//   //   bool showProgressIndicator = false,
//   //   Function(GetSnackBar)? onTap,
//   // }) {
//   //   LogService().logMessage(message);
//   //   Get.snackbar(
//   //     title,
//   //     message,
//   //     snackPosition: SnackPosition.BOTTOM,
//   //     snackStyle: SnackStyle.FLOATING,
//   //     margin: EdgeInsets.fromLTRB(25, 0, 25, 50),
//   //     isDismissible: true,
//   //     barBlur: 1.r,
//   //     overlayBlur: 0.5.r,
//   //     dismissDirection: DismissDirection.horizontal,
//   //     backgroundColor: isError ? Colors.redAccent : Colors.lightGreen,
//   //     onTap: onTap,
//   //     duration: Duration(seconds: seconds),
//   //     colorText: Colors.white,
//   //     showProgressIndicator: showProgressIndicator,
//   //   );
//   // }
// }
