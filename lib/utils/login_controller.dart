import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/home_screen.dart';

class LoginController extends GetxController {
  final _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  static LoginController get to => Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    // Retrieve the login state from SharedPreferences on initialization
    _loadLoginState();
  }

  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('googleAccountEmail');
    if (email != null) {
      googleAccount.value = await _googleSignIn.signInSilently();
    }
  }

  Future<void> login(BuildContext context) async {
    googleAccount.value = await _googleSignIn.signIn();
    // Save the login state to SharedPreferences
    _saveLoginState();
    // Navigate to HomeScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreenWidget()),
    );
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    // Clear the login state from SharedPreferences
    _clearLoginState();
    googleAccount.value = null;
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final email = googleAccount.value?.email;
    if (email != null) {
      prefs.setString('googleAccountEmail', email);
    }
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('googleAccountEmail');
  }
}
