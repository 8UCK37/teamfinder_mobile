import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/services/socket_service.dart';
import '../services/user_service.dart';
import '../tabs/friends_tab.dart';
import '../tabs/home_tab.dart';
import '../tabs/menu_tab.dart';
import '../tabs/notifications_tab.dart';
import '../tabs/profile_tab.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SocketService socketService = SocketService();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _saveUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _saveUser() async {
    final url = Uri.parse('http://${dotenv.env['server_url']}/saveuser');
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
        //print(userData);
        userService.updateSharedVariable(userData);
        socketService.setupSocketConnection();
        socketService.setSocketId(userData['id']);
      } else {
        // Request failed
        debugPrint('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      debugPrint('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    // ignore: unused_local_variable
    final userData = userService.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Row(
                children: <Widget>[
                  Text('TeamFinder',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                GestureDetector(
                  onTap: () {
                    debugPrint('search clicked');

                    
                  },
                  child: const Icon(Icons.search, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint('goto chat');

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatHome()),
                    );
                  },
                  child: Icon(Icons.chat, color: Colors.deepPurple),
                ),
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
            Tab(icon: Icon(Icons.badge, size: 30.0)),
            Tab(icon: Icon(Icons.diversity_3, size: 30.0)),
            Tab(icon: Icon(Icons.notifications, size: 30.0)),
            Tab(icon: Icon(Icons.menu, size: 30.0, key: Key('menuTab')))
          ],
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: TabBarView(controller: _tabController, children: [
        HomeTab(),
        ProfileTab(),
        FriendsTab(),
        NotificationsTab(),
        MenuTab(_tabController),
      ]),
    );
  }
}
