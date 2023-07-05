import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../tabs/friends_tab.dart';
import '../tabs/home_tab.dart';
import '../tabs/menu_tab.dart';
import '../tabs/notifications_tab.dart';
import '../tabs/profile_tab.dart';
import '../tabs/watch_tab.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 6);
    _saveUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _saveUser() async {
    final url = Uri.parse('http://192.168.101.6:3000/saveuser');
    final user = FirebaseAuth.instance.currentUser;
    final userService = Provider.of<UserService>(context, listen: false);
    if (user != null) {
      final idToken = await user.getIdToken();

      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        // Request successful
        var userData = json.decode(response.body);
        print(userData);
        userService.updateSharedVariable(userData);
      } else {
        // Request failed
        print('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final userData = userService.user;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('TeamFinder',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Icon(Icons.search, color: Colors.black),
                SizedBox(width: 15.0),
                Icon(Icons.chat, color: Colors.deepPurple)
              ]),
            ]),
        backgroundColor: Colors.white,
        elevation: 0.0,
        bottom: TabBar(
          key: Key('tabBar'),
          indicatorColor: Colors.deepPurple,
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.deepPurple,
          tabs: const [
            Tab(icon: Icon(Icons.home, size: 30.0)),
            Tab(icon: Icon(Icons.people, size: 30.0)),
            Tab(icon: Icon(Icons.ondemand_video, size: 30.0)),
            Tab(icon: Icon(Icons.account_circle, size: 30.0)),
            Tab(icon: Icon(Icons.notifications, size: 30.0)),
            Tab(icon: Icon(Icons.menu, size: 30.0,key: Key('menuTab')))
          ],
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeTab(),
          FriendsTab(),
          WatchTab(),
          ProfileTab(),
          NotificationsTab(),
          MenuTab(_tabController),
        ]
      ),
    );
  }
}