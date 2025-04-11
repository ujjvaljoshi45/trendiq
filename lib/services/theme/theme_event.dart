abstract class ThemeEvent {
  const ThemeEvent();
}

class SetLightTheme extends ThemeEvent {
  const SetLightTheme();
}

class SetDarkTheme extends ThemeEvent {
  const SetDarkTheme();
}

class SetSystemTheme extends ThemeEvent {
  const SetSystemTheme();
}
