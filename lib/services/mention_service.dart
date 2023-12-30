import 'package:flutter/material.dart';
import 'package:simply_mentions/text/mention_text_editing_controller.dart';

class MentionService extends ChangeNotifier {
  String markUpText = '';
  List<MentionObject> mentionRepository = [];
  void updateMarkUpText(String newValue) {
    markUpText = newValue;
    notifyListeners();
  }

  void appendToMentionRepo(MentionObject newMention) {
    if (mentionRepository.contains(newMention)) {
      return;
    }
    mentionRepository.add(newMention);
    notifyListeners();
  }

  List<dynamic> deltaParser() {
    String markUpTextCopy = markUpText;
    List<dynamic> ops = [];
    int currentIndex = 0;

    RegExp regex = RegExp(r'<###@([A-Za-z0-9]+)###>');

    Iterable<RegExpMatch> matches = regex.allMatches(markUpTextCopy);

    for (RegExpMatch match in matches) {
      String id = match.group(1)!;

      // Find the corresponding MentionObject
      MentionObject? mentionObject = mentionRepository.firstWhere(
          (mention) => mention.id == id,
          orElse: () => MentionObject(id: '', displayName: '', avatarUrl: ''));

      if (mentionObject.id.isNotEmpty) {
        // Add the text before the mention
        String textBeforeMention =
            markUpTextCopy.substring(currentIndex, match.start).trim();
        if (textBeforeMention.isNotEmpty) {
          ops.add({'insert': "$textBeforeMention "});
        }

        // Create the mention map and add it to the ops list
        Map<String, dynamic> mentionMap = {
          'insert': {
            'mention': {
              'denotationChar': '@',
              'id': id,
              'value': mentionObject.displayName,
            }
          }
        };

        ops.add(mentionMap);
        ops.add({'insert': " "});
        // Update the currentIndex for the next iteration
        currentIndex = match.end;
      }
    }

    // Add the remaining text to ops if any
    if (currentIndex < markUpTextCopy.length) {
      ops.add({'insert': markUpTextCopy.substring(currentIndex)});
    }

    //debugPrint("${ops.length}");
    // Print the result
    for (var ele in ops) {
      debugPrint(ele.toString());
    }
    ops.add({'insert': "\n"});
    return ops;
  }

  List<dynamic> reference() {
    // List<Operation> opsList = descriptionDelta!.toList();
    // List<dynamic> ops = [];
    // int i = 0;
    // for (var element in opsList) {
    //   if (element.attributes != null &&
    //       element.attributes!['color'] == 'blue') {
    //     var mapEle = mentionMapList[i];
    //     var id = mapEle.keys.toList()[0];
    //     ops.add({
    //       'insert': {
    //         'mention': {'id': id, 'value': element.data.toString()}
    //       }
    //     });

    //     i = i + 1;
    //   } else {
    //     ops.add({'insert': element.data.toString()});
    //   }
    // }
    // int lastElement = ops.length - 1;
    // ops.removeAt(lastElement);
    // return ops;
    return [];
  }
}
