import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';

class FriendProfileService extends ChangeNotifier {
  List<PostPojo>? friendPostList;
  UserPojo? friendProfile;
  dynamic twitchData;
  dynamic discordData;
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
      twitchData = response.data;
      notifyListeners();
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
      discordData = jsonDecode(response.data);
      notifyListeners();
    }
  }

  






}
