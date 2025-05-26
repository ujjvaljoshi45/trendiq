import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/constants/user_singleton.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/user_model.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/views/auth_view/bloc/auth_event.dart';
import 'package:trendiq/views/auth_view/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoginEvent>(_handelLogin);
    on<AuthRegisterEvent>(_handelRegister);
    on<AuthUpdatePasswordEvent>(_handelUpdatePassword);
    on<AuthLogoutEvent>(_handelLogout);
    on<AuthSocialLoginEvent>(_handelSocialLogin);
    on<AuthLoadedEvent>((event, emit) {
      if (UserSingleton().user == null) {
        emit(AuthInitialState());
      } else {
        emit(AuthLoadedState());
      }
    },);
  }

  _handelLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoadingState());
      final response = await apiController.userLogin({
        Keys.email: event.email,
        Keys.password: event.password,
        Keys.source: Keys.app,
      });
      if (response.data != null) {
        UserSingleton().setUser(response.data!);
        emit(AuthLoadedState());
      } else {
        emit(AuthErrorState(response.message));
      }
  }

  _handelRegister(AuthRegisterEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoadingState());
      final response = await apiController.userRegister({
        Keys.email: event.email,
        Keys.password: event.password,
        Keys.username: event.username,
        Keys.source: Keys.app

      });
      if (response.data != null) {
        UserSingleton().setUser(response.data!);
        emit(AuthLoadedState());
      } else {
        emit(AuthErrorState(response.message));
      }
  }

  _handelUpdatePassword(
    AuthUpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
      emit(AuthUpdatePasswordLoading());
      final response = await apiController.updatePassword({
        Keys.password: event.password,
        Keys.newPassword: event.newPassword,
      });
      emit(AuthUpdatePasswordDone(response.message, isDone: !response.isError));
      emit(UserSingleton().user == null ? AuthInitialState() : AuthLoadedState());
  }

  _handelLogout(AuthLogoutEvent event , Emitter<AuthState> emit) {
    UserSingleton().clearUser();
    emit(AuthInitialState());
  }

  _handelSocialLogin(AuthSocialLoginEvent event, Emitter<AuthState> emit) async {
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
      UserSingleton().setUser(response.data!);
      emit(AuthLoadedState());
    }
  }

  Future<ApiResponse<UserModel?>> _handelGoogleLogin(bool isRegister) async {
    try {
      final gUser = (await GoogleSignIn(scopes: ['profile', 'email'],)
          .signIn());
      final res = await (gUser?.authentication);

      final user = (await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              accessToken: res?.accessToken, idToken: res?.idToken
          ))).user;
      if (user?.email == null) {
        return ApiResponse(
            isError: true, message: "Unable to Sign in With Google"
        );
      }
      if (isRegister) {
        return await apiController.userRegister({
          Keys.email: user!.email!,
          Keys.password: user.uid,
          Keys.username: user.displayName ?? "",
          Keys.source: Keys.google.toLowerCase()
        });
      } else {
        return await apiController.userLogin({
          Keys.email: user!.email!,
          Keys.password: user.uid,
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
