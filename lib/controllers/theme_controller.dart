import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controls the app's theme mode (light/dark) and persists the preference.
class ThemeController extends GetxController {
  static const String _themeKey = 'isDarkMode';

  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = prefs.getBool(_themeKey) ?? false;
    Get.changeThemeMode(themeMode);
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode.value);
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }
}
