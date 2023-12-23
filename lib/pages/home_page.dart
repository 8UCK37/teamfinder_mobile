import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamfinder_mobile/controller/network_controller.dart';
import 'package:teamfinder_mobile/services/socket_service.dart';
import 'package:teamfinder_mobile/widgets/custom_appbar.dart';
import '../services/data_service.dart';
import '../services/notification_observer.dart';
import '../tabs/friends_tab.dart';
import '../tabs/home_tab.dart';
import '../tabs/menu_tab.dart';
import '../tabs/notifications_tab.dart';
import '../tabs/profile_tab.dart';
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
  late SharedPreferences _preferences;
  late bool _isDark;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _tabController = TabController(vsync: this, length: 5);
    loadNotifocationList();
    saveUserInit();
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

  Future<void> loadNotifocationList() async {
    final notiObserver =
        Provider.of<NotificationWizard>(context, listen: false);
    notiObserver.readNotificationBox();
  }

  void saveUserInit() async {
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("saveUserInit() no_internet");
      return;
    } else {
      debugPrint("saveUser called");
    }
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    // ignore: use_build_context_synchronously
    final userService = Provider.of<ProviderService>(context, listen: false);
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    // ignore: unnecessary_null_comparison
    if (user != null) {
      //debugPrint(user.uid.toString());
      var response = await dio.post(
        'http://${dotenv.env['server_url']}/saveuser',
        options: options,
      );
      //debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        // Request successful
        var userData = json.decode(response.data);
        //debugPrint(userData.toString());
        userService.updateCurrentUser(userData);
        userService.refreashCache();
        // ignore: use_build_context_synchronously
        if (mounted) {
          final SocketService socketService = SocketService();
          socketService.setupSocketConnection(context);
          socketService.setSocketId(userData['id']);
          userService.setSocket(socketService);
        }
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
        appBar: TeamFinderAppBar(
          titleText: "TeamFinder",
          isDark: _isDark,
          tabController: _tabController, 
          implyLeading: false,
          showNotificationCount: true,
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
