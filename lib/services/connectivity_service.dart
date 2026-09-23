import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Monitors internet connectivity and shows snackbar banners on status changes.
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    if (isConnected.value && !connected) {
      // Lost connection
      Get.rawSnackbar(
        message: 'No internet connection',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    } else if (!isConnected.value && connected) {
      // Regained connection
      Get.rawSnackbar(
        message: 'Back online',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.wifi, color: Colors.white),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    }

    isConnected.value = connected;
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
