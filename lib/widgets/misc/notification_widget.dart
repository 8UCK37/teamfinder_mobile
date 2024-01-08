import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import 'package:teamfinder_mobile/widgets/misc/notification_option.dart';
import '../../friend_profile_ui/friend_profilehome.dart';
import '../../pojos/incoming_notification.dart';

class NotificationWidget extends StatelessWidget {
  final IncomingNotification notification;
  final Animation<double> animation;
  final VoidCallback? removeClicked;
  const NotificationWidget(
      {super.key, required this.notification, required this.animation, this.removeClicked});

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
      case 'post mention':
        notificationText = 'has mentioned you in a new post!!';
        break;
      case 'new comment':
        notificationText = 'has commented on you post!!';
        break;
      default:
        notificationText = 'idk wtf this notification is!!';
    }
    return notificationText;
  }

  @override
  Widget build(BuildContext context) {
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
    final userService = Provider.of<ProviderService>(context, listen: true);
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return SlideTransition(
        key: ValueKey(timestamp),
        position: Tween<Offset>(
        begin:const Offset(1, 0),
        end:Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FriendProfileHome(
                      friendId: notification.senderId,
                      friendName: notification.senderName,
                      friendProfileImage: notification.senderProfilePicture,
                    )),
          );
        },
        child: Container(
          decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color:Colors.grey
              // top: BorderSide(color: Colors.grey, width: 1),
              // bottom: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: (notification.notification != "frnd req") ? 75 : 100,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: (notification.notification == "poke")
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          cacheKey: "notification_avatar$timestamp",
                          notification.senderProfilePicture),
                      radius: 25.0,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        child: RichText(
                            text: TextSpan(
                                style:const TextStyle(
                                    color:  Colors.black),
                                children: [
                              TextSpan(
                                  text: notification.senderName,
                                  style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' ${notificationTextParser()}',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ])),
                      ),
                      Text(notification.timeStamp,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.grey)),
                      if (notification.notification == "frnd req")
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                debugPrint("accept: ${notification.senderId}");
                                userService.acceptReq(notification.senderId);
                                int index = notiObserver.incomingNotificationList
                                    .indexOf(notification);
                                //debugPrint(index.toString());
                                notiObserver.removeNotificationFromList(index,userService.user['id']);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: const Text('Confirm',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0)),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () async {
                                debugPrint("reject: ${notification.senderId}");
                                userService.rejectReq(notification.senderId);
                                int index = notiObserver.incomingNotificationList
                                    .indexOf(notification);
                                //debugPrint(index.toString());
                                notiObserver.removeNotificationFromList(index,userService.user['id']);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: const Text('Reject',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15.0)),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  //debugPrint("elipsis clicked");
                  //userService.rejectReq(user["id"]);
                  showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Wrap(children: [
                        NotificationOptions(
                          notification: notification,
                          removeClicked: removeClicked,
                        )
                      ]);
                    },
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      color:Colors.teal,
                      Icons.more_vert),
                    Text(''),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
