import 'package:flutter/material.dart';
import 'package:simply_mentions/text/mention_text_editing_controller.dart';

class MentionService extends ChangeNotifier {
  String markUpText = '';
  List<MentionObject> mentionRepository = [];

  List<String> tagList = [];

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

  void updateTagList(List<String> newValue) {
    tagList = newValue;
  }

  List<dynamic> deltaParser() {
    String markUpTextCopy = markUpText;
    List<dynamic> ops = [];
    int currentIndex = 0;
    //debugPrint("from service31:$markUpTextCopy");
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
        String textBeforeMention = markUpTextCopy.substring(currentIndex, match.start);
        if (textBeforeMention.isNotEmpty) {
          ops.add({'insert': textBeforeMention});
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
        // Update the currentIndex for the next iteration
        currentIndex = match.end;

        // Add a new line character before processing the next line
        ops.add({'insert': " "});
      }
    }

    // Add the remaining text to ops if any
    if (currentIndex < markUpTextCopy.length) {
      ops.add({'insert': markUpTextCopy.substring(currentIndex)});
    }
    debugPrint(ops.toString());
    return ops;
  }
}
