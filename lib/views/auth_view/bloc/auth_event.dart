abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent(this.email, this.password);
}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String fcmToken;

  AuthRegisterEvent(this.email, this.password, this.username, this.fcmToken);
}

class AuthUpdatePasswordEvent extends AuthEvent {
  final String password;
  final String newPassword;

  AuthUpdatePasswordEvent(this.password, this.newPassword);
}

class AuthSocialLoginEvent extends AuthEvent {
  final String authProviderId;
  final bool isRegister;
  AuthSocialLoginEvent(this.authProviderId,this.isRegister);
}

class AuthLogoutEvent extends AuthEvent {}
class AuthLoadedEvent extends AuthEvent {}

