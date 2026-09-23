import 'package:get/get.dart';
import 'package:news_app/controllers/navigation_controller.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/controllers/news_search_controller.dart';

/// Bindings for the main wrapper screen (all tabs).
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<NewsController>(() => NewsController());
    Get.lazyPut<NewsSearchController>(() => NewsSearchController());
  }
}