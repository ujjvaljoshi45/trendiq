import 'package:flutter/material.dart';

extension SizeBox on num {
  SizedBox get sBh => SizedBox(height: toDouble());
  SizedBox get sBw => SizedBox(width: toDouble());
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}