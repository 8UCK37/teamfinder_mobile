import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamfinder_mobile/utils/login_controller.dart';

import 'activity/home_screen.dart';
import 'activity/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initSharedPreferences();
  runApp(MyApp());
}

Future<void> _initSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  Get.put(prefs);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _checkLoginState();
    });

    return MaterialApp(
      title: 'TeamFinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Obx(() {
        if (LoginController.to.googleAccount.value == null) {
          return const LoginActivity();
        } else {
          return const HomeScreenWidget();
        }
      }),
    );
  }

  void _checkLoginState() {
  final prefs = Get.find<SharedPreferences>();
  final email = prefs.getString('googleAccountEmail');
  if (email != null && Get.context!=null ) {
    LoginController.to.login(Get.context!);
  }
}

}
