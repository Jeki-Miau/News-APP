import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/controllers/theme_controller.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';
import 'package:news_app/utils/constants.dart';

/// Settings screen with dark mode toggle, font size, notifications, and about.
/// Enhanced with staggered entrance animations.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    final settingsCtrl = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideX(begin: -0.05, end: 0),
        centerTitle: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          const SizedBox(height: 8),

          // ── Appearance Section ──
          _buildSectionTitle(context, 'Appearance')
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.05, end: 0, curve: Curves.easeOutCubic),

          // Dark mode toggle
          Obx(() => SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: AppTextStyles.bodyLarge(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: Text(
                  themeCtrl.isDarkMode
                      ? 'Dark theme enabled'
                      : 'Light theme enabled',
                  style: AppTextStyles.bodySmall(),
                ),
                secondary: Icon(
                  themeCtrl.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.accent,
                ),
                value: themeCtrl.isDarkMode,
                onChanged: (_) => themeCtrl.toggleTheme(),
                activeTrackColor: AppColors.accent,
              ))
              .animate(delay: 100.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

          const Divider(indent: 16, endIndent: 16)
              .animate(delay: 150.ms)
              .fadeIn(duration: 300.ms)
              .scaleX(begin: 0, end: 1, alignment: Alignment.centerLeft),

          // Font size
          Obx(() => ListTile(
                leading:
                    const Icon(Icons.text_fields, color: AppColors.accent),
                title: Text(
                  'Font Size',
                  style: AppTextStyles.bodyLarge(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: Text(
                  'Article text size: ${settingsCtrl.fontSize.toInt()}px',
                  style: AppTextStyles.bodySmall(),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: settingsCtrl.decreaseFontSize,
                      color: AppColors.accent,
                    ),
                    Text(
                      '${settingsCtrl.fontSize.toInt()}',
                      style: AppTextStyles.label(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: settingsCtrl.increaseFontSize,
                      color: AppColors.accent,
                    ),
                  ],
                ),
              ))
              .animate(delay: 200.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 16),

          // ── Notifications Section ──
          _buildSectionTitle(context, 'Notifications')
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.05, end: 0, curve: Curves.easeOutCubic),

          Obx(() => SwitchListTile(
                title: Text(
                  'Push Notifications',
                  style: AppTextStyles.bodyLarge(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: Text(
                  'Receive breaking news alerts',
                  style: AppTextStyles.bodySmall(),
                ),
                secondary: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.accent,
                ),
                value: settingsCtrl.notificationsEnabled,
                onChanged: (_) => settingsCtrl.toggleNotifications(),
                activeTrackColor: AppColors.accent,
              ))
              .animate(delay: 400.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 16),

          // ── About Section ──
          _buildSectionTitle(context, 'About')
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.05, end: 0, curve: Curves.easeOutCubic),

          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.accent),
            title: Text(
              Constants.appName,
              style: AppTextStyles.bodyLarge(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            subtitle: Text(
              'Version ${Constants.appVersion}',
              style: AppTextStyles.bodySmall(),
            ),
          )
              .animate(delay: 600.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

          ListTile(
            leading: const Icon(Icons.code, color: AppColors.accent),
            title: Text(
              'Built with Flutter',
              style: AppTextStyles.bodyLarge(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            subtitle: Text(
              'Powered by NewsAPI',
              style: AppTextStyles.bodySmall(),
            ),
          )
              .animate(delay: 700.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.caption(color: AppColors.accent).copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
