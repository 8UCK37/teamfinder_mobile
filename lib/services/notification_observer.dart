import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import '../controller/network_controller.dart';
import 'package:hive/hive.dart';
import '../pojos/incoming_notification.dart';
// Generated file

class NotificationWizard extends ChangeNotifier {
  List<IncomingNotification> incomingNotificationList = [];
  Map<String, bool>? onlineMap;
  List<UserPojo>? friendList = [];

  final notificationBox = Hive.box('notificationBox');

  void writeTonotificationBox(String userId) {
    //debugPrint("writing to this user's notiBox: $userId");
    notificationBox.put(userId, incomingNotificationList);
  }

  void readNotificationBox(String userId) {
    //debugPrint('noti obs 29: $userId');
    if (notificationBox.get(userId) != null) {
      List<dynamic> newList = notificationBox.get(userId);
      for (IncomingNotification savedNoti in newList) {
        incomingNotificationList.add(savedNoti);
      }
    }
  }

  void updateNotiList(List<IncomingNotification> newValue) {
    incomingNotificationList = newValue;
    notifyListeners();
  }

  void deleteAllNotification(String userId) {
    notificationBox.delete(userId);
    incomingNotificationList = [];
    notifyListeners();
  }

  void updateOnlineMap(Map<String, bool>? newMap) {
    onlineMap = newMap;
    notifyListeners();
  }

  void updateFriendList(List<UserPojo>? newValue) {
    friendList = newValue;
    notifyListeners();
  }

  void removeNotificationFromList(int index, String userId) {
    incomingNotificationList.removeAt(index);
    notificationBox.put(userId, incomingNotificationList);
    notifyListeners();
  }

  void parseNotification(dynamic data, String userId) {
    if (onlineMap == null) {
      return;
    }
    if (data['notification'] == "disc") {
      onlineMap![data['sender']] = false;
      notifyListeners();
      return;
    } else if (data['notification'] == "online") {
      onlineMap![data['sender']] = true;
      notifyListeners();
      return;
    } else if (data['notification'] != "imageUploadDone") {
      getUserInfo(data, userId);
    }
  }

  String getCurrentTimeAndDate() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate =
        "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}";
    String formattedTime =
        "${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}";

    // Combine date and time
    String result = "$formattedDate $formattedTime";

    return result;
  }

  // Helper function to ensure two digits for date and time components
  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  Future<void> getUserInfo(dynamic data, String userId) async {
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
          data: data['data'],
          timeStamp: getCurrentTimeAndDate());

      if (newNoti.notification != "online" &&
          newNoti.notification != "disc" &&
          newNoti.notification != "imageUploadDone") {
        addToNotificationList(newNoti);
        // ignore: use_build_context_synchronously
        writeTonotificationBox(userId);
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
      onlineMap = {for (var obj in parsedFriendList) obj.id: obj.isConnected};
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
