import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:trendiq/constants/fonts.dart';

class ToastService {
  static final ToastService _instance = ToastService._();
  ToastService._();
  factory ToastService() => _instance;
  ToastificationStyle toastificationStyle = ToastificationStyle.minimal;
  // int selected = 1;
  void showToast(String message,
      {bool isError = false, bool isInformation = false, int seconds = 3}) {

    final ToastificationType toastificationType;
    if (isError) {
      toastificationType = ToastificationType.error;

    } else if (isInformation) {
      toastificationType = ToastificationType.info;

    } else {
      toastificationType = ToastificationType.success;
    }
    toastification.show(
      style: ToastificationStyle.fillColored,
      showProgressBar: false,
      showIcon: false,
      type: toastificationType,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      autoCloseDuration: Duration(seconds: seconds),
      animationDuration: Duration(milliseconds: 100),
      borderRadius: BorderRadius.circular(6.r),
      dragToClose: true,
      closeOnClick: false,
      alignment: Alignment.bottomCenter,
      borderSide: BorderSide(width: 0),

      title: Text(
        message,style: commonTextStyle(fontFamily: Fonts.fontMedium),
      )
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
