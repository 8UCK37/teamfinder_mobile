// ignore_for_file: avoid_unnecessary_containers
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chat_bubbles.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chat_images_bubbles.dart';
import '../../pojos/chat_model_pojo.dart';
import '../../services/socket_service.dart';
import 'package:intl/intl.dart';
import 'package:teamfinder_mobile/chat_ui/camera_ui/CameraScreen.dart';
import 'package:dio/dio.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String friendId;
  final String profileImage;
  final String path;
  ChatScreen(
      {required this.friendId,
      required this.name,
      required this.profileImage,
      required this.path});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<ChatModelPojo>? chatMsgs = [];
  final SocketService socketService = SocketService();
  bool isType = false;
  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;
  String? selectedImagePath;
  @override
  void initState() {
    super.initState();
    _fetchChatMsgs(widget.friendId);
    final user = FirebaseAuth.instance.currentUser;
    socketService.setupSocketConnection();
    socketService.setSocketId(user!.uid);
    incMsg();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
    incNoti();
    checkPath();
  }

  void checkPath() {
    if (widget.path != '') {
      debugPrint('chatScreen');
      debugPrint(widget.path);
      setState(() {
        //selectedImagePath = widget.path;
        //_selectedImage = File(selectedImagePath!);
      });
    } else {
      debugPrint('path is empty');
    }
  }

  void scrollToBottom() {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 4000,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn);
    //debugPrint(_scrollController.position.maxScrollExtent.toString());
  }

  void incMsg() {
    socketService.getIncomingMsg().listen((data) {
      // Process the received data here
      DateTime now = DateTime.now();
      debugPrint('Received data from socket: $data');
      // Update your screen state or perform any other actions
      var newChat = ChatModelPojo(
          msg: data['msg'],
          rec: true,
          photoUrl: null,
          sender: data['sender'],
          time: DateFormat('yyyy-MM-dd HH:mm:ss').format(now));
      chatMsgs!.add(newChat);
      setState(() {
        chatMsgs = chatMsgs;
        scrollToBottom();
      });
    });
  }

  void incNoti() {
    socketService.getIncomingNoti().listen((data) {
      //DateTime now = DateTime.now();
      debugPrint('Received noti from socket: $data');
      if (data['notification'] == 'imageUploadDone') {
        chatMsgs![chatMsgs!.length - 1].photoUrl = data['data'];
        setState(() {
          chatMsgs = chatMsgs;
          scrollToBottom();
        });
      }
    });
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
        //debugPrint(chatDump.toString());
        setState(() {
          chatMsgs = chatDump;
          scrollToBottom();
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
        selectedImagePath = pickedImage.path;
      }
    });
  }

  Future<void> sendMsg(String text) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();
    var data = {
      'receiver': widget.friendId,
      'msg': text,
      'sender': user!.uid,
      'photo': _selectedImage == null ? false : true
    };

    var newChat = ChatModelPojo(
        msg: text,
        rec: false,
        photoUrl: _selectedImage == null ? null : selectedImagePath,
        sender: user.uid,
        time: DateFormat('yyyy-MM-dd HH:mm:ss').format(now));
    chatMsgs!.add(newChat);
    debugPrint('split');
    debugPrint(selectedImagePath!.split('/')[2]);
    debugPrint(selectedImagePath!);
    setState(() {
      chatMsgs = chatMsgs;
      socketService.send(data);
      if (_selectedImage == null) {
        scrollToBottom();
      }
    });
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
    if (_selectedImage != null) {
      debugPrint('has path');
      final formData = FormData.fromMap({
        'data': jsonEncode({'data': data}),
        'chatimages': await MultipartFile.fromFile(selectedImagePath!),
      });
      try {
        final response = await dio.post(
            'http://${dotenv.env['server_url']}/chat/Images',
            data: formData,
            options: options);
        debugPrint(response.data);
        setState(() {
          _selectedImage = null;
          selectedImagePath = null;
          scrollToBottom();
        });
      } catch (e) {
        debugPrint('Error: $e');
      }
    } else {
      debugPrint('no path');
      debugPrint(jsonEncode({'data': data}));
      final formData = FormData.fromMap({
        'data': jsonEncode({'data': data}),
      });
      try {
        final response = await dio.post(
            'http://${dotenv.env['server_url']}/chat/Images',
            data: formData,
            options: options);
        debugPrint(response.data);
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
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
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                reverse: false,
                itemCount: chatMsgs!
                    .length, //TODO:implement msg time and different bubbles for imaged msg
                itemBuilder: (context, int i) {
                  if (chatMsgs![i].photoUrl != null) {
                    //debugPrint(chatMsgs![i].photoUrl);
                    return ChatImageBubble(
                      id: 'id001',
                      imageUrl: chatMsgs![i].photoUrl!,
                      isSender: !(chatMsgs![i].rec),
                      text: chatMsgs![i].msg,
                      time: chatMsgs![i].time,
                      color: !(chatMsgs![i].rec)
                          ? Colors.deepPurple.shade300
                          : Colors.orangeAccent,
                      tail: true,
                      delivered: true,
                    );
                  } else {
                    return ChatBubble(
                      text: chatMsgs![i].msg,
                      time: chatMsgs![i].time,
                      isSender: !(chatMsgs![i].rec),
                      color: !(chatMsgs![i].rec)
                          ? Colors.deepPurple.shade300
                          : Colors.orangeAccent,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      subtextStyle: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    );
                  }
                },
              ),
            ),
            Visibility(
              visible: _selectedImage != null,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                height: 200.0,
                decoration: BoxDecoration(
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            ),
            //if (_selectedImage != null) Image.file(_selectedImage!),
            const Divider(
              height: 1.0,
            ),
            Container(
              child: Column(
                children: [
                  MessageBar(
                    onSend: (String typedMsg) {
                      sendMsg(typedMsg);
                    },
                    actions: [
                      InkWell(
                        child: const Icon(
                          Icons.link,
                          color: Colors.orangeAccent,
                          size: 24,
                        ),
                        onTap: () {
                          pickImage();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 24,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                  friendId: widget.friendId,
                                  name: widget.name,
                                  profileImage: widget.profileImage,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
