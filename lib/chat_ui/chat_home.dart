import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chats.dart';
import 'package:teamfinder_mobile/chat_ui/pages/contacts.dart';
import 'package:teamfinder_mobile/services/data_service.dart';


class ChatHome extends StatefulWidget {
  @override
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
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:userService.darkTheme!? const Color.fromRGBO(46, 46, 46, 100): Colors.white,
          iconTheme: IconThemeData(color: userService.darkTheme! ?Colors.white:Colors.grey),
          title:  Text('Teamfinder Chat', style: TextStyle(color: userService.darkTheme! ?Colors.white:Colors.deepPurpleAccent)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              color: userService.darkTheme! ?Colors.white:Colors.grey,
              onPressed: (){},
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
            Icons.message,
            color: Colors.white,
          ),
          onPressed: (){
            var router = MaterialPageRoute(
              builder: (BuildContext context) =>const Contacts());
              Navigator.of(context).push(router);
          },
        ),
      ),
    );

  }
}