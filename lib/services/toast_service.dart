import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:trendiq/constants/fonts.dart';

void toast(
  String message, {
  bool isError = false,
  bool isInformation = false,
  int second = 3,
}) => ToastService().showToast(
  message,
  isError: isError,
  isInformation: isInformation,
  seconds: second,
);

class ToastService {
  static final ToastService _instance = ToastService._();

  ToastService._();

  factory ToastService() => _instance;
  ToastificationStyle toastificationStyle = ToastificationStyle.minimal;

  void showToast(
    String message, {
    bool isError = false,
    bool isInformation = false,
    int seconds = 3,
  }) {
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
        message,
        style: commonTextStyle(fontFamily: Fonts.fontMedium),
      ),
    );
  }
}
