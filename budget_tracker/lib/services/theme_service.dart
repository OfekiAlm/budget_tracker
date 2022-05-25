import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {
  bool _darkTheme = true;
  final SharedPreferences sharedPreferences;
  ThemeService(this.sharedPreferences);
  static const darkThemeKey = "dark_theme";
  bool get darkTheme {
    return sharedPreferences.getBool(darkThemeKey) ?? _darkTheme;
  }

  set darkTheme(bool value) {
    _darkTheme = value;
    sharedPreferences.setBool(darkThemeKey, value);
    notifyListeners();
  }
}
