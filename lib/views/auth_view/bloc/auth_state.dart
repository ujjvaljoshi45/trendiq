abstract class AuthState {}

class AuthInitialState extends AuthState {}
class AuthLoadingState extends AuthState {}
class AuthLoginState extends AuthState {}
class AuthRegisterState extends AuthState {}
class AuthLoadedState extends AuthState {}
class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}
class AuthUpdatePasswordLoading extends AuthState {}
class AuthUpdatePasswordDone extends AuthState {
  final String? errorMsg;
  final bool isDone;
  AuthUpdatePasswordDone(this.errorMsg, {this.isDone = false});
}