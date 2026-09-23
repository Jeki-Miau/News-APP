import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controls font size and notification preferences, persisted via SharedPreferences.
class SettingsController extends GetxController {
  static const String _fontSizeKey = 'fontSize';
  static const String _notificationsKey = 'notificationsEnabled';

  final _fontSize = 16.0.obs;
  double get fontSize => _fontSize.value;

  final _notificationsEnabled = true.obs;
  bool get notificationsEnabled => _notificationsEnabled.value;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize.value = prefs.getDouble(_fontSizeKey) ?? 16.0;
    _notificationsEnabled.value = prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setFontSize(double size) async {
    _fontSize.value = size.clamp(12.0, 24.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, _fontSize.value);
  }

  Future<void> increaseFontSize() async {
    await setFontSize(_fontSize.value + 2.0);
  }

  Future<void> decreaseFontSize() async {
    await setFontSize(_fontSize.value - 2.0);
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled.value = !_notificationsEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, _notificationsEnabled.value);
  }
}
