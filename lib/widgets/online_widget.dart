import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';
import 'package:teamfinder_mobile/pages/friend_list.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:teamfinder_mobile/services/socket_service.dart';

import '../controller/network_controller.dart';
import '../services/data_service.dart';

class OnlineWidget extends StatefulWidget {
  const OnlineWidget({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _OnlineWidgetState createState() => _OnlineWidgetState();
}

class _OnlineWidgetState extends State<OnlineWidget>
    with SingleTickerProviderStateMixin {
  late List<UserPojo>? friendList = [];
  late Map<String, bool>? onlineMap;
  StreamSubscription<dynamic>? _socketSubscription;
  @override
  void initState() {
    super.initState();
    _getFriendList();
    incNoti();
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    _socketSubscription?.cancel();
    super.dispose();
  }

  void incNoti() {
    final userService = Provider.of<ProviderService>(context, listen: false);
    SocketService socketService = userService.socketService;
    _socketSubscription = socketService.getIncomingNoti().listen((data) {
      //DateTime now = DateTime.now();
      //debugPrint('Received noti from socket: $data');
      if (data['notification'] == 'disc') {
        //debugPrint('${data['sender']} disconnected');
        if (mounted) {
          setState(() {
            onlineMap![data['sender']] = false;
          });
        }
      } else if (data['notification'] == 'online') {
        //debugPrint('${data['sender']} is now online');
        if (mounted) {
          setState(() {
            onlineMap![data['sender']] = true;
          });
        }
      }
    });
  }

  void _getFriendList() async {
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("no_internet");
      return;
    } else {
      debugPrint("_getFriendList() called");
    }
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    //print('friend list called');
    final response = await dio.get(
      'http://${dotenv.env['server_url']}/friendData',
      options: options,
    );

    if (response.statusCode == 200) {
      // Request successful
      var res = response.data;
      //debugPrint(res);
      // Parse the JSON response into a list of PostPojo objects
      List<UserPojo> parsedFriendList = userPojoListFromJson(res);
      if (mounted) {
        setState(() {
          parsedFriendList.sort((a, b) {
            if (a.isConnected && !b.isConnected) {
              return -1; // a comes before b
            } else if (!a.isConnected && b.isConnected) {
              return 1; // b comes before a
            } else {
              return 0; // order remains the same
            }
          });
          onlineMap = {
            for (var obj in parsedFriendList) obj.id: obj.isConnected
          };

          friendList =
              parsedFriendList; // Update the state variable with the parsed list
        });
      }
    }
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: 15.0),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(width: 1.0, color: Colors.blue)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendList()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.diversity_2, size: 20, color: Colors.purple),
                  SizedBox(width: 5.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('All', style: TextStyle(color: Colors.blue)),
                      Text('Friends', style: TextStyle(color: Colors.blue)),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (friendList != null) // Add a null check here
            for (UserPojo user in friendList!) // Add a null check here
              GestureDetector(
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (BuildContext context) => FriendProfileHome(
                              friendId: user.id,
                              friendName: user.name,
                              friendProfileImage: user.profilePicture,
                            ));
                    Navigator.of(context).push(route);
                  },
                  child: friendBubble(user))
        ],
      ),
    );
  }

  Widget friendBubble(UserPojo user) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 22.0,
            backgroundImage: NetworkImage(user.profilePicture),
          ),
          if (onlineMap![user.id]!)
            const Positioned(
              right: 1.0,
              bottom: 5.0,
              child: CircleAvatar(
                radius: 7.0,
                backgroundColor: Color.fromARGB(255, 12, 173, 17),
              ),
            ),
        ],
      ),
    );
  }
}
