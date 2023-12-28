import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//important: quill version 9.0.0 upwards throws path_provider error
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/mention_service.dart';
import '../pojos/user_pojo.dart';

class MentionWidget extends StatefulWidget {
  const MentionWidget({super.key});

  @override
  State<MentionWidget> createState() => _MentionWidgetState();
}

class _MentionWidgetState extends State<MentionWidget> {
  final FocusNode focusNode = FocusNode();
  final quill.QuillController controller = quill.QuillController.basic();
  bool showRecommend = false;
  int indexOfChar = 0;
  String userInput = '';
  late List<UserPojo>? userList = [];
  List<Map> mentionMapList = [];
  int cursorPosition = 1;
  @override
  void initState() {
    super.initState();
    quillListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void quillListener() {
    final mentionService = Provider.of<MentionService>(context, listen: false);
    controller.addListener(() {
      //final delta = controller.document.toDelta();
      //debugPrint('line 56:${delta.toString()}');
      //debugPrint('line 57:${controller.document.length}');

      mentionService.updateDescDelta(controller.document.toDelta());
      mentionService.updateDescription(controller.document.toPlainText().substring(0, controller.document.length - 1));
      debugPrint('current text:${controller.document.toPlainText().substring(0, controller.document.length - 1)}');

      setState(() {
        cursorPosition = userInput.length;
        userInput = controller.document
            .toPlainText()
            .substring(0, controller.document.length - 1);
      });
      detectMentionDelete();
      if (userInput.length > 2) {
        String lastTwoChar =
            userInput.substring(userInput.length - 2, userInput.length);
        debugPrint('last two:$lastTwoChar');
        //case when the there is a sapce followed by'@'
        if (lastTwoChar == ' @') {
          setState(() {
            indexOfChar = userInput.length - 2;
            showRecommend = true;
          });
        }
      } else if (userInput.length == 1) {
        //TODO:case when the first character is @
        if (userInput == '@') {
          debugPrint('first @ caught');
        }
      }
      if (indexOfChar + 1 == userInput.length) {
        //case when user backspaces the @
        setState(() {
          showRecommend = false;
        });
      }
      if (showRecommend) {
        String searchTerm = userInput.substring(indexOfChar + 2);
        debugPrint('searchTerm:$searchTerm');
        searchUser(searchTerm);
      }
    });
  }

  void addMention(String mentionText, String id) {
    final mentionService = Provider.of<MentionService>(context, listen: false);
    // Calculate the position to insert the mention text
    final insertionIndex = indexOfChar + 1;
    debugPrint("insertionIndex$insertionIndex");
    setState(() {
      mentionMapList.add({
        id: mentionText,
        'addedAt': insertionIndex,
        'endingAt': insertionIndex + 1 +mentionText.length
      });
      mentionService.updateMentionMapList(mentionMapList);
    });
    debugPrint('mention map:${mentionService.mentionMapList.toString()}');
    debugPrint('cursor pos 100:$cursorPosition');
    // Create a delta for the mention text with blue color
    final mentionDelta = Delta()
      ..retain(
          insertionIndex) // Retain the existing content up to insertionIndex
      ..insert(
        mentionText,
        {'color': 'blue'},
      )
      ..insert(" ", {'color': 'black'})
      ..delete(userInput.length - indexOfChar - 1);

    controller.compose(
      mentionDelta,
      controller.selection,
      quill.ChangeSource.local,
    );
  }

  void deleteMention(int ending,int start) {
    debugPrint("end:$ending,start:$start");
    final deleteDelta = Delta()..retain(start)..delete(ending-start-2);
    
    controller.compose(
      deleteDelta,
      controller.selection,
      quill.ChangeSource.local,
    );
  }

  void detectMentionDelete() {
    if (mentionMapList.isNotEmpty) {
      for (var element in mentionMapList) {
        int endingAt = element['endingAt']-1;
        if (endingAt == cursorPosition) {
          //debugPrint("detection result$cursorPosition");
          //debugPrint("detected mention${element.toString()}");
          deleteMention(element['endingAt'],element['addedAt']);
        }
      }
    }
  }

  void searchUser(String userInp) async {
    //debugPrint("called");
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    //ignore: prefer_is_empty
    if (userInp.length == 0) {
      setState(() {
        userList = [];
      });
      return;
    }
    //debugPrint('from search userinp: $userInp');
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.post(
      'http://${dotenv.env['server_url']}/searchFriend',
      data: {'searchTerm': userInp},
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint('user data searched');
      //debugPrint(response.data);
      setState(() {
        userList = userPojoListFromJson(response.data)
            .where((userPojo) => userPojo.id != user.uid)
            .toList();
      });
      //debugPrint(userList.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          focusNode.requestFocus();
        },
        child: quill.QuillProvider(
          configurations: quill.QuillConfigurations(
            controller: controller,
            sharedConfigurations: const quill.QuillSharedConfigurations(
              locale: Locale('de'),
            ),
          ),
          child: SizedBox(
            height: 150,
            child: quill.QuillEditor.basic(
              focusNode: focusNode,
              configurations: const quill.QuillEditorConfigurations(
                padding: EdgeInsets.all(5),
                placeholder: "Type away...",
                readOnly: false,
              ),
            ),
          ),
        ),
      ),
      Positioned(
          left: 150,
          child: Visibility(
              visible: showRecommend, child: buildMentionSuggestions()))
    ]);
  }

  Widget buildMentionSuggestions() {
    return Container(
        height: 150,
        width: 215,
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: ListView.builder(
            itemCount: userList?.length,
            itemBuilder: (context, int i) {
              return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue)),
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 15,
                    backgroundImage: NetworkImage(userList![i].profilePicture),
                  ),
                  title: Text(
                    userList![i].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    setState(() {
                      showRecommend = false;
                    });
                    addMention(userList![i].name.toString(),
                        userList![i].id.toString());
                  },
                ),
              );
            }));
  }
}
