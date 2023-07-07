// ignore_for_file: avoid_unnecessary_containers
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:teamfinder_mobile/models/chat_model.dart';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/chat_bubbles.dart';
import '../../pojos/chat_model_pojo.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String friendId;
  final String profileImage;
  ChatScreen(
      {required this.friendId, required this.name, required this.profileImage});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  List<ChatModelPojo>? chatMsgs = [];

  bool isType = false;
  @override
  void initState() {
    super.initState();
    _fetchChatMsgs(widget.friendId);
  }

  Future<void> _fetchChatMsgs(dynamic friendId) async {
    final url = Uri.parse('http://${dotenv.env['server_url']}/chatData')
        .replace(queryParameters: {'friendId': friendId.toString()});
    final user = FirebaseAuth.instance.currentUser;
    List<ChatModelPojo>? chatDump = [];
    if (user != null) {
      final idToken = await user.getIdToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        // Request successful
        // var res = response.body;
        // List<UserPojo> parsedactiveConvoList = userPojoFromJson(res);
        debugPrint('succ');

        var res = jsonDecode(response.body);
        //debugPrint(res.toString());
        res.forEach((data) {
          ChatModelPojo chat = ChatModelPojo(
              msg: data['msg'],
              rec: !(data['sender'] == user.uid),
              photoUrl: data['photoUrl'],
              sender: data['sender'],
              time: data['createdAt'].toString());
          chatDump.add(chat);
        });
        debugPrint(chatDump.toString());
        setState(() {
          chatMsgs = chatDump;
        });
      } else {
        // Request failed
        debugPrint('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      debugPrint('User is not logged in');
    }
  }

  void _handleSubmit(String text) {
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
          duration: const Duration(seconds: 1), vsync: this),
      name: widget.name,
    );
    setState(() {
      _messages.insert(0, message);
      var data = messageData.firstWhere((t) => t.name == widget.name);
      data.message = message.text;
    });
    message.animationController.forward();
  }

  Widget _buildText() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: Flexible(
                child: TextField(
              controller: _textController,
              decoration:
                  const InputDecoration.collapsed(hintText: "Send message"),
            )),
          ),
          Container(
            child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 22, 125, 99),
                ),
                onPressed: () {
                  _handleSubmit(_textController.text);
                  _textController.clear();
                }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
        title: Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // padding: const EdgeInsets.fromLTRB(0, 0, 3.0, 0),
              child: Center(
                  child: CircleAvatar(
                backgroundImage: NetworkImage(widget.profileImage),
                maxRadius: 22,
              )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(widget.name,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0)),
                  ),
                  const Text(
                    "last seen. 18:00",
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        )),
        backgroundColor: Colors.tealAccent.shade700,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: false,
                itemCount: chatMsgs!.length, //TODO:implement msg time and different bubbles for imaged msg
                itemBuilder: (context, int i) => BubbleSpecialOne( 
                  text: chatMsgs![i].msg,
                  isSender: !(chatMsgs![i].rec),
                  color: !(chatMsgs![i].rec)? Colors.deepPurple.shade300 :Colors.orangeAccent,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1.0,
            ),
            Container(
              child: MessageBar(
                onSend: (_) => print(_),
                actions: [
                  InkWell(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 24,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String name;
  final AnimationController animationController;
  final String text;
  ChatMessage(
      {required this.name,
      required this.animationController,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://avatars2.githubusercontent.com/u/23518097?s=400&u=91ac76bebfb16bdfffa49216ac336a0d615a1444&v=4"),
                maxRadius: 25.0,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("El chuy",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold)),
                  Container(
                      margin: const EdgeInsets.only(top: 6.0),
                      child: Text(text,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18.0)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
