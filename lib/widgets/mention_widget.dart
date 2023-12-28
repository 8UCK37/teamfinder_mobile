import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import '../pojos/user_pojo.dart';

class DetectionTextField extends StatefulWidget {
  final GlobalKey<FlutterMentionsState> mentionKey;
  const DetectionTextField({super.key, required this.mentionKey});

  @override
  State<DetectionTextField> createState() => _DetectionTextFieldState();
}

class _DetectionTextFieldState extends State<DetectionTextField> {
  late List<UserPojo>? userList = [];
  String? userInp;
  List<Map<String, dynamic>> result = [];

  void searchUser(String searchTerm) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    // ignore: prefer_is_empty
    if (searchTerm.length == 0) {
      setState(() {
        userList = [];
        result = [];
      });
      return;
    }
    debugPrint('from search userinp: $searchTerm');
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.post(
      'http://${dotenv.env['server_url']}/searchFriend',
      data: {'searchTerm': searchTerm},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint('user data searched');
      //debugPrint(response.data);
      setState(() {
        userList = userPojoListFromJson(response.data)
            .where((userPojo) => userPojo.id != user.uid)
            .toList();
        result = [];
        for (var element in userList!) {
          result.add(
              {'id': element.id, 'display': element.name, 'userdata': element});
        }
      });
      //debugPrint(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FlutterMentions(
          suggestionListHeight: 150,
          key: widget.mentionKey,
          suggestionPosition: SuggestionPosition.Bottom,
          maxLines: 3,
          minLines: 3,
          maxLength: 1000,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: InputBorder.none,
              hintText: 'Type Away...'),
          onChanged: (value) {
            //debugPrint("106:$value");
          },
          onSearchChanged: (marko, polo) {
            // debugPrint("109:$marko");
            // debugPrint("110:$polo");
            searchUser(polo);
          },
          onMentionAdd: (p0) {
            debugPrint("selected:$p0");
          },
          mentions: [
            Mention(
                trigger: '@',
                style: const TextStyle(
                  color: Colors.blue,
                ),
                data: result,
                matchAll: false,
                suggestionBuilder: (data) {
                  return suggestionWidget(data);
                }),
          ],
        ),
      ],
    );
  }

  Widget suggestionWidget(data) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(
              data['userdata'].profilePicture,
              //data['photo'],
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Column(
            children: <Widget>[
              Text(data['display']),
              // Text('@${data['display']}'),
            ],
          )
        ],
      ),
    );
  }
}
