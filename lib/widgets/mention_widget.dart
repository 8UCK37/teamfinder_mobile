import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
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
  final List<ListTile> mockRecommend = [
    const ListTile(
      leading: Icon(Icons.person),
      trailing: Text("tom"),
    ),
    const ListTile(
      leading: Icon(Icons.person),
      trailing: Text("dick"),
    ),
    const ListTile(
      leading: Icon(Icons.person),
      trailing: Text("harry"),
    ),
    const ListTile(
      leading: Icon(Icons.person),
      trailing: Text("rob"),
    ),
  ];

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
    controller.addListener(() {
      final delta = controller.document.toDelta();
      debugPrint('line 56:${delta.toString()}');
      debugPrint('line 57:${controller.document.length}');
      debugPrint(
          'line 58:${controller.document.toPlainText().substring(0, controller.document.length - 1)}');

      setState(() {
        userInput = controller.document
            .toPlainText()
            .substring(0, controller.document.length - 1);
      });
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
        //case when the first character is @
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

  void onTap(String mentionText) {
    // Calculate the position to insert the mention text
    final insertionIndex = indexOfChar + 1;

    // Create a delta for the mention text with blue color
    final mentionDelta = Delta()
      ..retain(
          insertionIndex) // Retain the existing content up to insertionIndex
      ..insert(
        mentionText,
        {'color': 'blue'},
      )
      ..insert(" ", {'color':'black'})
      ..delete(userInput.length - indexOfChar - 1);
    // Add a space after the mention to continue typing

    // Retain the existing content up to insertionIndex

    // Apply the delta to the controller
    controller.compose(
      mentionDelta,
      controller.selection,
      quill.ChangeSource.local,
    );
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
                    // debugPrint(userInput.substring(0, indexOfChar + 1));
                    // debugPrint(userList![i].id.toString());
                    // debugPrint(userInput.substring(0, indexOfChar + 1) +
                    //     userList![i].name.toString());
                    onTap(userList![i].name.toString());
                  },
                ),
              );
            }));
  }
}
