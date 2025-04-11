import 'package:get_storage/get_storage.dart';

class Storage {
  static Storage? _instance;
  // SharedPreferences? prefs;
  GetStorage box = GetStorage();
  factory Storage() => _instance ??= Storage._();
  Storage._();
  Future<void> saveFcmData(value) async => await (box).write("fcmData", value);
  Future<String?> getFcmData() async => (box).read("fcmData");
  Future<void> saveIsDarkTheme(value) async =>
      await (box).write("isDark", value);
  Future<bool> getIsDarkTheme() async => await (box).read("isDark");
  Future<void> clear() async => await (box).erase();
}
