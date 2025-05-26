import 'package:trendiq/models/user_model.dart';
import 'package:trendiq/services/shared_pref_service.dart';

class UserSingleton {
  static final _instance = UserSingleton._();
  UserSingleton._();
  factory UserSingleton() => _instance;
  UserModel? _user;

  UserModel? get user => _user;
  void setUser(UserModel user) {
    _user = user;
    saveUser();
  }
  void saveUser() async => _user != null ? await Storage().saveUser(_user!) : null;
  void getUser() async {
    _user = await Storage().getUser();
  }
  void clearUser() async {
    await Storage().clearUser();
    _user = null;
  }
}