import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syazanou/modules/app/cache.dart';

class ThemeModeHelper {
  ThemeModeHelper._();

  static const cacheKey = 'appThemeModeIsDark';

  static Box<bool> get cache => Cache.box<bool>();

  static final ValueNotifier<ThemeMode> notifier = ValueNotifier<ThemeMode>(
      cache.get(cacheKey, defaultValue: true) == false
          ? ThemeMode.light
          : ThemeMode.dark);

  static void opposite() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  static set themeMode(ThemeMode mode) {
    notifier.value = mode;
    cache.put(cacheKey, mode == ThemeMode.dark);
  }

  static ThemeMode get themeMode => notifier.value;
}
