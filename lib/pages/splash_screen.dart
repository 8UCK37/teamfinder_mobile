import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamfinder_mobile/pages/home_page.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import 'package:teamfinder_mobile/services/socket_service.dart';
import '../controller/network_controller.dart';

class SplashFuturePage extends StatefulWidget {
  const SplashFuturePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashFuturePageState createState() => _SplashFuturePageState();
}

class _SplashFuturePageState extends State<SplashFuturePage> {
  late SharedPreferences _preferences;
  bool hasInternet = false;
  String loadingText = "";
  @override
  void initState() {
    super.initState();
    _initializePreferences();
    loadNotifocationList();
    saveUserInit();
    fetchFeed();
    getOwnPost();
    getTwitchInfo();
    getDiscordInfo();
  }

  Future<Widget> futureCall() async {
    //currently this is not used beacuse my code it toofast and the splash screen doesn't even show lol
    // do async operation ( api call, auto login)
    return Future.value(const HomePage());
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
      hasInternet = false;
      loadingText = "No Internet!!";
      return;
    } else {
      hasInternet = true;
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
    return EasySplashScreen(
      logo: Image.asset('assets/images/megaphone.png'),
      title: const Text(
        "",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 218, 74, 69),
      showLoader: false,
      loadingText: Text(loadingText),
      durationInSeconds: 1,
      navigator: hasInternet ? const HomePage() : null,
    );
  }
}
