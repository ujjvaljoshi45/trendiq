import 'package:flutter/material.dart';

abstract class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeStateLight extends ThemeState {
  const ThemeStateLight() : super(ThemeMode.light);
}

class ThemeStateDark extends ThemeState {
  const ThemeStateDark() : super(ThemeMode.dark);
}
