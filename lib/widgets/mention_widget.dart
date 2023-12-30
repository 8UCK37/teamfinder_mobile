import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_portal/flutter_portal.dart';
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
  bool firstCharacterTrigger = false;
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
    controller.removeListener(() {});
    super.dispose();
  }

  void quillListener() {
    final mentionService = Provider.of<MentionService>(context, listen: false);
    controller.addListener(() {
      //final delta = controller.document.toDelta();
      //debugPrint('line 56:${delta.toString()}');
      //debugPrint('line 57:${controller.document.length}');

      /// updating the varaibles in mentionService
      mentionService.updateDescDelta(controller.document.toDelta());
      mentionService.updateDescription(controller.document
          .toPlainText()
          .substring(0, controller.document.length - 1));
      //debugPrint('current text:${controller.document.toPlainText().substring(0, controller.document.length - 1)}');

      /// cursorposition is needed to detect if a user is backspacing a mention or not
      /// cursorposition calculated in this way is crude and at times not accurate at all but
      /// in this case it's accurate as hell ;-)
      /// userInput is the state variable that always has the current text stored in it
      setState(() {
        cursorPosition = controller.selection.baseOffset;
        debugPrint("corsor at:$cursorPosition");
        userInput = controller.document
            .toPlainText()
            .substring(0, controller.document.length - 1);
      });

      /// after we update the state of currrent cursor position and userInput
      /// we can check if the operation that triggered this listen instance was a backspace or not
      /// and if that backspace was trying to erase the last character of a mention input or not
      /// if it was then the mention list is updated accordingly and the text is removed from the delta
      detectMentionDelete();

      ///this is required because i dont want to detect any '@' cos say some one was trying to type a email address
      ///it would be annoying as fuck
      ///to counter that this only detects ' @' as the trigger for commencing search
      if (userInput.length > 2) {
        String lastTwoChar =
            userInput.substring(userInput.length - 2, userInput.length);
        //debugPrint('last two:$lastTwoChar');
        //case when the there is a space followed by'@'
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
          setState(() {
            firstCharacterTrigger = true;
          });
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
      if (firstCharacterTrigger) {
        if (userInput.length > 1) {
          debugPrint("searchterm:${userInput.substring(1)}");
          searchUser(userInput.substring(1));
        } else if (userInput.isEmpty) {
          setState(() {
            firstCharacterTrigger = false;
          });
        } else {
          debugPrint("searchterm 111:${userInput.length}");
          setState(() {
            userList = [];
          });
        }
      }
    });
  }

  void addMention(String mentionText, String id) {
    final mentionService = Provider.of<MentionService>(context, listen: false);
    // Calculate the position to insert the mention text
    final insertionIndex = indexOfChar + 1;
    debugPrint("insertionIndex$insertionIndex");
    setState(() {
      userList = [];
      mentionMapList.add({
        id: mentionText,
        'addedAt': insertionIndex,
        'endingAt': insertionIndex + 1 + mentionText.length
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

  void detectMentionDelete() {
    if (mentionMapList.isNotEmpty) {
      for (var element in mentionMapList) {
        int endingAt = element['endingAt'] - 1;
        if (endingAt == cursorPosition) {
          //debugPrint("detection result$cursorPosition");
          //debugPrint("detected mention${element.toString()}");
          deleteMention(element);
        }
      }
    }
  }

  void deleteMention(var element) {
    int ending = element['endingAt'];
    int start = element['addedAt'];
    debugPrint("end:$ending,start:$start");
    final deleteDelta = Delta()
      ..retain(start)
      ..delete(ending - start - 1);

    controller.compose(
      deleteDelta,
      controller.selection,
      quill.ChangeSource.local,
    );
    assignNewStartEnd(element);
  }

  void assignNewStartEnd(var element) {
    final mentionService = Provider.of<MentionService>(context, listen: false);
    int elementEffectiveLength = element['endingAt'] - element['addedAt'];
    int mentionListSize = mentionMapList.length - 1;
    int indexOfRemoval = mentionMapList.indexOf(element);

    if (mentionListSize > indexOfRemoval) {
      for (int i = indexOfRemoval; i <= mentionListSize; i++) {
        setState(() {
          mentionMapList[i]['addedAt'] =
              mentionMapList[i]['addedAt'] - elementEffectiveLength;
          mentionMapList[i]['endingAt'] =
              mentionMapList[i]['endingAt'] - elementEffectiveLength;
        });
      }
    }
    mentionMapList.removeAt(indexOfRemoval);
    mentionService.updateMentionMapList(mentionMapList);
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
    return PortalTarget(
      visible: userList!.isNotEmpty,
      anchor: const Aligned(
        follower: Alignment.topCenter,
        target: Alignment.bottomCenter,
      ),
      portalFollower: buildMentionSuggestions(),
      child: quill.QuillProvider(
        configurations: quill.QuillConfigurations(
          controller: controller,
          sharedConfigurations: const quill.QuillSharedConfigurations(
            locale: Locale('de'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Colors.green)),
            height: 108,
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
    );
  }

  Widget buildMentionSuggestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(75, 0, 75, 0),
      child: Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(color: Colors.transparent)),
          child: ListView.builder(
              itemCount: userList?.length,
              itemBuilder: (context, int i) {
                return Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Color.fromARGB(255, 200, 66, 72)),
                  )),
                  child: ListTile(
                    leading: CircleAvatar(
                      maxRadius: 25,
                      backgroundImage:
                          NetworkImage(userList![i].profilePicture),
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
              })),
    );
  }
}
