import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/navigation_controller.dart';
import 'package:news_app/views/home_view.dart';
import 'package:news_app/views/search_view.dart';
import 'package:news_app/views/bookmarks_view.dart';
import 'package:news_app/views/settings_view.dart';

/// Main wrapper with Material 3 bottom NavigationBar and IndexedStack
/// to maintain state across tabs.
class MainWrapper extends GetView<NavigationController> {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            HomeView(),
            const SearchView(),
            const BookmarksView(),
            const SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
