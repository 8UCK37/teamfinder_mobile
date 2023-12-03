import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:http/http.dart' as http;
import 'package:teamfinder_mobile/utils/language_chip_helper.dart';

class ProviderService extends ChangeNotifier {
  Map<String, dynamic> user = {}; // Initialize as an empty map
  List<PostPojo>? feed;
  List<PostPojo>? ownPosts;
  dynamic steamData;
  dynamic twitchData;
  dynamic discordData;
  bool? darkTheme = false;
  int? replyingTo;
  Map<Language, bool> selectedLang = {};

  void updateCurrentUser(Map<String, dynamic> newValue) {
    user = newValue;
    notifyListeners();
  }

  void updateTheme(bool newValue) {
    darkTheme = newValue;
    notifyListeners();
  }

  void updateReplyingTo(int? newValue) {
    replyingTo = newValue;
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

  void fetchPosts() async {
    final url = Uri.parse('http://${dotenv.env['server_url']}/getPost');
    final user = FirebaseAuth.instance.currentUser;
    //debugPrint('fetch post called');
    if (user != null) {
      final idToken = await user.getIdToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        // Request successful
        var res = response.body;
        //print(res);
        // Parse the JSON response into a list of PostPojo objects
        List<PostPojo> parsedPosts = postPojoFromJson(res);
        feed = parsedPosts; // Update the state variable with the parsed list
        notifyListeners();
      }
    }
  }

  void updateOwnPosts(List<PostPojo> newValue) {
    ownPosts = newValue;
    notifyListeners();
  }

  Future<void> getOwnPost() async {
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
      List<PostPojo> parsedPosts = postPojoFromJson(response.data);
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
    //debugPrint(userInfo['Language'].toString());
    selectedLangList = userInfo['Language'].split(",");
    var newMap = Language.map();
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

  
}
