import 'package:flutter/material.dart';

abstract class Fonts {
  static String fontRegular = "Poppins-Regular";
  static String fontMedium = "Poppins-Medium";
  static String fontBold = "Poppins-Bold";
  static String fontSemiBold = "Poppins-SemiBold";
  static String fontExtraBold = "Poppins-ExtraBold";
}

TextStyle commonTextStyle({
  double? fontSize,
  Color? color,
  String? fontFamily,
  double? height,
  FontWeight? fontWeight,
}) => TextStyle(
  fontSize: fontSize,
  color: color,
  fontFamily: fontFamily ?? Fonts.fontRegular,
  height: height,fontWeight: fontWeight
);

TextStyle headerTextStyle({double? fontSize, Color? color}) => commonTextStyle(
  fontSize: fontSize ?? 24,
  fontFamily: Fonts.fontBold,
  color: color
);