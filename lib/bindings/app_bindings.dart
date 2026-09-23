import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/controllers/theme_controller.dart';
import 'package:news_app/services/connectivity_service.dart';

/// Global bindings registered once at app startup.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Theme controller — must be initialized early for theme mode binding
    Get.put(ThemeController());

    // Bookmark controller — global so bookmarks persist across tabs
    Get.put(BookmarkController());

    // Settings controller — font size and notification prefs
    Get.put(SettingsController());

    // Connectivity monitoring service
    Get.put(ConnectivityService());
  }
}
