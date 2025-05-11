import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';

abstract class MyColors {
  static const Color primaryColor = Color(0xFFDC2626);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: MyColors.primaryColor,
  colorScheme: ColorScheme.light(
    primary: MyColors.primaryColor,
    secondary: MyColors.primaryColor,
  ),
  fontFamily: Fonts.fontRegular,
  appBarTheme: AppBarTheme(
    backgroundColor: MyColors.primaryColor,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: MyColors.primaryColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MyColors.primaryColor,
      foregroundColor: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: Fonts.fontRegular,
  primaryColor: MyColors.primaryColor,
  colorScheme: ColorScheme.dark(
    primary: MyColors.primaryColor,
    secondary: MyColors.primaryColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: MyColors.primaryColor,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: MyColors.primaryColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MyColors.primaryColor,
      foregroundColor: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
  ),
);
