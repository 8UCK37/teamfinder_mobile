import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/chat%20pages/chat_screen.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../services/notification_observer.dart';
import '../utils/router_animation.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context,listen:true);
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
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
                  'You have ${notiObserver.friendList!.length} Friends',
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
          itemCount: notiObserver.friendList?.length,
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
                    backgroundImage: NetworkImage(notiObserver.friendList![i].profilePicture),
                  ),
                  if (notiObserver.onlineMap![notiObserver.friendList![i].id]!)
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
                      notiObserver.friendList![i].name,
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
                                            friendId: notiObserver.friendList![i].id,
                                            name: notiObserver.friendList![i].name,
                                            profileImage:
                                                notiObserver.friendList![i].profilePicture,
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
                  AnimatedRouter.slideToPageBottom(context,  FriendProfileHome(
                            friendId: notiObserver.friendList![i].id,
                            friendName: notiObserver.friendList![i].name,
                            friendProfileImage: notiObserver.friendList![i].profilePicture,
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
