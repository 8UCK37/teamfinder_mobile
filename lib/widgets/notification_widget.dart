import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';

class NotificationWidget extends StatelessWidget {

  final IncomingNotification notification;

  const NotificationWidget({super.key, 
    required this.notification
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                backgroundImage: NetworkImage(notification.senderProfilePicture),
                radius: 35.0,
              ),

              const SizedBox(width: 15.0),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(notification.notification, style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                  Text('notification.time', style: const TextStyle(fontSize: 15.0, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.more_horiz),
              Text(''),
            ],
          )
        ],
      ),
    );
  }
}