import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  late final SharedPreferences _prefs;

  factory StorageService() => _instance ??= StorageService._();

  StorageService._();

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

  Future<void> saveToken(String value) async => _prefs.setString("token", value);
  String getToken() => _prefs.getString("token") ?? "";

  String? getEmail() => _prefs.getString("email");
  Future<void> saveEmail(String value) async => _prefs.setString("email", value);
  
  Future<void> saveVersion(String value) => _prefs.setString("app_version", value);
  String? getVersion() => _prefs.getString("app_version");

}
