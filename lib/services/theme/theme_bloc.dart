import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/theme/theme_event.dart';
import 'package:trendiq/services/theme/theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeStateLight()) {
    on<SetDarkTheme>((event, emit) {
      appColors.isDark = true;
      emit(const ThemeStateDark());
    });
    on<SetLightTheme>((event, emit) {
      appColors.isDark = false;
      emit(const ThemeStateLight());
    });
  }

  @override
  fromJson(Map<String, dynamic> json) {
    final mode = json['themeData'] as String?;
    switch (mode) {
      case 'light':
        appColors.isDark = false;
        return const ThemeStateLight();
      case 'dark':
        appColors.isDark = true;
        return const ThemeStateDark();
      case 'system':
      default:
      appColors.isDark = false;
        return const ThemeStateLight();
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
