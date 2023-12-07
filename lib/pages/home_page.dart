import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/pages/search_page.dart';
import 'package:teamfinder_mobile/services/socket_service.dart';
import '../services/data_service.dart';
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
  late SharedPreferences _preferences;
  late bool _isDark;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _tabController = TabController(vsync: this, length: 5);
    _saveUser();
    fetchFeed();
    getOwnPost();
    getTwitchInfo();
    getDiscordInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    bool savedThemeValue = _preferences.getBool('isDarkTheme') ?? false;
    setState(() {
      final userService = Provider.of<ProviderService>(context, listen: false);
      userService.updateTheme(savedThemeValue);
    });
  }

  void fetchFeed() {
    //debugPrint('fetchFeedCalled');
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.fetchPosts();
  }

  Future<void> getOwnPost() async {
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.getOwnPost();
  }

  Future<void> getTwitchInfo() async {
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.getTwitchInfo();
  }

  Future<void> getDiscordInfo() async {
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.getDiscordInfo();
  }

  void _saveUser() async {
    debugPrint('saveuserCalled');
    final url = Uri.parse('http://${dotenv.env['server_url']}/saveuser');
    final user = FirebaseAuth.instance.currentUser;
    final userService = Provider.of<ProviderService>(context, listen: false);
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
        userService.updateCurrentUser(userData);
        // ignore: use_build_context_synchronously
        socketService.setupSocketConnection(context);
        socketService.setSocketId(userData['id']);
        userService.setSocket(socketService);
        if (userData["steamId"] != null) {
          userService.getSteamInfo(userData["steamId"]);
        }
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
    final userService = Provider.of<ProviderService>(context, listen: true);
    // ignore: unused_local_variable
    final userData = userService.user;
    _isDark = userService.darkTheme!;
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  _isDark ? Brightness.light : Brightness.dark),
          backgroundColor:
              _isDark ? const Color.fromRGBO(46, 46, 46, 1) : Colors.white,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Text('TeamFinder',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          debugPrint('search clicked');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
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
                              backgroundColor:
                                  Color.fromRGBO(222, 209, 242, 100),
                              child: Icon(Icons.search, color: Colors.blueGrey),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          debugPrint('goto chat');

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatHome()),
                          );
                        },
                        child: const Material(
                          elevation: 5,
                          shadowColor: Colors.grey,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromRGBO(222, 209, 242, 100),
                            child: Icon(Icons.question_answer,
                                color: Colors.deepPurple),
                          ),
                        ),
                      ),
                    ]),
              ]),
          elevation: 0.0,
          bottom: TabBar(
            key: const Key('tabBar'),
            indicatorColor: Colors.deepPurple,
            controller: _tabController,
            unselectedLabelColor: Colors.grey,
            //labelColor: Colors.deepPurple,
            tabs: const [
              Tab(
                  icon: Icon(
                Icons.receipt_long,
                size: 28.0,
                color: Colors.blue,
              )),
              Tab(
                  icon: Icon(
                Icons.co_present,
                size: 28.0,
                color: Colors.green,
              )),
              Tab(
                  icon: Icon(Icons.diversity_3,
                      size: 32.0, color: Colors.purple)),
              Tab(
                  icon: Icon(
                FontAwesomeIcons.bell,
                size: 25.0,
                color: Colors.red,
              )),
              Tab(
                  icon: Icon(Icons.menu,
                      size: 30.0, color: Colors.orange, key: Key('menuTab')))
            ],
          ),
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: TabBarView(controller: _tabController, children: [
          const HomeTab(),
          const ProfileTab(),
          const FriendsTab(),
          const NotificationsTab(),
          MenuTab(_tabController),
        ]),
      ),
    );
  }
}
