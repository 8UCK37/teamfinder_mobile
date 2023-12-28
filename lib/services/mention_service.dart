import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MentionService extends ChangeNotifier {
  Delta? descriptionDelta;
  List<Map> mentionMapList = [];
  String description='';

  void updateDescDelta(dynamic newValue) {
    descriptionDelta = newValue;
    notifyListeners();
  }

  void updateMentionMapList(dynamic newValue) {
    mentionMapList = newValue;
    notifyListeners();
  }
  void updateDescription(dynamic newValue) {
    description = newValue;
    notifyListeners();
  }
}
