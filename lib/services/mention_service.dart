import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MentionService extends ChangeNotifier {
  Delta? descriptionDelta;
  List<Map> mentionMapList = [];
  String description = '';

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

  List<dynamic> parseDelta() {
    List<Operation> opsList = descriptionDelta!.toList();
    List<dynamic> ops = [];
    int i = 0;
    for (var element in opsList) {
      if (element.attributes != null &&
          element.attributes!['color'] == 'blue') {
        var mapEle = mentionMapList[i];
        var id = mapEle.keys.toList()[0];
        ops.add({
          'insert': {
            'mention': {'id': id, 'value': element.data.toString()}
          }
        });

        i = i + 1;
      } else {
        ops.add({'insert': element.data.toString()});
      }
    }
    int lastElement = ops.length - 1;
    ops.removeAt(lastElement);
    return ops;
  }
}
