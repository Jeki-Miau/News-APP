import 'package:get/get.dart';

/// Simple controller managing the bottom navigation bar tab index.
class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
