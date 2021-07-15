import 'package:flutter/material.dart';

class ThemeModeHelper {
  ThemeModeHelper._();

  static final ValueNotifier<ThemeMode> notifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static void opposite() {
    notifier.value =
        notifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  static set themeMode(ThemeMode mode) {
    notifier.value = mode;
  }

  static ThemeMode get themeMode => notifier.value;
}
