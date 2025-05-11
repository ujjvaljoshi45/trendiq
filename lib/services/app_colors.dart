import 'package:flutter/material.dart';

final appColors = AppColors();

class AppColors {
  static final _instance = AppColors._();

  AppColors._();

  factory AppColors() => _instance;

  bool isDark = false;

  Color get background =>
      isDark ? _DarkColors.background : _LightColors.background;

  Color get onBackground =>
      isDark ? _DarkColors.onBackground : _LightColors.onBackground;

  Color get surface => isDark ? _DarkColors.surface : _LightColors.surface;

  Color get onSurface =>
      isDark ? _DarkColors.onSurface : _LightColors.onSurface;

  Color get surfaceVariant =>
      isDark ? _DarkColors.surfaceVariant : _LightColors.surfaceVariant;

  Color get onSurfaceVariant =>
      isDark ? _DarkColors.onSurfaceVariant : _LightColors.onSurfaceVariant;

  Color get primary => isDark ? _DarkColors.primary : _LightColors.primary;

  Color get onPrimary =>
      isDark ? _DarkColors.onPrimary : _LightColors.onPrimary;

  Color get secondary =>
      isDark ? _DarkColors.secondary : _LightColors.secondary;

  Color get onSecondary =>
      isDark ? _DarkColors.onSecondary : _LightColors.onSecondary;

  Color get tertiary => isDark ? _DarkColors.tertiary : _LightColors.tertiary;

  Color get onTertiary =>
      isDark ? _DarkColors.onTertiary : _LightColors.onTertiary;

  Color get tertiaryContainer =>
      isDark ? _DarkColors.tertiaryContainer : _LightColors.tertiaryContainer;

  Color get onTertiaryContainer =>
      isDark
          ? _DarkColors.onTertiaryContainer
          : _LightColors.onTertiaryContainer;

  Color get error => isDark ? _DarkColors.error : _LightColors.error;

  Color get onError => isDark ? _DarkColors.onError : _LightColors.onError;

  Color get outline => isDark ? _DarkColors.outline : _LightColors.outline;

  Color get surfaceTint =>
      isDark ? _DarkColors.surfaceTint : _LightColors.surfaceTint;

  Color get shadow => isDark ? _DarkColors.shadow : _LightColors.shadow;

  //region Common Colors
  Color get white => Color(0xffffffff);

  Color get black => Color(0xff000000);
  //endregion
}

// Light mode colors
abstract class _LightColors {
  static const background = Color(0xFFFFFFFF);
  static const onBackground = Color(0xFF1A1A1A);

  static const surface = Color(0xFFFFFAFA);
  static const onSurface = Color(0xFF262626);

  static const surfaceVariant = Color(0xFFFFFFFF);
  static const onSurfaceVariant = Color(0xFF1A1A1A);

  static const primary = Color(0xFFDC2626);
  static const onPrimary = Color(0xFFFFFFFF);

  static const secondary = Color(0xFFF5DADA);
  static const onSecondary = Color(0xFF000000);

  static const tertiary = Color(0xFFFDF5F5);
  static const onTertiary = Color(0xFF666666);

  static const tertiaryContainer = Color(0xFFFAEEEE);
  static const onTertiaryContainer = Color(0xFF262626);

  static const error = Color(0xFFFF0000);
  static const onError = Color(0xFFFFFFFF);

  static const outline = Color(0xFFD9D9D9);
  static const surfaceTint = Color(0xFF993333);
  static const shadow = Color(0xFFDC2626);
}

// Dark mode colors
abstract class _DarkColors {
  static const background = Color(0xFF1A1A1A);
  static const onBackground = Color(0xFFFFFFFF);

  static const surface = Color(0xFF1A1A1A);
  static const onSurface = Color(0xFFFFFFFF);

  static const surfaceVariant = Color(0xFF0D0D0D);
  static const onSurfaceVariant = Color(0xFFFFFFFF);

  static const primary = Color(0xFFDC2626);
  static const onPrimary = Color(0xFFFFFFFF);

  static const secondary = Color(0xFF661010);
  static const onSecondary = Color(0xFFFFFFFF);

  static const tertiary = Color(0xFF403030);
  static const onTertiary = Color(0xFFCCCCCC);

  static const tertiaryContainer = Color(0xFF332020);
  static const onTertiaryContainer = Color(0xFFF2F2F2);

  static const error = Color(0xFFFF0000);
  static const onError = Color(0xFFFFFFFF);

  static const outline = Color(0xFF803232);
  static const surfaceTint = Color(0xFF993333);
  static const shadow = Color(0xFFDC2626);
}
