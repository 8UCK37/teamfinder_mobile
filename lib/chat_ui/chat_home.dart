import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/chat_ui/pages/calls.dart';
import 'package:teamfinder_mobile/chat_ui/pages/camera.dart';
import 'package:teamfinder_mobile/chat_ui/pages/status.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chats.dart';
import 'package:teamfinder_mobile/chat_ui/pages/contacts.dart';


class ChatHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ChatHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(initialIndex: 1, vsync: this, length: 2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teamfinder Chat', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onPressed: (){},
          ),
        ],
        backgroundColor: Colors.deepPurpleAccent.shade400,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.camera_alt, color: Colors.white,)),
            Tab(child: Text("CHATS", style: TextStyle(color: Colors.white))),
            // Tab(child: Text("STATUS", style: TextStyle(color: Colors.white))),
            // Tab(child: Text("CALLS", style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Camera(),
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
            builder: (BuildContext context) => Contacts());
            Navigator.of(context).push(router);
        },
      ),
    );

  }
}