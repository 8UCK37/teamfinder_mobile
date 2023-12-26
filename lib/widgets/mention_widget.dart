import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../pojos/user_pojo.dart';

class MentionWidget extends StatefulWidget {
  const MentionWidget({super.key});

  @override
  State<MentionWidget> createState() => _MentionWidgetState();
}

class _MentionWidgetState extends State<MentionWidget> {
  final FocusNode focusNode = FocusNode();
  final QuillController controller = QuillController.basic();
  bool showRecommend = false;
  int indexOfChar = 0;
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
      debugPrint('line 47:${delta.toString()}');
      debugPrint('line 48:${controller.document.length}');
      debugPrint(
          'line 48:${controller.document.toPlainText().substring(0, controller.document.length - 1)}');

      String userInput = controller.document
          .toPlainText()
          .substring(0, controller.document.length - 1);
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

  void searchUser(String userInp) async {
    debugPrint("called");
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
    debugPrint('from search userinp: $userInp');
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
      debugPrint('user data searched');
      //debugPrint(response.data);
      setState(() {
        userList = userPojoListFromJson(response.data)
            .where((userPojo) => userPojo.id != user.uid)
            .toList();
      });
      debugPrint(userList.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          focusNode.requestFocus();
        },
        child: Container(
          height: 150,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          child: QuillEditor.basic(
            focusNode: focusNode,
            configurations: QuillEditorConfigurations(
              controller: controller,
              readOnly: false,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('de'),
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
    // Implement your mention suggestion UI here
    // This could be a ListView.builder showing user suggestions as they type
    return Container(
        height: 150,
        width: 210,
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: ListView.builder(
            itemCount: userList?.length,
            itemBuilder: (context, int i) {
              return ListTile(
                leading: CircleAvatar(
                  maxRadius: 10,
                  backgroundImage: NetworkImage(userList![i].profilePicture),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      userList![i].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onTap: () {},
              );
            }));
  }
}
