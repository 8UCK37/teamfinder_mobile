import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint("internet gone");
      Get.rawSnackbar(
          messageText: const Text('PLEASE CONNECT TO THE INTERNET',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red[400]!,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      debugPrint("internet on");

      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      } 
      // else {
      //   debugPrint("ohh a livesaver");
      // }
    }
  }

  Future<bool> noInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    //debugPrint('40: ${connectivityResult.toString()}');
    if (connectivityResult == ConnectivityResult.none) {
      return true;
    } else {
      return false;
    }
  }
}
