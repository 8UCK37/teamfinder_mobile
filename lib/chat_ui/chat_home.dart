import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/chat%20pages/chats.dart';
import 'package:teamfinder_mobile/pages/home_page.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

import '../pages/friend_list.dart';
import '../pages/search_page.dart';
import '../utils/router_animation.dart';


class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ChatHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(initialIndex: 0, vsync: this, length: 1);

  }
  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context,listen:true);
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          AnimatedRouter.slideToPageRightReplace(context, const HomePage());
        },
      child: Theme(
        data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:userService.darkTheme!? const Color.fromRGBO(46, 46, 46, 100): Colors.white,
            iconTheme: IconThemeData(color: userService.darkTheme! ?Colors.white:Colors.grey),
            title:  const Text('Chat', style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold)),
            actions: <Widget>[
              GestureDetector(
                  onTap: () {
                    debugPrint('search clicked');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchPage()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 5,
                      shadowColor: Colors.grey,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromRGBO(222, 209, 242, 100),
                        child: Icon(Icons.search, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                color: userService.darkTheme! ?Colors.white:Colors.grey,
                onPressed: (){},
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              // CameraPage(),
              Chats(),
              // Status(),
              // Calls()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor:const Color.fromARGB(255, 22, 125, 99), //Theme.of(context).accentColor
            child: const Icon(
              Icons.recent_actors,
              color: Colors.white,
            ),
            onPressed: (){
              AnimatedRouter.slideToPageLeft(context, const FriendList());
            },
          ),
        ),
      ),
    );

  }
}