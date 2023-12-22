import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import '../controller/network_controller.dart';

class IncomingNotification {
  final String senderId;
  final String senderProfilePicture;
  final String senderName;
  final String notification;
  final dynamic data;

  IncomingNotification(
      {required this.senderId,
      required this.senderProfilePicture,
      required this.senderName,
      required this.notification,
      required this.data});
}

class NotificationWizard extends ChangeNotifier {
  List<IncomingNotification> incomingNotificationList = [];
  Map<String, bool>? onlineMap;
   List<UserPojo>? friendList = [];
  
  void updateOnlineMap(Map<String, bool>? newMap) {
    onlineMap = newMap;
    notifyListeners();
  }

  void updateFriendList(List<UserPojo>? newValue) {
    friendList = newValue;
    notifyListeners();
  }

  void parseNotification(dynamic data) {
    if (data['notification'] == "disc") {
      onlineMap![data['sender']] = false;
      notifyListeners();
      return;
    } else if (data['notification'] == "online") {
      onlineMap![data['sender']] = true;
      notifyListeners();
      return;
    } else if (data['notification'] != "imageUploadDone") {
      getUserInfo(data);
    }
  }

  Future<void> getUserInfo(dynamic data) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getUserInfo',
      data: {'id': data['sender']},
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint(response.data.toString());
      UserPojo senderData = UserPojo.fromJson(response.data[0]);
      //debugPrint(senderData.profilePicture);
      IncomingNotification newNoti = IncomingNotification(
          senderId: senderData.id,
          senderProfilePicture: senderData.profilePicture,
          senderName: senderData.name,
          notification: data['notification'],
          data: data['data']);
      if (newNoti.notification != "online" &&
          newNoti.notification != "disc" &&
          newNoti.notification != "imageUploadDone") {
        addToNotificationList(newNoti);
      }
    }
  }

  void getFriendList() async {
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("_getFriendList() no_internet");
      return;
    } else {
      debugPrint("_getFriendList() called");
    }
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    //print('friend list called');
    final response = await dio.get(
      'http://${dotenv.env['server_url']}/friendData',
      options: options,
    );

    if (response.statusCode == 200) {
      // Request successful
      var res = response.data;
      //debugPrint(res);
      // Parse the JSON response into a list of PostPojo objects
      List<UserPojo> parsedFriendList = userPojoListFromJson(res);
      
          parsedFriendList.sort((a, b) {
            if (a.isConnected && !b.isConnected) {
              return -1; // a comes before b
            } else if (!a.isConnected && b.isConnected) {
              return 1; // b comes before a
            } else {
              return 0; // order remains the same
            }
          });
          onlineMap = {
            for (var obj in parsedFriendList) obj.id: obj.isConnected
          };
          updateOnlineMap(onlineMap);
          updateFriendList(parsedFriendList);
          //friendList = parsedFriendList; // Update the state variable with the parsed list
    }
  }
  
  void addToNotificationList(IncomingNotification newValue) {
    // debugPrint(newValue.senderId);
    // debugPrint(newValue.notification);
    // debugPrint(newValue.data?.toString());
    incomingNotificationList.add(newValue);
    notifyListeners();
  }
}
