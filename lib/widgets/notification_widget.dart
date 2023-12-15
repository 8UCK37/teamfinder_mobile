import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';

class NotificationWidget extends StatelessWidget {
  final IncomingNotification notification;

  const NotificationWidget({super.key, required this.notification});

  String notificationTextParser() {
    String notificationText = '';
    switch (notification.notification) {
      case 'poke':
        notificationText = 'has poked you';
        break;
      case 'frnd req':
        notificationText = 'has sent you a friend request!!';
        break;
      case 'frndReqAcc':
        notificationText = 'has accepted your friend request!!';
        break;
      case 'new mention':
        notificationText = 'has mentioned you in a new post!!';
        break;
      case 'new comment':
        notificationText = 'has mentioned you in a new comment!!';
        break;
      default:
        notificationText = 'idk wtf this notification is!!';
    }
    return notificationText;
  }

  String getCurrentTimeAndDate() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate ="${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}";
    String formattedTime ="${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}";

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

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage:
                    NetworkImage(notification.senderProfilePicture),
                radius: 35.0,
              ),
              const SizedBox(width: 15.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: MediaQuery.of(context).size.width-150,
                    child: RichText(
                        text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                          TextSpan(
                              text: notification.senderName,
                              style: const TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: ' ${notificationTextParser()}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ])),
                  ),
                  Text(getCurrentTimeAndDate(),
                      style: const TextStyle(fontSize: 15.0, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              Icon(Icons.more_vert),
              Text(''),
            ],
          )
        ],
      ),
    );
  }
}
