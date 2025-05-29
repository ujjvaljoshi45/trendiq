import 'package:flutter/material.dart';

final appColors = AppColors();

class AppColors {
  static final _instance = AppColors._();

  AppColors._();

  factory AppColors() => _instance;

  bool _isDark = false;
  bool get isDark => _isDark;
  void setIsDark(bool val) =>  _isDark = val;

  Color get background =>
      _isDark ? _DarkColors.background : _LightColors.background;
  Color get transparent => Colors.transparent;

  Color get onBackground =>
      _isDark ? _DarkColors.onBackground : _LightColors.onBackground;

  Color get surface => _isDark ? _DarkColors.surface : _LightColors.surface;

  Color get onSurface =>
      _isDark ? _DarkColors.onSurface : _LightColors.onSurface;

  Color get surfaceVariant =>
      _isDark ? _DarkColors.surfaceVariant : _LightColors.surfaceVariant;

  Color get onSurfaceVariant =>
      _isDark ? _DarkColors.onSurfaceVariant : _LightColors.onSurfaceVariant;

  Color get primary => _isDark ? _DarkColors.primary : _LightColors.primary;

  Color get onPrimary =>
      _isDark ? _DarkColors.onPrimary : _LightColors.onPrimary;

  Color get secondary =>
      _isDark ? _DarkColors.secondary : _LightColors.secondary;

  Color get onSecondary =>
      _isDark ? _DarkColors.onSecondary : _LightColors.onSecondary;

  Color get tertiary => _isDark ? _DarkColors.tertiary : _LightColors.tertiary;

  Color get onTertiary =>
      _isDark ? _DarkColors.onTertiary : _LightColors.onTertiary;

  Color get tertiaryContainer =>
      _isDark ? _DarkColors.tertiaryContainer : _LightColors.tertiaryContainer;

  Color get onTertiaryContainer =>
      _isDark
          ? _DarkColors.onTertiaryContainer
          : _LightColors.onTertiaryContainer;

  Color get error => _isDark ? _DarkColors.error : _LightColors.error;

  Color get onError => _isDark ? _DarkColors.onError : _LightColors.onError;

  Color get outline => _isDark ? _DarkColors.outline : _LightColors.outline;

  Color get surfaceTint =>
      _isDark ? _DarkColors.surfaceTint : _LightColors.surfaceTint;

  Color get shadow => _isDark ? _DarkColors.shadow : _LightColors.shadow;

  //region Common Colors
  Color get white => Color(0xffffffff);

  Color get black => Color(0xff000000);
  //endregion

Color get cardBg => _isDark ? _DarkColors.tertiaryContainer : _LightColors.background;


  Color get lightGrey => _isDark ? _DarkColors.lightGrey : _LightColors.lightGrey;
  Color get mediumGrey => _isDark ? _DarkColors.mediumGrey : _LightColors.mediumGrey;
  Color get darkGrey => _isDark ? _DarkColors.darkGrey : _LightColors.darkGrey;
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


  static const Color lightGrey = Color(0xFFE5E5EA);
  static const Color mediumGrey = Color(0xFFC7C7CC);
  static const Color darkGrey = Color(0xFF8E8E93);
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

  static const Color lightGrey = Color(0xFF48484A);
  static const Color mediumGrey = Color(0xFF636366);
  static const Color darkGrey = Color(0xFF8E8E93);
}
