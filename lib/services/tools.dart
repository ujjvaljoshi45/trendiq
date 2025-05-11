import 'package:flutter/material.dart';

class Tools {
  Tools._();
  static final Tools _instance = Tools._();
  factory Tools() => _instance;
  double getWith(context) => MediaQuery.of(context).size.width;
  double getHeight(context) => MediaQuery.of(context).size.height;
  static InputDecoration baseInputDecoration(ThemeData theme) =>
      InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelStyle: TextStyle(color: theme.colorScheme.primary),
        prefixIcon: Icon(Icons.lock, color: theme.colorScheme.primary),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      );
}
