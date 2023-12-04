import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';

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
      debugPrint(senderData.profilePicture);
      IncomingNotification newNoti = IncomingNotification(
          senderId: senderData.id,
          senderProfilePicture: senderData.profilePicture,
          senderName: senderData.name,
          notification: data['notification'],
          data: data['data']);

      if (newNoti.notification != "online" && newNoti.notification != "disc" && newNoti.notification != "imageUploadDone") {
        addToNotificationList(newNoti);
      } 
    }
  }

  void addToNotificationList(IncomingNotification newValue) {
    debugPrint(newValue.senderId);//TODO remove these!!
    debugPrint(newValue.notification);
    debugPrint(newValue.data?.toString());
    incomingNotificationList.add(newValue);
    notifyListeners();
  }
}
