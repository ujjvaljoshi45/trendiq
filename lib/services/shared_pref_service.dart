import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:trendiq/models/user_model.dart';

class Storage {
  static Storage? _instance;
  late final SharedPreferences _prefs;

  factory Storage() => _instance ??= Storage._();

  Storage._();

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  // Theme
  Future<void> saveIsDarkTheme(bool value) async {
    final prefs = _prefs;
    await prefs.setBool("isDark", value);
  }

  Future<bool> getIsDarkTheme() async {
    final prefs = _prefs;
    return prefs.getBool("isDark") ?? false;
  }

  Future<void> clear() async {
    final prefs = _prefs;
    await prefs.clear();
  }

  //region User
  Future<void> saveUser(UserModel user) async {
    final prefs = _prefs;
    final json = jsonEncode(user.toJson());
    await prefs.setString("user", json);
  }

  Future<UserModel?> getUser() async {
    final prefs = _prefs;
    final json = prefs.getString("user");
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }

  Future<void> clearUser() async {
    final prefs = _prefs;
    await prefs.remove("user");
  }

  //endregion
}
