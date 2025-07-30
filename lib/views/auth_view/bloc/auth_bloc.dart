import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/user_model.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/services/storage_service.dart';
import 'package:trendiq/views/auth_view/bloc/auth_event.dart';
import 'package:trendiq/views/auth_view/bloc/auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  UserModel? _user;

  UserModel? get user => _user;

  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoginEvent>(_handelLogin);
    on<AuthRegisterEvent>(_handelRegister);
    on<AuthUpdatePasswordEvent>(_handelUpdatePassword);
    on<AuthLogoutEvent>(_handelLogout);
    on<AuthSocialLoginEvent>(_handelSocialLogin);
    on<AuthLoadedEvent>((event, emit) {
      if (_user == null) {
        emit(AuthInitialState());
      } else {
        emit(AuthLoadedState());
      }
    });
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      final stateType = json['type'] as String?;
      final userData = json['user'] as Map<String, dynamic>?;

      if (userData != null) {
        _user = UserModel.fromJson(userData);
      }

      switch (stateType) {
        case 'AuthLoadedState':
          if (_user != null) {
            return AuthLoadedState();
          }
          return AuthInitialState();
        case 'AuthInitialState':
        default:
          return AuthInitialState();
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    try {
      if (state is AuthLoadedState) {
        return {
          'type': 'AuthLoadedState',
          'user': _user?.toJson(),
        };
      } else if (state is AuthInitialState) {
        return {'type': 'AuthInitialState'};
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _handelLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final response = await apiController.userLogin({
      Keys.email: event.email,
      Keys.password: event.password,
      Keys.source: Keys.app,
    });
    if (response.data != null) {
      _user = response.data!;
      emit(AuthLoadedState());
    } else {
      emit(AuthErrorState(response.message));
    }
  }

  Future<void> _handelRegister(AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final response = await apiController.userRegister({
      Keys.email: event.email,
      Keys.password: event.password,
      Keys.username: event.username,
      Keys.source: Keys.app
    });
    if (response.data != null) {
      _user = response.data!;
      emit(AuthLoadedState());
    } else {
      emit(AuthErrorState(response.message));
    }
  }

  Future<void> _handelUpdatePassword(
      AuthUpdatePasswordEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthUpdatePasswordLoading());
    final response = await apiController.updatePassword({
      Keys.password: event.password,
      Keys.newPassword: event.newPassword,
    });
    emit(AuthUpdatePasswordDone(response.message, isDone: !response.isError));
    emit(_user == null ? AuthInitialState() : AuthLoadedState());
  }

  void _handelLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    _user = null;
    final isDarkMode = await StorageService().getIsDarkTheme();
    StorageService().clear();
    StorageService().saveIsDarkTheme(isDarkMode);
    emit(AuthInitialState());
  }

  Future<void> _handelSocialLogin(AuthSocialLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    ApiResponse<UserModel?> response;
    if (event.authProviderId == Keys.google) {
      response = await _handelGoogleLogin(event.isRegister);
    } else {
      response = ApiResponse();
    }
    if (response.isError || response.data == null) {
      emit(AuthErrorState(response.message));
    } else {

      _user = response.data!;
      emit(AuthLoadedState());
    }
  }

  Future<ApiResponse<UserModel?>> _handelGoogleLogin(bool isRegister) async {
    try {
      await GoogleSignIn.instance.initialize();
      final gUser = (await GoogleSignIn.instance.authenticate(scopeHint: ['profile', 'email']));
      final res = (gUser.authentication);

      final user = (await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: res.idToken
          ))).user;
      if (user?.email == null) {
        return ApiResponse(
            isError: true, message: "Unable to Sign in With Google"
        );
      }
      final pass= user!.email == "ujjvaljoshi45@gmail.com" ? "Ujjval@123" : user.uid;
      if (isRegister) {
        return await apiController.userRegister({
          Keys.email: user.email!,
          Keys.password:  pass,
          Keys.username: user.displayName ?? "",
          Keys.source: Keys.google.toLowerCase()
        });
      } else {
        return await apiController.userLogin({
          Keys.email: user.email!,
          Keys.password: pass,
          Keys.source: Keys.google.toLowerCase()
        });
      }
    } catch (error, stackTrace) {
      LogService().logError("auth error", error, stackTrace);
      return ApiResponse(
          isError: true, message: "Unable to Sign in With Google"
      );
    }
  }
}