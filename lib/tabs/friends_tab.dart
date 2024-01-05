import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pages/friend_list.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../friend_profile_ui/friend_profilehome.dart';
import '../services/notification_observer.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _suggestionWidgetKey = GlobalKey();
  final GlobalKey _outgoingReqWidgetkey = GlobalKey();
  late Map<String, dynamic> pendingInc = {};
  late Map<String, dynamic> pendingOut = {};
  @override
  void initState() {
    super.initState();
    getFriendData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToWidget(GlobalKey key) {
    // Determine the target widget's position
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final targetOffset = renderBox.localToGlobal(Offset.zero);

    // Scroll to the target widget
    _scrollController.animateTo(
      targetOffset.dy - 195, // Y-axis position
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeInOut, // Animation curve
    );
  }

  void getFriendData() async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.get(
      'http://${dotenv.env['server_url']}/getFriendData',
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint(response.data);
      if (mounted) {
        setState(() {
          for (dynamic user in json.decode(response.data)) {
            if (user['status'] == 'incoming') {
              //pendingInc.add(user);
              pendingInc[user['id']] = user;
            } else if (user['status'] == 'outgoing') {
              pendingOut[user['id']] = user;
            }
          }
        });
      }
      //debugPrint(pendingInc.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Friends',
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      debugPrint('scroll  to suggestions');
                      scrollToWidget(_suggestionWidgetKey);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Suggestions',
                          style: TextStyle(
                              color: userService.darkTheme!
                                  ? const Color.fromRGBO(46, 46, 46, 100)
                                  : Colors.grey[800],
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  //const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      debugPrint('go to contacts');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FriendList()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text('All Friends',
                          style: TextStyle(
                              color: userService.darkTheme!
                                  ? const Color.fromRGBO(46, 46, 46, 100)
                                  : Colors.grey[800],
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  //const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      scrollToWidget(_outgoingReqWidgetkey);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Pending',
                          style: TextStyle(
                              color: userService.darkTheme!
                                  ? const Color.fromRGBO(46, 46, 46, 100)
                                  : Colors.grey[800],
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              Divider(
                  height: 30.0,
                  color: userService.darkTheme!
                      ? const Color.fromARGB(255, 74, 74, 74)
                      : Colors.grey),
              Row(
                children: <Widget>[
                  const Text('Incoming Friend Requests',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10.0),
                  Text('${pendingInc.length}',
                      style: const TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
              const SizedBox(height: 20.0),
              for (String id in pendingInc.keys.toList())
                pendingFrndReq(pendingInc[id], true),
              Divider(
                  height: 30.0,
                  color: userService.darkTheme!
                      ? const Color.fromARGB(255, 74, 74, 74)
                      : Colors.grey),
              Container(
                key: _suggestionWidgetKey,
                child: const Text('People You May Know',
                    style:
                        TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/dp_placeholder.png'),
                    radius: 30.0,
                  ),
                  const SizedBox(width: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Mathew',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Text('Confirm',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0)),
                          ),
                          const SizedBox(width: 10.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Text('Delete',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0)),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                key: _outgoingReqWidgetkey,
                children: <Widget>[
                  const Text('Outgoing Friend Requests',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10.0),
                  Text('${pendingOut.length}',
                      style: const TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
              const SizedBox(height: 20.0),
              for (String id in pendingOut.keys.toList())
                pendingFrndReq(pendingOut[id], false),
              Divider(
                  height: 30.0,
                  color: userService.darkTheme!
                      ? const Color.fromARGB(255, 74, 74, 74)
                      : Colors.grey),
            ],
          )),
    );
  }

  Widget pendingFrndReq(dynamic user, bool isInc) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FriendProfileHome(
                    friendId: user["id"],
                    friendName: user["name"],
                    friendProfileImage: user["profilePicture"],
                  )),
        );
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(user['profilePicture']),
                radius: 30.0,
              ),
              const SizedBox(width: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(user!['name'],
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5.0),
                  if (isInc)
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            debugPrint("accept: ${user["name"]}");
                            userService.acceptReq(user["id"]);
                            setState(() {
                              pendingInc.remove(user["id"]);
                            });
                            Future.delayed(const Duration(seconds: 1), () {
                              notiObserver.getFriendList();
                            });
                            
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 153, 78),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Text('Accept',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15.0)),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () async {
                            debugPrint("reject: ${user["name"]}");
                            userService.rejectReq(user["id"]);
                            setState(() {
                              pendingInc.remove(user["id"]);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 61, 61),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Text('Reject',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0)),
                          ),
                        ),
                      ],
                    ),
                  if (!isInc)
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35.0, vertical: 10.0),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 16, 153, 78),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: const Text('Revoke',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 15.0)),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
