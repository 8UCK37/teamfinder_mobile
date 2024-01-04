import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/utils/language_chip_helper.dart';
import '../controller/network_controller.dart';
import 'socket_service.dart';

class ProviderService extends ChangeNotifier {
  NetworkController networkController = NetworkController();
  Map<String, dynamic> user = {}; // Initialize as an empty map
  List<PostPojo>? feed;
  List<PostPojo>? ownPosts;

  dynamic steamData;
  dynamic twitchData;
  dynamic discordData;
  bool? darkTheme = false;
  int? replyingToId;
  String? replyingToName;
  Map<Language, bool> selectedLang = {};
  SocketService socketService = SocketService();

  String profileImagecacheKey = "dp1";
  String bannerImagecacheKey = "ban1";

  final bookmarkBox = Hive.box('bookmarkBox1');
  List<dynamic>? bookMarkIds;
  List<PostPojo> bookMarkedPosts = [];

  void updateCurrentUser(Map<String, dynamic> newValue) {
    user = newValue;
    notifyListeners();
  }

  void updateTheme(bool newValue) {
    darkTheme = newValue;
    notifyListeners();
  }

  void updateReplyingTo(int? newValue, String? newName) {
    replyingToId = newValue;
    replyingToName = newName;
    notifyListeners();
  }

  void updateFeed(List<PostPojo> newValue) {
    feed = newValue;
    notifyListeners();
  }

  void updateSelectedLangMap(Map<Language, bool> newValue) {
    selectedLang = newValue;
    notifyListeners();
  }

  void setSocket(SocketService newValue) {
    socketService = newValue;
    notifyListeners();
  }

