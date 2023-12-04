// ignore_for_file: sized_box_for_whitespace, must_be_immutable
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chat_screen.dart';
import '../../services/socket_service.dart';

class CameraViewPage extends StatefulWidget {
  final String path;
  final String name;
  final String friendId;
  final String profileImage;
  String caption = '';
  CameraViewPage(
      {Key? key,
      required this.path,
      required this.friendId,
      required this.name,
      required this.profileImage})
      : super(key: key);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraViewPage>
    with TickerProviderStateMixin {
  final SocketService socketService = SocketService();
  @override
  void initState() {
    super.initState();
    //final user = FirebaseAuth.instance.currentUser;
    socketService.setupSocketConnection(context);
    //socketService.setSocketId(user!.uid);
  }

  Future<void> sendMsg(String text) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    //DateTime now = DateTime.now();
    debugPrint(widget.path);
    debugPrint(widget.caption);

    var data = {
      'receiver': widget.friendId,
      'msg': text,
      'sender': user!.uid,
      'photo': true
    };
    socketService.send(data);
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    final idToken = await user.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'multipart/form-data',
      },
    );
    final formData = FormData.fromMap({
      'data': jsonEncode({'data': data}),
      'chatimages': await MultipartFile.fromFile(widget.path),
    });
    try {
      final response = await dio.post(
          'http://${dotenv.env['server_url']}/chat/Images',
          data: formData,
          options: options);
      debugPrint(response.data);
      if (response.statusCode == 200) {
        debugPrint('sending succ');

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            // ignore: prefer_const_constructors
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      friendId: widget.friendId,
                      name: widget.name,
                      profileImage: widget.profileImage,
                      newChat: {'msg':widget.caption,'photoUrl':widget.path},
                    )));
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.crop_rotate,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.title,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.edit,
                size: 27,
              ),
              onPressed: () {}),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  onChanged: (value) {
                    widget.caption = value;
                    debugPrint(widget.caption);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Caption....",
                      prefixIcon: const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          debugPrint(widget.path.toString());
                          debugPrint(widget.caption);
                          sendMsg(widget.caption);
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.tealAccent[700],
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
