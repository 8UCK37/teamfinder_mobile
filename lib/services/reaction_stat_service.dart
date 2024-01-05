import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../controller/network_controller.dart';

class ReactionStatService extends ChangeNotifier {
  NetworkController networkController = NetworkController();

  List<dynamic> allReactionList = [];
  List<dynamic> fireList = [];
  List<dynamic> hahaList = [];
  List<dynamic> loveList = [];
  List<dynamic> sadList = [];
  List<dynamic> shitList = [];

  void fetchReactionStat(int postId) async {
    if (await networkController.noInternet()) {
      debugPrint("fetchReactionStat() no_internet");
      return;
    } else {
      debugPrint("fetchReactionStat() called $postId");
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
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getReactionStatbyPostId',
      data: {'postId': postId},
      options: options,
    );

    if (response.statusCode == 200) {
      // Request successful
      var res = response.data;
      //debugPrint(res);
      allReactionList = jsonDecode(res);
      fireList = allReactionList
          .where((element) => element['type'] == 'like')
          .toList();
      hahaList = allReactionList
          .where((element) => element['type'] == 'haha')
          .toList();
      loveList = allReactionList
          .where((element) => element['type'] == 'love')
          .toList();
      sadList = allReactionList
          .where((element) => element['type'] == 'sad')
          .toList();   
      shitList = allReactionList
          .where((element) => element['type'] == 'poop')
          .toList();
      notifyListeners();
    }
  }
}
