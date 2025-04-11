import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trendiq/services/theme/theme_event.dart';
import 'package:trendiq/services/theme/theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeStateSystem()) {
    on<SetSystemTheme>((event, emit) => emit(const ThemeStateSystem()));
    on<SetDarkTheme>((event, emit) => emit(const ThemeStateDark()));
    on<SetLightTheme>((event, emit) => emit(const ThemeStateLight()));
  }

  @override
  fromJson(Map<String, dynamic> json) {
    final mode = json['themeData'] as String?;
    switch (mode) {
      case 'light':
        return const ThemeStateLight();
      case 'dark':
        return const ThemeStateDark();
      case 'system':
      default:
        return const ThemeStateSystem();
    }
  }

  @override
  Map<String, dynamic>? toJson(state) {
    if (state is ThemeStateLight) {
      return {'themeMode': 'light'};
    } else if (state is ThemeStateDark) {
      return {'themeMode': 'dark'};
    } else {
      return {'themeMode': 'system'};
    }
  }
}
