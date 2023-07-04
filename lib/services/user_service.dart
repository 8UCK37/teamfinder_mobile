import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  Map<String, dynamic> user = {}; // Initialize as an empty map

  void updateSharedVariable(Map<String, dynamic> newValue) {
    user = newValue;
    notifyListeners();
  }
}