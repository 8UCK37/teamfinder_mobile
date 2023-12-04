import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chat_screen.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart' hide Theme;
import 'package:http/http.dart' as http;
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/socket_service.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList>
    with SingleTickerProviderStateMixin {
  late List<UserPojo>? friendList = [];
  late Map<String, bool>? onlineMap;
  final SocketService socketService = SocketService();
  StreamSubscription<dynamic>? _socketSubscription;
  @override
  void initState() {
    super.initState();
    socketService.setupSocketConnection(context);
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
    final url = Uri.parse('http://${dotenv.env['server_url']}/friendData');
    final user = FirebaseAuth.instance.currentUser;
    //print('friend list called');
    if (user != null) {
      final idToken = await user.getIdToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        // Request successful
        var res = response.body;
        //print(res);
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
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context,listen:true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: userService.darkTheme!? Brightness.light:Brightness.dark
            
          ),
          backgroundColor:userService.darkTheme!? const Color.fromRGBO(46, 46, 46, 1): Colors.white,
          iconTheme: IconThemeData(
            color: userService.darkTheme! ?Colors.white:Colors.deepPurple),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              color: userService.darkTheme! ?Colors.grey:Colors.deepPurple,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              color: userService.darkTheme! ?Colors.grey:Colors.deepPurple,
              onPressed: () {},
            ),
          ],
          // ignore: avoid_unnecessary_containers
          title: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Text("FriendList",
                    style: TextStyle(
                      color: userService.darkTheme! ?Colors.grey:Colors.deepPurple
                      )),
                // ignore: avoid_unnecessary_containers
                Container(
                    // padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                  'You have ${friendList!.length} Friends',
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurpleAccent),
                ))
              ],
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: friendList?.length,
          itemBuilder: (context, i) => Column(
            children: <Widget>[
              if(i==0)
                const Divider(
                  height: 22.0,
                ),
              const SizedBox(height:20),
              ListTile(
                leading: Stack(
                  children:[
                    CircleAvatar(
                    maxRadius: 25,
                    backgroundImage: NetworkImage(friendList![i].profilePicture),
                  ),
                  if (onlineMap![friendList![i].id]!)
                   const Positioned(
                    right: 1.0,
                    bottom: 0,
                     child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      elevation: 10,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor:Color.fromARGB(255, 12, 173, 17),
                      ),
                                     ),
                   )
                  ]
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      friendList![i].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right:45.0),
                            child: GestureDetector(
                                onTap: () {
                                  var route = MaterialPageRoute(
                                      builder: (BuildContext context) => ChatScreen(
                                            friendId: friendList![i].id,
                                            name: friendList![i].name,
                                            profileImage:
                                                friendList![i].profilePicture,
                                          ));
                                  Navigator.of(context).push(route);
                                },
                                child: const Icon(
                                  Icons.chat,
                                  color: Color.fromARGB(255, 22, 125, 99),
                                  )
                                ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom:8.0),
                            child: GestureDetector(
                              onTap: () {
                                
                              },
                              child: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  //debugPrint('list tile clicked');
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) => FriendProfileHome(
                            friendId: friendList![i].id,
                            friendName: friendList![i].name,
                            friendProfileImage: friendList![i].profilePicture,
                          ));
                  Navigator.of(context).push(route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