  void refreashCache() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    profileImagecacheKey = "dp2$timestamp";
    bannerImagecacheKey = "ban2$timestamp";
    notifyListeners();
  }

  void reloadUser(BuildContext context) async {
    debugPrint("user reload hit");
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("reloadUser() no_internet");
      return;
    } else {
      debugPrint("saveUser called");
    }
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    // ignore: use_build_context_synchronously
    //final userService = Provider.of<ProviderService>(context, listen: false);
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
        refreashCache();
        // Request successful
        var userData = json.decode(response.data);
        //debugPrint(userData.toString());
        updateCurrentUser(userData);
        // ignore: use_build_context_synchronously
        socketService.setSocketId(userData['id']);
        setSocket(socketService);

        if (userData["steamId"] != null) {
          getSteamInfo(userData["steamId"]);
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

  void addToBookmarkBox(int postId) {
    //debugPrint("userId; ${user['id']},add postId :$postId");
    List<dynamic>? newList = bookmarkBox.get(user['id']);
    if (newList != null) {
      newList.add(postId);
    } else {
      newList = [];
      newList.add(postId);
    }
    bookmarkBox.put(user['id'], newList);
    getBookMarkList(user['id']);
    //debugPrint(newList.toString());
  }

  void removeFromBookmarkBox(int postId) {
    //debugPrint("userId; ${user['id']},add postId :$postId");
    List<dynamic>? newList = bookmarkBox.get(user['id']);
    
    newList!.removeWhere((element) => element == postId);
    bookmarkBox.put(user['id'], newList);

    bookMarkedPosts.removeWhere((element) => element.id == postId);
    notifyListeners();
    //debugPrint(newList.toString());
  }

  void fetchPosts() async {
    if (await networkController.noInternet()) {
      debugPrint("fetchPosts() no_internet");
      return;
    } else {
      debugPrint("fetchPosts() called");
    }
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    //debugPrint('fetch post called');
    final response = await dio.get(
      'http://${dotenv.env['server_url']}/getFeed',
      options: options,
    );

    if (response.statusCode == 200) {
      // Request successful
      var res = response.data;
      //print(res);
      // Parse the JSON response into a list of PostPojo objects
      List<PostPojo> parsedPosts = postPojoFromJson(res, false);
      feed = parsedPosts; // Update the state variable with the parsed list
      notifyListeners();
    }
  }

  void updateOwnPosts(List<PostPojo> newValue) {
    ownPosts = newValue;
    notifyListeners();
  }

  Future<void> getOwnPost() async {
    if (await networkController.noInternet()) {
      debugPrint("getOwnPost() no_internet");
      return;
    } else {
      debugPrint("getOwnPost() called");
    }
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    //debugPrint(user.uid.toString());
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getPostById',
      data: {'uid': user.uid.toString()},
      options: options,
    );
    if (response.statusCode == 200) {
      List<PostPojo> parsedPosts = postPojoFromJson(response.data, true);
      if (parsedPosts.isNotEmpty) {
        ownPosts = parsedPosts;
        notifyListeners();
      }
    }
  }

  void updateSteamInfo(dynamic newValue) {
    steamData = newValue;
    notifyListeners();
  }

  Future<void> getSteamInfo(String id) async {
    if (await networkController.noInternet()) {
      debugPrint("getSteamInfo() no_internet");
      return;
    } else {
      debugPrint("getSteamInfo() called");
    }
    Dio dio = Dio();

    final userFromFirebase = FirebaseAuth.instance.currentUser;
    final idToken = await userFromFirebase!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/steamInfo',
      data: {'steam_id': id},
      options: options,
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.data) != null) {
        steamData = jsonDecode(response.data)["info"][0];
        //debugPrint(steamData.toString());
        notifyListeners();
      }
    }
  }

  void updateTwitchData(dynamic newValue) {
    twitchData = newValue;
    notifyListeners();
  }

  Future<void> getTwitchInfo() async {
    if (await networkController.noInternet()) {
      debugPrint("getTwitchInfo() no_internet");
      return;
    } else {
      debugPrint("getTwitchInfo() called");
    }
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.get(
      'http://${dotenv.env['server_url']}/getowntwitchinfo',
      queryParameters: {'id': user.uid.toString()},
      options: options,
    );
    if (response.statusCode == 200) {
      if (response.data != "not logged in") {
        twitchData = response.data;
        //debugPrint(twitchData.toString());
        notifyListeners();
      }
    }
  }

  void updateDiscordData(dynamic newValue) {
    discordData = newValue;
    notifyListeners();
  }

  Future<void> getDiscordInfo() async {
    if (await networkController.noInternet()) {
      debugPrint("getDiscordInfo() no_internet");
      return;
    } else {
      debugPrint("getDiscordInfo() called");
    }
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.get(
      'http://${dotenv.env['server_url']}/getDiscordInfo',
      queryParameters: {'id': user.uid.toString()},
      options: options,
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.data) != null) {
        discordData = jsonDecode(response.data)['Discord'];
        //debugPrint(discordData.toString());
        notifyListeners();
      }
    }
  }

  getUserSelectedLang() {
    var selectedLangList = [];
    var userInfo = user['userInfo'];
    var newMap = Language.map();
    //debugPrint(userInfo['Language'].toString());
    if (userInfo['Language'] != null) {
      selectedLangList = userInfo['Language'].split(",");
    }
    //debugPrint(Language.map().toString());
    for (Language lang in Language.map().keys) {
      for (String index in selectedLangList) {
        if (int.parse(index) == lang.id) {
          //debugPrint(lang.label);
          newMap[lang] = true;
        }
      }
    }
    //debugPrint(newMap.toString());
    selectedLang = newMap;
  }

  Future<void> updateSelectedLanguage() async {
    if (await networkController.noInternet()) {
      debugPrint("updateSelectedLanguage() no_internet");
      return;
    } else {
      debugPrint("updateSelectedLanguage() called");
    }
    debugPrint('selected lang db post');
    Dio dio = Dio();
    final userFrmFirebase = FirebaseAuth.instance.currentUser;
    final idToken = await userFrmFirebase!.getIdToken();

    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/updateUserSelectedLanguages',
      data: {'data': user['userInfo'], 'list': convertSelectedLangToString()},
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint(response.data.toString());
      user['userInfo']['Language'] = convertSelectedLangToString();
      notifyListeners();
    }
  }

  void acceptReq(String frndId) async {
    debugPrint("accepting frnd req for $frndId");
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("accepting frnd req no_internet");
      return;
    } else {
      debugPrint("in terms of internet we have internet");
    }

    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/acceptFriend',
      data: {'frnd_id': frndId},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("accepted frnd req for $frndId");
    }
  }

  void rejectReq(String frndId) async {
    debugPrint("rejecting frnd req for $frndId");
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("rejecting frnd req no_internet");
      return;
    } else {
      debugPrint("in terms of internet we have internet");
    }

    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/rejectFriend',
      data: {'frnd_id': frndId},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("rejected frnd req for $frndId");
    }
  }

  String convertSelectedLangToString() {
    String dbString = '';
    for (Language lang in selectedLang.keys) {
      if (selectedLang[lang]!) {
        if (dbString.isEmpty) {
          dbString = lang.id.toString();
        } else {
          dbString = "$dbString,${lang.id}";
        }
      }
    }
    //debugPrint(dbString);
    return dbString;
  }

  void deletePost(int postId) async {
    debugPrint("deleting post with id: $postId");
    ownPosts!.removeWhere((element) => element.id == postId);
    notifyListeners();

    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("deleting post no_internet");
      return;
    } else {
      debugPrint("in terms of internet, we have internet");
    }

    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.post(
      'http://${dotenv.env['server_url']}/deletePost',
      data: {'id': postId},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("deleted post with id $postId");
    }
  }

  void getBookMarkList(String userId) {
    List<PostPojo> buffer = [];
    bookMarkIds = bookmarkBox.get(userId);
    //debugPrint(bookMarkIds.toString());
    if (bookMarkIds != null) {
      for (int postId in bookMarkIds!) {
        fetchMarkedPosts(postId, buffer);
      }
      bookMarkedPosts = buffer;
      notifyListeners();
    }
  }

  void fetchMarkedPosts(int postId, List<PostPojo> buffer) async {
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("fetchMarkedPosts() no_internet");
      return;
    } else {
      debugPrint("fetchMarkedPosts() called");
    }
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getPostByPostId',
      data: {'postId': postId},
      options: options,
    );
    if (response.statusCode == 200) {
      List<PostPojo> parsedPosts = postPojoFromJson(response.data, false);
      //debugPrint(parsedPosts[0].toString());
      buffer.add(parsedPosts[0]);
    }
  }
}
