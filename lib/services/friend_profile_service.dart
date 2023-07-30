import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';

class FriendProfileService extends ChangeNotifier {
  List<PostPojo>? friendPostList;
  List<UserPojo>? friendList;
  UserPojo? friendProfile;
  dynamic steamData;
  dynamic twitchData;
  dynamic discordData;
  dynamic ownedGames = [];
  dynamic showcase = [];
  String friendStatus = "default";

  void erasePreviousProfile() {
    friendPostList = [];
    friendList = [];
    friendProfile = null;
    steamData = null;
    twitchData = null;
    discordData = null;
    ownedGames = [];
    showcase = [];
    friendStatus = "default";
    notifyListeners();
  }

  void updateFriendProfile(UserPojo newValue) {
    friendProfile = newValue;
    notifyListeners();
  }

  Future<void> getFriendProfileData(String id) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    //debugPrint(widget.friendId.toString());
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getUserInfo',
      data: {'id': id},
      options: options,
    );
    if (response.statusCode == 200) {
      friendProfile = userPojoListFromJson(response.data)[0];
      if (friendProfile!.steamId != null) {
        getSteamInfo(friendProfile!.steamId!);
      }
      notifyListeners();
    }
  }

  void updatePostList(List<PostPojo> newValue) {
    friendPostList = newValue;
    notifyListeners();
  }

  Future<void> getFriendsPosts(String id) async {
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
      data: {'uid': id},
      options: options,
    );
    if (response.statusCode == 200) {
      List<PostPojo> parsedPosts = postPojoFromJson(response.data);
      friendPostList = parsedPosts;
      notifyListeners();
    }
  }

  void updateFriendSteamInfo(dynamic newValue) {
    steamData = newValue;
    notifyListeners();
  }

  Future<void> getSteamInfo(String steamId) async {
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/steamInfo',
      data: {'steam_id': steamId},
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

  void updateFriendTwitchInfo(dynamic newValue) {
    twitchData = newValue;
    notifyListeners();
  }

  Future<void> getTwitchInfo(String id) async {
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
      queryParameters: {'id': id},
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

  Future<void> getDiscordInfo(String id) async {
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
      queryParameters: {'id': id},
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

  void updateFriendShowCase(dynamic newValue) {
    showcase = newValue;
    notifyListeners();
  }

  Future<void> getShowCase(String id) async {
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
      'http://${dotenv.env['server_url']}/getFrndOwnedGames',
      data: {'frnd_id': id},
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint('from line 140: ${jsonDecode(response.data).length}');
      if (jsonDecode(response.data).length != 0) {
        ownedGames = jsonDecode(jsonDecode(response.data)[0]['games']);
        notifyListeners();
        getSelectedGames(ownedGames, id);
      } else {
        ownedGames = [];
        showcase = [];
        notifyListeners();
      }
    }
  }

  Future<void> getSelectedGames(dynamic gamesList, String id) async {
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
      'http://${dotenv.env['server_url']}/getFrndSelectedGames',
      data: {'frnd_id': id},
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint(response.data.toString());
      dynamic res = jsonDecode(response.data)[0];
      //debugPrint(res.toString());
      showcase = [];
      for (dynamic game in gamesList) {
        game['selected'] = false;
        for (dynamic appid in res['appid'].split(',')) {
          if (game['appid'].toString() == appid.toString()) {
            game['selected'] = true;
            showcase.add(game);
          }
        }
      }
      showcase.sort((a, b) =>
          b['playtime_forever'].compareTo(a['playtime_forever']) as int);
      ownedGames = gamesList;
      //debugPrint('line 182 ${showcase.length.toString()}');
      notifyListeners();
    }
  }

  void updateFriendStatus(String newValue) {
    friendStatus = newValue;
    notifyListeners();
  }

  void getFriendStatus(String id) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/isFriend',
      data: {'id': id},
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint('line 205 ${response.data.toString()}');
      friendStatus = response.data;
      notifyListeners();
    }
  }

  void updateFriendList(List<UserPojo>? newValue) {
    friendList = newValue;
    notifyListeners();
  }

  void getFriendList(String id) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/friendsoffriendData',
      data: {'frnd_id': id},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint('line 290 ${response.data.length.toString()}');
      friendList = userPojoListFromJson(jsonEncode(response.data));
      debugPrint('line 292 ${friendList.toString()}');
      notifyListeners();
    }
  }
}
